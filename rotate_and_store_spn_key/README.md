# Update spn key and store it in keyvault

This program is designed to rotate SPN keys and then store the updated one in keyvault. It is designed to be run nightly in a pipeline, which passes in the authentication methods securely; however, with a few modifications could be run in an automation account, and make use of the credential store there.

The spn that is used to rotate the keys will either need the application administrator role, or be the owner of the spns which it is rotating.

This script also assumes that the display name of the SPN will match the secret name in keyvault

## Running the script
Example of how to run it shown in run_rotate_key.ps1, variables listed below (the guids for the SPN are obviously fake...):

| variable name | example | description |
|---------------|---------|-------------|
| spnPass       | ad64d15e-f1ea-46fd-8cc6-38d992105cd8 | The key for the spn that is used to rotate other keys |
| spnApp        | fce5f006-a8e7-4c38-8d07-ea46e9a29762 | The application ID of the SPN that is used to rotate other keys |
| tenantId      | 194708e3-3e3f-4876-94ee-53bc402f19b5 | The ID of the azure tenant |
| keyVaultName  | myspnkeyvault                        | The name of the keyvault which stores the SPN keys |
| rotateSpnName | spn-rotate                           | The display name of the SPN which should have its keys rotated |
