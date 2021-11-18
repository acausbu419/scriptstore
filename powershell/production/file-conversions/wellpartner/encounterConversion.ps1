#Install-Module ImportExcel

Set-ExecutionPolicy bypass -Scope Process -Force

Import-Module ImportExcel

$date = Get-Date
$date = $date.ToString('yyyyMMdd')
$file = "ENCTR_ARC$date.pipe"

#Add-content $file -value 'H|5579'

$import = Import-Excel .\*.xlsx 

foreach($line in $import){
    $line.'Encounter Date' = Get-Date $line.'Encounter Date' -Format 'yyyyMMdd' #$line.'Encounter Date'.ToString("yyyyMMdd")
    $line.'Patient DOB' = Get-Date $line.'Patient DOB' -Format 'yyyyMMdd' #$line.'Patient DOB'.ToString('yyyyMMdd')
}

#$import = $import -replace ' 12:00:00 AM',''

$import |ConvertTo-Csv -NoTypeInformation -Delimiter '|' | select-object -skip 1 | ForEach-Object {$_.Replace('"','')} | Out-File $file

#Add-content $file -Value $import

#$count = Get-Content $file | select-object -skip 1 | Measure-Object -Line

#Add-Content $file -Value "T|$($count.Lines)"