#Install-Module ImportExcel

Set-ExecutionPolicy bypass -Scope Process -Force

Import-Module ImportExcel

$date = Get-Date
$date = $date.ToString('yyyyMMdd')
$file = "EPRES_ARC$date.pipe"

#Add-content $file -value 'H|5579'

$import = Import-Excel .\*.xlsx 

#foreach($line in $import){
   #$line.'Effective Date' = [datetime]::ParseExact(($line.'Effective Date'), "yyyyMMdd", $null)
   #$line.'Effective Date' = [datetime]::ParseExact(($line.'Effective Date').ToString('yyyyMMdd'))
   #$line.'Patient DOB' = (($line.'Patient DOB').ToString('yyyyMMdd'))
#}

$import |ConvertTo-Csv -NoTypeInformation -Delimiter '|' | select-object -skip 1 | ForEach-Object {$_.Replace('"','')} | Out-File $file

#Add-content $file -Value $import

#$count = Get-Content $file | select-object -skip 1 | Measure-Object -Line

#Add-Content $file -Value "T|$($count.Lines)"