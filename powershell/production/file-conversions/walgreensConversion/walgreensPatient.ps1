#Install-Module ImportExcel

Set-ExecutionPolicy bypass -Scope Process -Force

Import-Module ImportExcel

$date = Get-Date
$date = $date.ToString('yyyyMMddhhmmss')
$file = "5579_FLATVER4_DELTA_$date.dat"

$import = Import-Excel .\*.xlsx |ConvertTo-Csv -NoTypeInformation -Delimiter '|' | select-object -skip 1 | ForEach-Object {$_.Replace('"','')}

Add-content $file -Value $import