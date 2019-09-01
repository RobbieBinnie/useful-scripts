param (
    $field_to_match,
    $nameSpace,
    $resourceType = " "
)

$policies = Get-AzPolicyAlias -NamespaceMatch $nameSpace -ResourceType $resourceType

foreach ($policy in $policies) {
    # echo "$($policy.ResourceType)"
    $aliases = $policy | select -ExpandProperty Aliases
    foreach ($alias in $aliases){
        # echo "$($alias.Name)"
        $paths = $alias | select -ExpandProperty Paths
        foreach ($path in $paths){
            # echo "$($path.Path)"
            if ($path.Path -like "*$field_to_match*"){
                echo  "found a match!! $($path.Path) for alias $($alias.Name)"
            }
        }
    }
}

echo "Further aliases can be added by opening an issue here: https://github.com/Azure/azure-policy/issues?utf8=%E2%9C%93&q=is%3Aissue+is%3Aclosed"