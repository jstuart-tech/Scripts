### This script is to add a SIP address to all users in a certain OU that don't have one. This can easily be modified for any type of "missing" proxyaddress

$OU = "" #Enter the OU that you want to search here
$domain= "" #Enter the Domain name here

$Users = Get-ADUser -Filter * -SearchBase $OU -Properties proxyAddresses | Where {$_.proxyAddresses} | Where {-not($_.proxyAddresses  -like "*sip*")} | Select SAMAccountName, ProxyAddresses | sort SAMAccountName



foreach($User in $Users){
$sip= "sip:" + $user.SAMAccountName +"@" + $domain
Set-ADUser $User.SAMAccountName -Add @{Proxyaddresses=$sip}
}