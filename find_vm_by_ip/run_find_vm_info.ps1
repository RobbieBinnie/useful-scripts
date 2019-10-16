# search using all subs
./find_vm_info.ps1 -ip "10.0.0.5"

# search using a single sub
$subs = "ad64d15e-f1ea-46fd-8cc6-38d992105cd8"
./find_vm_info.ps1 -subs $subs `
    -ip "10.0.0.5"

#search using a list of subs
$subs = @("28e9127f-4532-454d-1234-43b321904c64","b071ec1d-frww-4fa9-ffs3-d0c6b4672522","5e813cbb-33wq-33d2-sm21-887fb638adb5")
./find_vm_info.ps1 -subs $subs `
    -ip "10.0.0.5"