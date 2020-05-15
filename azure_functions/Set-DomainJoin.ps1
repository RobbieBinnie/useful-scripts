function Set-DomainJoin {
    [cmdletbinding()]
    param(
        [parameter(Mandatory  = $false,
            ValueFromPipeline = $true)]
        $pipelineInput,
        [parameter(Mandatory  = $false)]
        $vmId,
        [parameter(Mandatory  = $true)]
        $kv,
        [parameter(Mandatory  = $true)]
        $kvSecretName,
        [parameter(Mandatory  = $true)]
        $username,
        [parameter(Mandatory  = $true)]
        $domain,
        [parameter(Mandatory  = $true)]
        $ouPath,
        [switch]$WhatIf = $false

    )
    Begin {
        # check if a VM id is provided (and use it, if it is)
        if ($vmId -like "*subscriptions/*"){
            Write-Host "VM ID variable set"
            $resource = Get-AzResource -ResourceId $vmId
            $pipelineInput = Get-AzVm -ResourceGroupName $resource.ResourceGroupName -name $resource.Name
        }else {
            Write-Host "Using pipeline input"
        }
        
        # Get the password of the user that will carry out the domain joining for keyvault
        $sec = Get-AzKeyVaultSecret -VaultName $kv -Name $kvSecretName
        Write-Host "Got secret, trying to domain join..."

        # create the JSON for the 'public' settings 
        $globalVars = '{
            "Name": "<name>",
            "OUPath": "<ou>",
            "User": "<user>",
            "Restart": "true",
            "Options": "3"
}'`
        -replace "<name>","$domain" `
        -replace "<user>","$username" `
        -replace "<ou>","$ouPath"
    
        # create the JSON for the 'private' settings 
        $secretVars = '{
            "Password": "<pass>"
}'`
        -replace "<pass>","$($sec.SecretValueText)"    

        Write-Host "Using variables`n$globalVars"
        Write-Host "-------------------------------------------------------------------------------"
    }
    Process {
        # loop here to allow the different ways in which piped inputs can be used
        foreach ($vm in $pipelineInput) {
            # check if WhatIf flag is set
            if ($WhatIf -eq $false){
                Write-Host "Starting domain join of: $($vm.name)"
                # carry out domain join
                set-AzVmExtension -resourceGroupName $vm.ResourceGroupName -ExtensionType "JsonADDomainExtension" `
                    -Name "joindomain" -Publisher "Microsoft.Compute" -TypeHandlerVersion "1.3" `
                    -VMName $vm.name -Location $vm.location -SettingString $globalVars `
                    -ProtectedSettingString $secretVars
            }else {
                # Write out the vm names only if WhatIf flag is set
                # Update this in the future to check DNS settings
                Write-Host "Starting domain join of: $($vm.name) -WhatIf"
            }
        }
    }
    End {
        Write-Host "-------------------------------------------------------------------------------"
        Write-Host "Completed domain join"`n
    }
}
