param (
    $resourceType = "",
    $resourceGroup = "",
    $name = "",
    $resources = "",
    $tagName = "name",
    $output = "id"
)

function limitByResourceType {
    param (
        $resource,
        $resourceType
    )
    # return resources where the types match
    $resource = $resource | where {$_.ResourceType -eq $resourceType}

    return $resource
}

function limitByResourceGroup {
    param (
        $resource,
        $resourceGroup
    )
    # return resources where the groups match
    $resource = $resource | where {$_.ResourceGroupName -eq $resourceGroup}

    return $resource
}

function limitByTag {
    param (
        $resource,
        $tagName
    )
    # check that there is a tags object
    $resource = $resource | where {$_.Tags -ne $null}
    # check that the tag key is present in the tag
    $resource = $resource | where {$_.Tags.Keys.Contains("$tagName") -eq $True}

    return $resource
}

function limitByTagName {
    param (
        $resource,
        $tagName,
        $name
    )
    # check that there is at least 1 item in the list
    if ($resource.count -gt 0){
        # check that the tag with the correct name, has the correct value
        $resource = $resource | where {$_.Tags["$tagName"] -eq $name}
    }

    return $resource
}


# get all resources
# the if statment allows resource objects to be passed into the script
if ($resources -eq ""){
    $resource = Get-AzResource
}else{
    $resource = $resources
}

# if the resource type is set, apply that limit
if ($resourceType -ne ""){
    $resource = limitByResourceType -resource $resource -resourceType $resourceType
}

# if the resource group is set, apply that limit
if ($resourceGroup -ne ""){
    $resource = limitByResourceGroup -resource $resource -resourceGroup $resourceGroup
}

# limit the list by having tags and the tag name
$resource = limitByTag -resource $resource -tagName $tagName

# limit the list by the tag value
$resource = limitByTagName -resource $resource -tagName $tagName -name $name

if ($output -ne "all"){
    $resource | select $output
} else{
    $resource
}
