### This script is made for deploying Sysmon across the network, This requires some GPO's for scheduled tasks etc
### This also backs up the security and sysmon logs to a server instead of storing them locally on the PC


$SysmonServerPath = "" #Enter Share path here. e.g. \\SysmonServer\Sysmon
$LogServerPath = "" #Enter Log Share path here e.g. \\LogServer\Logs
$Date = Get-Date -UFormat "%d/%m/%y/ %H:%M"
$Update = "Sysmon was last updated at "  + $Date
$SysmonFolder = Test-Path C:\Sysmon
$SysmonLogs = Get-ChildItem C:\Windows\System32\Winevt\Logs\Archive-Microsoft-Windows-Sysmon*.evtx
$SecurityLogs = Get-ChildItem C:\Windows\System32\Winevt\Logs\Archive-Security*.evtx
$ComputerName = $env:computername
$LogPathExists = Test-Path \\wrgwss01\logs\$ComputerName
$SecuritySavePath = $LogServerPath + $ComputerName + "\Security\"
$SysmonSavePath = $LogServerPath + $ComputerName + "\Sysmon\"
$LocalSysmonLogs = Get-ChildItem C:\Sysmon\Archive\Archive-Microsoft-Windows-Sysmon*.evtx
$LocalSecurityLogs = Get-ChildItem C:\Sysmon\Archive\Archive-Security*.evtx


if ($LogPathExists -eq $false)
{
mkdir \\wrgwss01\logs\$ComputerName
mkdir $SecuritySavePath
mkdir $SysmonSavePath
}

$LogPathExistsSysmon = Test-Path $SysmonSavePath
if ($LogPathExistsSysmon -eq $false)
{
mkdir \\wrgwss01\logs\$ComputerName\Sysmon
}
$LogPathExistsSecurity = $SecuritySavePath
if ($LogPathExistsSecurity -eq $false)
{
mkdir \\wrgwss01\logs\$ComputerName\Security
}

Move-Item $LocalSecurityLogs $SecuritySavePath
Move-Item $LocalSysmonLogs $SysmonSavePath

If ((get-service sysmon -errorAction SilentlyContinue).count -eq 0) {
    robocopy $SysmonServerPath C:\Sysmon /mir /copy:DATSO /r:3 /w:1 
    Start-Process "C:\Sysmon\sysmon.exe" -ArgumentList "/accepteula -i c:\Sysmon\config.xml"
    Start-Sleep 5
}

else{
    robocopy $SysmonServerPath "C:\Sysmon" /r:3 /w:1 config.xml
    Start-Process "C:\Sysmon\sysmon.exe" -ArgumentList "-c c:\sysmon\sysmon\config.xml"
}

Move-Item $SysmonLogs $SysmonSavePath
Move-Item $SecurityLogs $SecuritySavePath

wevtutil sl Microsoft-Windows-Sysmon/Operational /rt:true /ab:true
wevtutil sl Microsoft-Windows-Sysmon/Operational /ms:309715200
$Update | Out-File C:\Sysmon\Update.txt