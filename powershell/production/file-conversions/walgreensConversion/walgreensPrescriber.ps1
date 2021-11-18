#Install-Module ImportExcel

Set-ExecutionPolicy bypass -Scope Process -Force

Import-Module ImportExcel

$date = Get-Date
$date = $date.ToString('yyyyMMddhhmmss')
$file = "5579_Flatfile_Format2Ver1_FullPBR_$date.dat"

Add-content $file -value 'H|5579'

$import = Import-Excel .\*.xlsx |ConvertTo-Csv -NoTypeInformation -Delimiter '|' | select-object -skip 1 | ForEach-Object {$_.Replace('"','')}

Add-content $file -Value $import

$count = Get-Content $file | select-object -skip 1 | Measure-Object -Line
Add-Content $file -Value "T|$($count.Lines)"