﻿Get-ADComputer -Filter {OperatingSystem -like "*7*"} -Properties * -SearchBase "OU=Workstations,DC=ARCARE,DC=net" | Format-Table name,operatingsystem,enabled,lastLogonTimestamp -AutoSize | Out-File C:\deploy\windows7.csv