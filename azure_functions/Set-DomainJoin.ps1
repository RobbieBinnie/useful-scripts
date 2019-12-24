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
        if ($vmId -like "*subscriptions/*"){
            Write-Host "VM ID variable set"
            $resource = Get-AzResource -ResourceId $vmId
            $pipelineInput = Get-AzVm -ResourceGroupName $resource.ResourceGroupName -name $resource.Name
        }else {
            Write-Host "Using pipeline input"
        }

        $sec = Get-AzKeyVaultSecret -VaultName $kv -Name $kvSecretName
        Write-Host "Got secret, trying to domain join..."

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
    
        $secretVars = '{
            "Password": "<pass>"
}'`
        -replace "<pass>","$($sec.SecretValueText)"    

        Write-Host "Using variables`n$globalVars"
        Write-Host "-------------------------------------------------------------------------------"
    }
    Process {
        foreach ($vm in $pipelineInput) {
            if ($WhatIf -eq $false){
                Write-Host "Starting domain join of: $($vm.name)"
                set-AzVmExtension -resourceGroupName $vm.ResourceGroupName -ExtensionType "JsonADDomainExtension" `
                    -Name "joindomain" -Publisher "Microsoft.Compute" -TypeHandlerVersion "1.3" `
                    -VMName $vm.name -Location $vm.location -SettingString $globalVars `
                    -ProtectedSettingString $secretVars
            }else {
                Write-Host "Starting domain join of: $($vm.name) -WhatIf"
            }
        }
    }
    End {
        Write-Host "-------------------------------------------------------------------------------"
        Write-Host "Completed domain join"`n
    }
}
