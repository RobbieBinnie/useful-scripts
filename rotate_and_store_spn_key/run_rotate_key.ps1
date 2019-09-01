$spnPass = "ad64d15e-f1ea-46fd-8cc6-38d992105cd8"
$spnApp = "fce5f006-a8e7-4c38-8d07-ea46e9a29762"
$tenantId = "194708e3-3e3f-4876-94ee-53bc402f19b5" 
$keyVaultName = "myspnkeyvault" 
$rotateSpnName = "spn-rotate"


./rotate_key.ps1 -spnPass $spnPass `
    -spnApp $spnApp `
    -tenantId $tenantId `
    -keyVaultName $keyVaultName `
    -rotateSpnName $rotateSpnName


