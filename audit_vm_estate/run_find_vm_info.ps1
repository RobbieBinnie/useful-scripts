$subs = @("ad64d15e-f1ea-46fd-8cc6-38d992105cd8")
$tags = @("owner","app")


./find_vm_info.ps1 -subs $subs `
    -tags $tags > audit.csv

