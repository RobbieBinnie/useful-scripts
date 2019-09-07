# Search current policy aliases

This program is designed to search through aliases on Azure policies. This is really to help establish if the alias has already been added or if it needs to be requested. It can then help translate the field in the ARM JSON into the Azure policy path.

In some cases the path used in azure policy doesnt match the json object reference that it is trying to point to in ARM, this should help find the path from the object.

## Running the script
Example of how to run it shown in run_find_policy.ps1, variables listed below:

| variable name | example | description |
|---------------|---------|-------------|
| field_to_match | sqlServerLicenseType        | This is the field in the ARM template that you are trying to lookup (i.e. properties.sqlServerLicenseType) - a like is used so doesnt have to be exact  |
| nameSpace      | Microsoft.SqlVirtualMachine | This is the block before the resource type in the ID |
| resourceType   | SqlVirtualMachines          | This is the resource type (it can normally be found in the ID), can be left blank if not known, this field can be left blank |

