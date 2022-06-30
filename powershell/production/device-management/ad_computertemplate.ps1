$DaysInactive = 180

$time = (Get-Date).Adddays(-($DaysInactive))

Get-ADComputer -Filter {(LastLogonTimeStamp -lt $time) -and (operatingsystem -like "*7*")} -ResultPageSize 2000 -resultSetSize $null -Properties Name, OperatingSystem, SamAccountName, DistinguishedName,lastlogontimestamp

Get-ADComputer -Filter {(enabled -eq $true) -and (operatingsystem -like "*7*")} -ResultPageSize 2000 -resultSetSize $null -Properties Name, OperatingSystem, SamAccountName, DistinguishedName,lastlogontimestamp,enabled | Select-Object name,operatingsystem,enabled