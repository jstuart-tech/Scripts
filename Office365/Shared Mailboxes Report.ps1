$DomainName = "" #Enter Domainname here e.g. contoso.com


$DomainName = "*@" + $DomainName
$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session

$SharedMailboxes = Get-Mailbox -Filter "*" | Where-Object {$_.RecipientTypeDetails -eq "SharedMailbox"} | Select-Object Name, ForwardingAddress, WindowsEmailAddress, alias

ForEach($Mailbox in $SharedMailboxes)
{
    If($Mailbox.ForwardingAddress -ne $null)
    {
    Write-Host $Mailbox.Name "is forwarding to" $Mailbox.ForwardingAddress
    }
        $Perms = Get-MailboxPermission $Mailbox.alias | Where-Object {$_.User -like $DomainName}  
            If($Perms.User -ne $null)
            {
            ForEach($User in $Perms.User)
                {
            $User2 = Get-Mailbox $User | Select-Object Name
            Write-Host $User2.Name "has" $Perms.AccessRights[0] "to the mailbox of" $Mailbox.Name -ForegroundColor Red
                }   
            }
}