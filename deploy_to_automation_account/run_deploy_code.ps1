$runbookList = @("runbook1", "runbook2", "runbook3", "runbook4")
$runbookType = "PowerShell"
$automationAccountName =  "2345"
$resourceGroupName = "2345"
$scriptRoute = "/2345323454322/2345432454/34543234543/"
$runInParallel = $true


./deploy_code.ps1 -runbookList $runbookList `
    -runbookType $runbookType `
    -automationAccountName $automationAccountName `
    -resourceGroupName $resourceGroupName `
    -scriptRoute $scriptRoute `
    -runInParallel $runInParallel 