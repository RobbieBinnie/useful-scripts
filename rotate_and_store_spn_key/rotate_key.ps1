
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
# this is the bit that will change for an autoamtion account
$passwd = ConvertTo-SecureString $spnPass -AsPlainText -Force
$pscredential = New-Object System.Management.Automation.PSCredential($spnApp , $passwd)
Connect-AzAccount -ServicePrincipal -Credential $pscredential -TenantId $tenantId

# read a copy of the spn
$spn = Get-AzADServicePrincipal -DisplayName $rotateSpnName
$oldkeys = $($spn | Get-AzADSpCredential)

# create a new credential for the spn
$pass = New-AzADSpCredential -objectId $spn.id

### id prefer to remove this - its really just to validate the uploaded secret matches the one on the SPN (i convert back to sec string before upload)
# convert it from a secure string to a normal one for validation the right thing has been uploaded
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass.Secret)
$UnsecurePassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

# convert back to secure string and upload to keyvault
$secretvalue = ConvertTo-SecureString $UnsecurePassword -AsPlainText -Force
$secret = Set-AzKeyVaultSecret -VaultName $keyVaultName -Name $rotateSpnName -SecretValue $secretvalue

# verify that the thing in keyvault matches key set on SPN
if ((Get-AzKeyVaultSecret -vaultName $keyVaultName -name $rotateSpnName).SecretValueText -eq $UnsecurePassword){
    echo "passwords match"
}else{
    echo "passwords dont match"
}

# remove old keys
foreach ($oldkey in $oldkeys){
    Remove-AzADSpCredential -ObjectId $spn.id -KeyId $oldkey.KeyId -force
}

# log out of account
$mute = remove-azaccount