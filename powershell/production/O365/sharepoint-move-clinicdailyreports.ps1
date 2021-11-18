$SiteURL = "https://arcare.sharepoint.com/sites/ClinicDailyReports"
#$DocLibName = "Reports"
$path = "E:\additional\clinicdailyreports\"

$Creds = Get-StoredCredential -Target $SiteURL
Connect-PnPOnline -Url $SiteURL -Credentials $Creds


$files = Get-ChildItem -Path $path -Recurse -Include *.* | Select-Object name,fullname,creationtime
foreach($f in $files){
    $temp = "Reports\" + $f.FullName.TrimStart("E:\additional\clinicdailyreports\")
    $temp = $temp.TrimEnd($f.Name)
    Add-PnPFile -Path $f.fullname -Folder $temp -NewFileName $f.name
}

Disconnect-PnPOnline

foreach($f in $files){
    Remove-Item $f.FullName
    }