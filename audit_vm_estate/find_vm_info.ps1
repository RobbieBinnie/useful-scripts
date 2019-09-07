##### this is used for all subs
param(
    $subs = @("all"),
    $tags = @("all")
)

function Check-VmType {
    param (
        $VmObject
    )
    
    if ($VmObject.StorageProfile.ImageReference.Publisher){
        $fullOs = "$($VmObject.StorageProfile.ImageReference.Publisher):$($VmObject.StorageProfile.ImageReference.Offer):$($VmObject.StorageProfile.ImageReference.Sku)"
        return $fullOs
    }elseif ( -not ([string]::IsNullOrEmpty($VmObject.StorageProfile.OSDisk.OSType))){
        return $VmObject.StorageProfile.OSDisk.OSType
    }
    }else {
        return "Unknown OS"
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


if ($subs[0] -eq "all"){
    $subs = Get-azSubscription | select Id
}

$number = $subs.count
$vms = @()
$count = 0
echo "there are $number subscriptions"
foreach ($sub in $subs) {
    Set-AzContext -Subscriptionid $sub | out-null
    $vms += get-azvm

    $count = $count + 1
    $percentval = [int]($count/$number * 100)
    echo "completed sub: $($sub), we are at $($percentval)%"

}

echo "name,type,owner,subscription (id),VM id,tags"

foreach ($vm in $vms){
    $vmtype = Check-VmType -VmObject $vm
    $subid = $vm.id.split("/")[2]
    $owner = ""
    $tagsString = Get-TagString -VmObject $vm -tags $tags

    echo "$($vm.name),$vmtype,$owner,$subid,$($vm.id),$tagsString" 
}
