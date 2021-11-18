$psISE.Options.FontSize = 16

$cred = Get-Credential
Connect-MsolService -Credential $cred

Get-MsolUser -All | Select-Object userprincipalname,islicensed,{$_.Licenses.AccountSkuId} | Export-Csv c:\userlist.csv -NoTypeInformation

$users = Get-ADUser -Filter {Enabled -eq $false} | Select-Object userprincipalname

$users2 = import-csv C:\userlist.csv

foreach($user in $users){
    foreach($u2 in $users2){
        if(($u2.userprincipalname -eq $user.userprincipalname) -and ($u2.IsLicensed -eq $true)){write-host $user $u2.islicensed}
    }
}