$body = Get-ADUser -Filter {badPwdCount -gt 10} -Properties name,badPwdCount | Select-Object name,badPwdCount | Sort-Object badPwdCount -Descending | Out-String

Send-MailMessage -From no_reply@arcare.net -To 5015306070@vtext.com -Subject "bpwdc" -Body $body -SmtpServer ds-ca.arcare.net