# Audit VM estate

This program can be used to list out (as a csv) all of the vms and some information about them

## Running the script
Example of how to run it shown in run_find_vm_info.ps1, variables listed below:

| variable name | example | description |
|---------------|---------|-------------|
| subs | @("ad64d15e-f1ea-46fd-8cc6-38d992105cd8", "fce5f006-a8e7-4c38-8d07-ea46e9a29762") | A list of all the subscriptions to include in the audit (@("all") also avaiable) |
| tags | @("all") | a list of tags to include in the audit (@("all") also available) |
