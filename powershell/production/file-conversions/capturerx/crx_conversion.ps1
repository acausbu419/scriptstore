#crx_conversion.ps1
#Adam Ausburn

#This script converts a spreadsheet (using the ImportExcel module)
#into a flatfile for CaptureRX.

#Install-Module ImportExcel

Set-ExecutionPolicy bypass -Scope Process -Force

Import-Module ImportExcel

$date = Get-Date
$date = $date.ToString('MMddyy')
$file = "NEC32_PE_file_$date.txt"

$import = Import-Excel .\*.xlsx |ConvertTo-Csv -NoTypeInformation -Delimiter '|' | select-object -skip 1 | ForEach-Object {$_.Replace('"','')}

$import = $import -replace ' 12:00:00 AM',''

Add-content $file -Value $import