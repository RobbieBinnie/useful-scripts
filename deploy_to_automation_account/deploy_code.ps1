param(
    $runbookList,
    $runbookType,
    $automationAccountName,
    $resourceGroupName,
    $scriptRoute,
    $runInParallel = $false

)

# variable used to define the upload runbook script
$function = {
    function DeployScript { 
        param (
            $runbookName,
            $resourceGroupName,
            $automationAccountName,
            $scriptRoute,
            $runbookType
        )

        if ($runbookType -in @("PowerShell","PowerShellWorkflow")){
            $extension = ".ps1"
        } elseif ($runbookType -in @("GraphicalPowershell","GraphicalPowerShellWorkflow","Graph")) {
            $extension = ".graphrunbook"
        } else {
            $extension = ".py"
        }
        # set up the path for the script
        $scriptPath = "$scriptRoute$runbookName$extension"
        
        echo "running powershell for $runbookName, on $scriptpath"

        # remove the runbook
        echo "  Removing runbook"
        Remove-AzAutomationRunbook -Name $runbookName `
            -ResourceGroupName $resourceGroupName `
            -AutomationAccountName $automationAccountName `
            -Force

        # import the runbook
        echo "  Importing runbook"
        Import-AzAutomationRunbook -Name $runbookName `
            -Path $scriptPath `
            -ResourceGroupName $resourceGroupName `
            -AutomationAccountName $automationAccountName `
            -Type $runbookType

        # publish the runbook
        echo "  Publishing runbook"
        Publish-AzAutomationRunbook -AutomationAccountName $automationAccountName `
            -Name $runbookName `
            -ResourceGroupName $resourceGroupName

    }
}


foreach ($runbookName in $runbookList) {
    if ($runInParallel){
        # start-job loads deploy script function first
        start-job -InitializationScript $function -ArgumentList @("$runbookName","$resourceGroupName","$automationAccountName",$scriptRoute,$runbookType) -ScriptBlock {
            DeployScript -runbookName $args[0] `
                -resourceGroupName $args[1] `
                -automationAccountName $args[2] `
                -scriptRoute $args[3] `
                -runbookType $args[4]    
    }
    }else{
        # if not running in parallel execute the same script, but not as a job
        invoke-expression "$function; DeployScript -runbookName $runbookName -resourceGroupName $resourceGroupName -automationAccountName $automationAccountName -scriptRoute $scriptRoute -runbookType $runbookType;"
    }
}

# if running in parallel wait for the jobs to complete
if ($runInParallel){
    # wait for the job to be done
    Get-Job | Wait-Job
    # write output of job
    Get-Job | Receive-Job 
    # clean up job   
    Get-Job | Remove-Job    
}
