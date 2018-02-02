$Date = (Get-Date).AddDays(-90) #Adjust this value to required days
$OU = "" #Enter the OU that you want to search


Get-ADUser -Filter * -searchbase $OU -Properties Name,PasswordLastSet,Enabled,LastLogonDate | where {$_.PasswordLastSet -lt $Date -and $_.Enabled -eq "True"} | Select Name,PasswordLastSet,Enabled,LastLogonDate