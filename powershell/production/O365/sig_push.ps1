#sig_push.ps1
#Adam Ausburn

#This script sets HTML exports from the sig_generate.ps1 script
#as the email signature for the users that a HTML signature file was generated.
#Uses the Exchange-Online module.

#Changes needed:
#Needs to be updated to run as a service account, preferrably as
#sa_usermanagement, which is an Azure-side service account.

Connect-ExchangeOnline

#$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $Cred -Authentication Basic -AllowRedirection
#Import-PSSession $Session -DisableNameChecking -AllowClobber

$save_location = <#Path#>
$email_domain = '@COMPANYNAME.net'

$sig_files = Get-ChildItem -Path $save_location

foreach ($item in $sig_files) {

    $user_name = $($item.Basename) + $email_domain
    $filename = $save_location + $($item.Basename) + ".htm"

    Write-Host "Now attempting to set signature for " $user_name
    set-mailboxmessageconfiguration -identity $user_name -signaturehtml (Get-Content $filename) -autoaddsignature $true
}

$save_location = <#Path#>
$email_domain = '@COMPANYNAME.net'

$sig_files = Get-ChildItem -Path $save_location

foreach ($item in $sig_files) {

    $user_name = $($item.Basename) + $email_domain
    $filename = $save_location + $($item.Basename) + ".htm"

    Write-Host "Now attempting to set signature for " $user_name
    set-mailboxmessageconfiguration -identity $user_name -signaturehtml (Get-Content $filename) -autoaddsignature $true
}

$save_location = <#Path#>
$email_domain = '@COMPANYNAME.net'

$sig_files = Get-ChildItem -Path $save_location

foreach ($item in $sig_files) {

    $user_name = $($item.Basename) + $email_domain
    $filename = $save_location + $($item.Basename) + ".htm"

    Write-Host "Now attempting to set signature for " $user_name
    set-mailboxmessageconfiguration -identity $user_name -signaturehtml (Get-Content $filename) -autoaddsignature $true
}

#Get-PSSession | Remove-PSSession