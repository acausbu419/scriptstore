#region Prereqs
#Modules required script to function
if (Get-Module -ListAvailable -Name SnipeitPS) {
    Set-ExecutionPolicy Bypass -Force
    Import-Module SnipeitPS
} 
else {
    Set-PackageSource -Name MyNuget -NewName NewNuGet -Trusted -ProviderName NuGet -Force -ErrorAction SilentlyContinue
    Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted -ErrorAction SilentlyContinue
    Install-Module SnipeitPS -allowclobber
    Import-Module SnipeitPS
}

#Check for AutoPilotConfig setup folder
if(!(Test-Path "C:\ProgramData\AutoPilotConfig")){
    New-Item -Path "C:\ProgramData" -Name AutoPilotConfig -Type "directory"
}

#Check for results file (file that emails results of script)
if(!(Test-Path "C:\ProgramData\AutoPilotConfig\results.txt")){
    New-Item -Path "C:\ProgramData\AutoPilotConfig" -Name results.txt -Type "file"
}
else {
    Clear-Content -Path "C:\ProgramData\AutoPilotConfig\results.txt"
}
#endregion

#Get API key
$cred = Get-StoredCredential -Target snipeit

#region assetcheck
#set snipeit url and api key
Set-Info -URL <#'https://web-snipeit.domain.ext'#> -apiKey $cred.Password
#grab asset tag from hostname
$hosttrunc = $env:COMPUTERNAME.Substring($env:COMPUTERNAME.Length -6,6)
#make sure the asset tag is valid
if($hosttrunc -notmatch "^\d+$"){
    Exit
}
#check if asset tag exists in snipeit
$snipeit_check = Get-Asset -search $hosttrunc
#get device model
$hardware_info = Get-WmiObject -Class:Win32_ComputerSystem -Property PCSystemType,Manufacturer,Model

$snipeit_manufacturer = Get-Manufacturer -search $hardware_info.Manufacturer
$snipeit_model = Get-Model -search $hardware_info.Model

if($hardware_info.PCSystemType -eq 1){$snipeit_category = "2"}
elseif($hardware_info.PCSystemType -eq 2){$snipeit_category = "8"}

#end script if asset exists (no changes applied)
if($null -ne $snipeit_check){
    Exit
}
else{
    #Unknown Manufacturer
    if($hardware_info.Manufacturer -ne $snipeit_manufacturer.name){
        New-Manufacturer -Name $hardware_info.Manufacturer
        $snipeit_manufacturer = Get-Manufacturer -search $hardware_info.Manufacturer
        Add-Content -Path "C:\ProgramData\AutoPilotConfig\results.txt" "New manufacturer, $($hardware_info.Manufacturer) created."
    }
    #Unknown Model
    if($hardware_info.Model -ne $snipeit_model.name){
        New-Model -name $hardware_info.Model -category_id $snipeit_category -manufacturer_id $snipeit_manufacturer.id -fieldset_id "0"
        $snipeit_model = Get-Model -search $hardware_info.Model
        Add-Content -Path "C:\ProgramData\AutoPilotConfig\results.txt" "New model, $($hardware_info.Model) created."
    }
    New-Asset -Name $env:COMPUTERNAME -tag $hosttrunc -Status_id 2 -Model_id $snipeit_model.id
    $snipeit_check = Get-Asset -search $hosttrunc
    Add-Content -Path "C:\ProgramData\AutoPilotConfig\results.txt" "New asset created:`n
                                                                    Hostname: $($env:COMPUTERNAME)
                                                                    Asset: $($hosttrunc)
                                                                    Device Model: $($hardware_info.Model)
                                                                    Device Manufacturer: $($hardware_info.Manufacturer)`n
                                                                    To complete any additional steps you can access the device page here:`n
                                                                    https://web-snipeit.company.net/hardware/$($snipeit_check.id)"

}

$mailParams = @{
    SmtpServer                 = <#'SMTP FQDN'#>
    Port                       = '25'
    UseSSL                     = $true   
    From                       = <#'From Address'#>
    To                         = <#'To Address'#>
    Subject                    = "Device Setup Results"
    Body                       = (Get-Content -Path "C:\ProgramData\AutoPilotConfig\results.txt") -join "`n"
    DeliveryNotificationOption = 'OnFailure', 'OnSuccess'
}
## Send the email
Send-MailMessage @mailParams
#endregion