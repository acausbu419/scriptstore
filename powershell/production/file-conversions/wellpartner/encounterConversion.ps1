#Install-Module ImportExcel

Set-ExecutionPolicy bypass -Scope Process -Force

Import-Module ImportExcel

$date = Get-Date
$date = $date.ToString('yyyyMMdd')
$file = "ENCTR_ARC$date.pipe"


$import = Import-Excel .\*.xlsx 

foreach($line in $import){
    $line.'Encounter Date' = Get-Date $line.'Encounter Date' -Format 'yyyyMMdd'
    $line.'Patient DOB' = Get-Date $line.'Patient DOB' -Format 'yyyyMMdd'
}

$import |ConvertTo-Csv -NoTypeInformation -Delimiter '|' | select-object -skip 1 | ForEach-Object {$_.Replace('"','')} | Out-File $file