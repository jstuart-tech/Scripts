### This script assigns SendAs permissions to all mailboxes for 1 user. Helpful with onprem SMTP relays that need to send as all mailboxes. This is unsupported by MS

$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session

$SendAsUser = "" #Enter the UPN of the user to be granted Send As permissions

$UserMailboxes = Get-Mailbox | Where-Object {$_.RecipientTypeDetails -eq "UserMailbox"}
$SharedMailboxes = Get-Mailbox | Where-Object {$_.RecipientTypeDetails -eq "SharedMailbox"}
$DistList = Get-DistributionGroup

$UserMailboxes.PrimarySmtpAddress | Add-RecipientPermission -AccessRights SendAs -Trustee $SendAsUser -WarningAction SilentlyContinue -Confirm:$false 
$SharedMailboxes.PrimarySmtpAddress | Add-RecipientPermission -AccessRights SendAs -Trustee $SendAsUser -WarningAction SilentlyContinue -Confirm:$false
$DistList.PrimarySmtpAddress | Add-RecipientPermission -AccessRights SendAs -Trustee $SendAsUser -WarningAction SilentlyContinue -Confirm:$false
