# Create the Policy Definition (Subscription scope)
$definition_support = New-AzPolicyDefinition -Name "enforced-tags-support" -DisplayName "Enforced Tags Support" -Metadata '{"category":"Tags"}' -description "This policy will enforce the support tag and ensure it contains the correct sub tags" -Policy './policy_support.json' -Mode All

$definition_info = New-AzPolicyDefinition -Name "enforced-tags-info" -DisplayName "Enforced Tags Info" -Metadata '{"category":"Tags"}' -description "This policy will enforce the info tag and ensure it contains the correct sub tags" -Policy './policy_info.json' -Mode All

$definition_resiliancy = New-AzPolicyDefinition -Name "enforced-tags-resiliancy" -DisplayName "Enforced Tags Resiliancy" -Metadata '{"category":"Tags"}' -description "This policy will enforce the resiliancy tag and ensure it contains the correct sub tags" -Policy './policy_resiliency.json' -Mode All

$policySetDefinition = @"
[
   {
        "policyDefinitionId": "$($definition_support.PolicyDefinitionId)"
   },
   {
        "policyDefinitionId": "$($definition_info.PolicyDefinitionId)"
    },   
    {
        "policyDefinitionId": "$($definition_resiliancy.PolicyDefinitionId)"
    }
]
"@

$policySet = New-AzPolicySetDefinition -Name 'enforced-tags' -DisplayName 'Enforced Tags Set' -Metadata '{"category":"Tags"}' -PolicyDefinition $policySetDefinition

$sub_id = ""

New-AzPolicyAssignment -Name 'enforced-tags-assignment' -DisplayName 'Enforced Tags Assignment' -Scope "/subscriptions/$($sub_id)" -PolicySetDefinition  $policySet

