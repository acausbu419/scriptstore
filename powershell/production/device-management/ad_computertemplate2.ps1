﻿Get-ADComputer -Filter {OperatingSystem -like "*7*"} -Properties * | Format-Table name,operatingsystem,enabled,lastLogonTimestamp -AutoSize | Out-File C:\deploy\windows7.csv