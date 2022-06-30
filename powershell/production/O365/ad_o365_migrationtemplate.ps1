$users = Get-ADUser -Filter {enabled -eq $true} -Server <#Server FQDN#> <#SearchBase#> -Properties *

$Cred = Get-Credential

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $Cred -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking

foreach ($u in $users) {
    Get-Mailbox -Identity $u.userprincipalname | Get-MailboxStatistics | Select-Object displayname,totalitemsize
}

Get-PSSession | Remove-PSSession

#local vars

Get-ADUser -Filter {enabled -eq $true} -Server <#Server FQDN#> <#SearchBase#> -Properties * | select-object userprincipalname,displayname,employeeID,extensionattribute11,extensionattribute12,title,department,streetAddress,city,st,postalcode,telephonenumber,facsimiletelephonenumber | Export-Csv -Path u:\kymigration.csv

$users = Import-Csv -Path U:\kymigration.csv

foreach($u in $users){write-host $u.EmployeeID}