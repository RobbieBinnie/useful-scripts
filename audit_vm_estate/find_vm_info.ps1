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

function Check-Ip {
    param (
        $VmObject
    )
    
    $nicRg = $VmObject.NetworkProfile.NetworkInterfaces[0].id.split("/")[4]
    $nicName = $VmObject.NetworkProfile.NetworkInterfaces[0].id.split("/")[8]

    $nic = Get-AzNetworkInterface -name $nicName -ResourceGroupName $nicRg

    return $nic.IpConfigurations.PrivateIpAddress

}


$VerbosePreference="Continue"


if ($subs[0] -eq "all"){
    $subs = Get-azSubscription
    $subs = $subs.Id
}

$number = $subs.count
$vms = @()
$count = 0

write-verbose "there are $number subscriptions"

write-output "name,type,ipaddress,size,subscription (id),VM id,tags"

foreach ($sub in $subs) {
    Set-AzContext -Subscriptionid $sub | out-null
    $vms = get-azvm

    $count = $count + 1
    $percentval = [int]($count/$number * 100)
    write-verbose "completed sub: $($sub), we are at $($percentval)%"

    foreach ($vm in $vms){
        $vmtype = Check-VmType -VmObject $vm
        $subid = $vm.id.split("/")[2]
        $size = $vm.HardwareProfile.VmSize
        $tagsString = Get-TagString -VmObject $vm -tags $tags
        $ipaddress = Check-Ip -VmObject $vm

        write-output "$($vm.name),$vmtype,$ipaddress,$size,$subid,$($vm.id),$tagsString" 
    }
}