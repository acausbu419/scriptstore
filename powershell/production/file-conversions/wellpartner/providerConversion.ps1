#Install-Module ImportExcel

Set-ExecutionPolicy bypass -Scope Process -Force

Import-Module ImportExcel

$date = Get-Date
$date = $date.ToString('yyyyMMdd')
$file = "EPRES_ARC$date.pipe"

$import = Import-Excel .\*.xlsx 

$import |ConvertTo-Csv -NoTypeInformation -Delimiter '|' | select-object -skip 1 | ForEach-Object {$_.Replace('"','')} | Out-File $file