#Hide window to help prevent user from closing this window before it's finished executing.
$t = '[DllImport("user32.dll")] public static extern bool ShowWindow(int handle, int state);'
add-type -name win -member $t -namespace native
[native.win]::ShowWindow(([System.Diagnostics.Process]::GetCurrentProcess() | Get-Process).MainWindowHandle, 0)

#Explorer CPU Fix
Add-Type -AssemblyName System.DirectoryServices.AccountManagement
$Path = "Registry::HKEY_USERS\{0}_Classes" -f ([System.DirectoryServices.AccountManagement.UserPrincipal]::Current).SID
if (-not(Test-Path -Path $Path\CLSID))
{
    New-Item -Path $Path -Name CLSID
}

#FTA check & assignment
#Currently uses state of pdf from setuserfta get command to determine if it needs to be ran.
$var = & c:\pushit\programs\setuserfta.exe get

if(($var -notlike "*.pdf, AcroExch.Document.DC*") -or ($var -notlike "*.htm, ChromeHTML*")){Start-Process c:\pushit\programs\setuserfta.exe -ArgumentList c:\pushit\files\SetUserFTAConfig.txt }