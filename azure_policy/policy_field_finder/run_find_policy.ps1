$field_to_match = "sqlServerLicenseType"
$nameSpace = "Microsoft.SqlVirtualMachine"
$resourceType = " "


./find_policy.ps1 -field_to_match $field_to_match `
    -nameSpace $nameSpace `
    -resourceType $resourceType