$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session

$Mailboxes = Get-Mailbox -ResultSize Unlimited -Filter {RecipientTypeDetails -eq "UserMailbox" -and AuditEnabled -eq $false}
$Mailboxes.UserPrincipalName | Set-Mailbox -AuditEnabled $true
$Mailboxes.UserPrincipalName | Set-Mailbox -AuditOwner Create,HardDelete,MailboxLogin,Move,MoveToDeletedItems,SoftDelete,Update
$Mailboxes.UserPrincipalName| Set-Mailbox -AuditDelegate Create,FolderBind,HardDelete,Move,MoveToDeletedItems,SendAs,SendOnBehalf,SoftDelete,Update
$Mailboxes.UserPrincipalName | Set-Mailbox –AuditAdmin Copy,Create,FolderBind,HardDelete,MessageBind,Move,MoveToDeletedItems,SendAs,SendOnBehalf,SoftDelete,Update
$Mailboxes.UserPrincipalName | Set-Mailbox -AuditLogAgeLimit 365
Enable-OrganizationCustomization #This command only needs to be run once per tenant. If It has been previously run you will get a message: This operation is not required. Organization is already enabled for customization.
Set-AdminAuditLogConfig -UnifiedAuditLogIngestionEnabled $true