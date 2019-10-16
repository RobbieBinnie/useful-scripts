# Find VM by IP address

This program can be used to find vms with a specified IP address

## Running the script
Example of how to run it shown in run_find_vm_by_ip.ps1, variables listed below:

| variable name | example | description |
|---------------|---------|-------------|
| subs | @("ad64d15e-f1ea-46fd-8cc6-38d992105cd8", "fce5f006-a8e7-4c38-8d07-ea46e9a29762") | A list of all the subscriptions to include in the audit (@("all") also avaiable by default) |
| ip | 10.0.0.1 | the ip address that is being searched for |
