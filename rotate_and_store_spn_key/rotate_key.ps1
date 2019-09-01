
# https://portal.azure.com/#blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/RolesAndAdministrators
# added the application administrator role to this spn
# This currently works in a pipeline - would need a little tinkering to make it work in an automation account
param(
    $spnPass,
    $spnApp,
    $tenantId,
    $keyVaultName,
    $rotateSpnName
)

# create credential block and log into azure
$passwd = ConvertTo-SecureString $spnPass -AsPlainText -Force
$pscredential = New-Object System.Management.Automation.PSCredential($spnApp , $passwd)
Connect-AzAccount -ServicePrincipal -Credential $pscredential -TenantId $tenantId

$spn = Get-AzADServicePrincipal -DisplayName $rotateSpnName
$oldkeys = $($spn | Get-AzADSpCredential)

$pass = New-AzADSpCredential -objectId $spn.id

### id prefer to remove this - its really just to validate the auth test (i convert back to sec string)
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass.Secret)
$UnsecurePassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

# upload to keyvault
$secretvalue = ConvertTo-SecureString $UnsecurePassword -AsPlainText -Force
$secret = Set-AzKeyVaultSecret -VaultName $keyVaultName -Name $rotateSpnName -SecretValue $secretvalue

# maybe test auth?
if ((Get-AzKeyVaultSecret -vaultName $keyVaultName -name $rotateSpnName).SecretValueText -eq $UnsecurePassword){
    echo "passwords match"
}else{
    echo "passwords dont match"
}

# remove old 
foreach ($oldkey in $oldkeys){
    Remove-AzADSpCredential -ObjectId $spn.id -KeyId $oldkey.KeyId -force
}

$mute = remove-azaccount