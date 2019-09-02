function Check-VmType {
    param (
        $VmObject
    )
    
    if ($VmObject.StorageProfile.OSDisk.OSType -eq "Windows"){
        return "windows"
    }elseif ($VmObject.StorageProfile.OSDisk.OSType -eq "Linux") {
        if ($VmObject.StorageProfile.ImageReference.Publisher){
            $fullOs = "$($VmObject.StorageProfile.ImageReference.Publisher):$($VmObject.StorageProfile.ImageReference.Offer):$($VmObject.StorageProfile.ImageReference.Sku)"
            return $fullOs
        }else{
            return "linux"
        }
    }
}

function Get-TagString {
    param (
        $VmObject,
        $tags
    )
    $tagsString = ""
    if ($tags[0] = "all"){
        foreach ($tag in $VmObject.Tags.Keys){
            $tagsString += "$tag=$($VmObject.Tags["$tag"]);"
        }
    }else{
        foreach ($tag in $tags){
            $tagsString += "$tag=$($VmObject.Tags["$tag"]);"
        }
    }

    return $tagsString
}

##### this is used for all subs
param(
    $subs = @("all"),
    $tags = @("all")
)

if ($subs[0] = "all"){
    $subs = Get-azSubscription
}

$number = $subs.count
$vms = @()
$count = 0
echo "there are $number subscriptions"
foreach ($sub in $subs) {
    Set-AzContext -Subscriptionid $sub.Id | out-null
    $vms += get-azvm

    $count = $count + 1
    $percentval = [int]($count/$number * 100)
    echo "completed sub: $($sub.id), we are at $($percentval)%"

}

echo "name,type,owner,subscription (id),VM id,tags" > vmlist.csv

foreach ($vm in $vms){
    $vmtype = Check-VmType -VmObject $vm
    $subid = $vm.id.split("/")[2]
    $owner = ""
    $tagsString = Get-TagString -VmObject $vm -tags $tags

    echo "$($vm.name),$vmtype,$owner,$subid,$($vm.id),$tagsString" >> vmlist.csv

}
