
$resourceType = ""
$resourceGroup = ""
$name = "azure-cloud-shell"
$tagName = "ms-resource-usag"
$output = "all"

# use this to pass in full resource objects (i.e. azvm)
$resources = Get-AzResource
# use this to use the build in object searching
$resources = ""

./Get-ResourceByTag.ps1 `
    -name $name `
    -tagName $tagName `
    -output $output `
    -resourceGroup $resourceGroup `
    -resourceType $resourceType `
    -resources $resources