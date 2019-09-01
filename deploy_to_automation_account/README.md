# Deploy code to automation account

This program can be used to deploy code to automation accounts

## Running the script
Example of how to run it shown in run_deploy_code.ps1, variables listed below:

| variable name | example | description |
|---------------|---------|-------------|
| runbookList           | @("runbook1", "runbook2")            | A list of runbooks to deploy, this is used for both the file name and the automation account runbook |
| runbookType           | PowerShell                           | The type of runbook to deploy (powershell, python, etc) |
| automationAccountName | automationaccount01                  | The name of the automation account |
| resourceGroupName     | myaarg                               | The name of the resource group |
| scriptRoute           | /Users/myusername/Documents/aa_code/ | The path to the scripts (must end in /) |
| runInParallel         | $true                                | Should powershell jobs be used to run deployment in parallel |

 