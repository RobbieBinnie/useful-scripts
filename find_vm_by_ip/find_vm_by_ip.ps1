param(
    $subs = @("all"),
    $ip
)

write-host "Searching for $ip"

if ($subs[0] -eq "all"){

    $subs = Get-azSubscription
    $subs = $subs.Id
}

$number = $subs.count
$nics = @()
$count = 0

write-host "there are $number subscriptions to search"

foreach ($sub in $subs) {
    Set-AzContext -Subscriptionid $sub | out-null
    $nics += Get-AzNetworkInterface

    $count = $count + 1
    $percentval = [int]($count/$number * 100)
    write-host "completed sub: $($sub), we are at $($percentval)%"
}

foreach ($nic in $nics){
    if($nic.IpConfigurations.PrivateIpAddress.Contains($ip)){
        write-host "IP address $($ip), is on nic:"
        write-host -ForegroundColor "green" "$($nic.id)"
        write-host "which is connected to vm:"
        write-host -ForegroundColor "blue" "$($nic.VirtualMachine.id)`n"
    }
}