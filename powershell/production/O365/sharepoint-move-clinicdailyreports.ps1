$SiteURL = "https://COMPANYNAME.sharepoint.com/sites/sitename"
#$DocLibName = "Reports"
$path = <#Path#>

$Creds = Get-StoredCredential -Target $SiteURL
Connect-PnPOnline -Url $SiteURL -Credentials $Creds


$files = Get-ChildItem -Path $path -Recurse -Include *.* | Select-Object name,fullname,creationtime
foreach($f in $files){
    $temp = "Reports\" + $f.FullName.TrimStart(<#Path#>)
    $temp = $temp.TrimEnd($f.Name)
    Add-PnPFile -Path $f.fullname -Folder $temp -NewFileName $f.name
}

Disconnect-PnPOnline

foreach($f in $files){
    Remove-Item $f.FullName
    }