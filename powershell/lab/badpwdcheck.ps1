$body = Get-ADUser -Filter {badPwdCount -gt 10} -Properties name,badPwdCount | Select-Object name,badPwdCount | Sort-Object badPwdCount -Descending | Out-String

Send-MailMessage -From <#From Address#> -To <#To Address#> -Subject <#Subject#> -Body $body -SmtpServer <#SMTP FQDN#>