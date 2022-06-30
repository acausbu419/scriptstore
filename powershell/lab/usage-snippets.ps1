
#Store credential
New-StoredCredential -Target <#name#> -UserName <#username#> -Password <#password#>

#Use credential
$cred = Get-StoredCredential -Target <#name#>

#Pull credential (PS7)
$cred.Password | ConvertFrom-SecureString -AsPlainText
