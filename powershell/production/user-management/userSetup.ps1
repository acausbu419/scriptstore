Import-Module ActiveDirectory

Clear-Content -Path C:\scripts\results.txt

#region usercleanup

#remove group membership from disabled accounts
get-aduser -filter {enabled -eq $false} -searchbase "OU=ZZ - Disabled,OU=User Accounts,DC=COMPANYNAME,DC=NET" -Properties memberof | 
    ForEach-Object {
        $user = $_
        $_.memberof | ForEach-Object{remove-adgroupmember $_ -members $user -Confirm:$false}
    }

#enable new hires
#Sets startdate variable as the following day e.g. if today is 9/14 it's set to 9/15.
$startdate = (Get-Date).AddDays(1) | Get-Date -Format "M/d/yyyy"

#Grab all disabled accounts that have any data in the ext12 attribute (start date is stored here)
$users = Get-ADUser -Filter {Enabled -eq $false -and extensionattribute12 -eq $startdate} -Properties samaccountname,extensionattribute12,userprincipalname

foreach($user in $users){
    #On SERVERNAME, scheduled task userSetup runs every 15 minutes (this script)
    #On Sundays at midnight, this section becomes relevant.
    
    #Flag all the users to have their password changed at next login.
    Set-ADUser -Identity $user.SamAccountName -ChangePasswordAtLogon $true
    #Isolate only firstname.lastname from the userprincipalname.
    $username = $user.userprincipalname.split("@")
    #Set U drive for new hires being enabled.
    Set-ADUser -Identity $username[0] -HomeDirectory \\SERVERNAME\users\$($username[0]) -HomeDrive U:

    #Check to see if the users' start date is equal to the date 24 hours from the script being run.
    #So if user start date is 9/14/2020 and this script runs at midnight on 9/13/2020, it will find a match and enabled the accounts.
    if($user.extensionattribute12 -eq $startdate){
        Set-ADUser -Identity $user.SamAccountName -Enabled $true
        #Set-ADUser -Identity $user.SamAccountName -ChangePasswordAtLogon $true
        Add-Content -Path  C:\scripts\results.txt "Enabled user account $($user.SamAccountName) for the following reason: New Hire"
    }
}


#Check for enabled accounts using default password and set toggle to change pw at logon
$users = get-aduser -Filter {(enabled -eq $true) -and (pwdLastSet -eq 0)}
foreach($user in $users){

Function Test-ADAuthentication {
    param($user,$password)
    (new-object directoryservices.directoryentry "",$user,$password).psbase.name -ne $null
}

#Test-ADAuthentication "$($user.samaccountname)" "Password1"
if((Test-ADAuthentication "$($user.samaccountname)" "COMPANYNAME1234") -eq $true){
    Set-ADUser -Identity $user.SamAccountName -ChangePasswordAtLogon $true
    #write-host $user.UserPrincipalName
}}

#Set Location information (Address/ZIP/City)
$locations = Import-Excel c:\scripts\locations.xlsx
$users = Get-ADUser -Filter {extensionattribute13 -like "*"} -Properties distinguishedname,extensionattribute13,extensionattribute14,streetAddress,l,postalCode,samaccountname

foreach($l in $locations){
    foreach($u in $users){
        if(($l.site -eq $u.extensionattribute13) -and ($u.extensionattribute14 -ne "$($u.extensionattribute13)")){
            Set-ADUser -Identity $u.distinguishedname -Replace @{streetAddress="$($l.ADDRESS)";postalCode="$($l.ZIP)";l="$($l.CITY)";extensionattribute13="$($l.SITE)";extensionattribute14="$($l.SITE)"}
            Add-Content -Path  "C:\scripts\results.txt" "User account $($u.samaccountname) location information updated to site $($l.SITE) - $($l.NAME)."
        }
    }
}

#GP verification
#Scheduled task runs on db-sqlprod every day to provide the csv
#Remove all the junk spaces out of the database export from GP
(Get-Content '\\SERVERNAME\c$\temp\SQLCMD.csv' | foreach {$_ -replace ' '}) | out-file '\\SERVERNAME\c$\temp\SQLCMD.csv'

#Remove junk line after header
$import = Import-Csv -Path '\\SERVERNAME\c$\temp\SQLCMD.csv' | select -Skip 1

#Grab all COMPANYNAME users with an employee id field set
$users = Get-ADUser -Filter {(extensionattribute10 -like "*") -and (enabled -eq $true)} -SearchBase "OU=AR,OU=User Accounts,DC=COMPANYNAME,DC=net" -Properties samaccountname,enabled,extensionattribute10,whenChanged

#
foreach($i in $import){
    foreach($user in $users){
        if($user.extensionattribute10 -eq $i.employid){
            if(($user.Enabled -eq $true) -and ($i.INACTIVE -eq "1") -and ($user.whenChanged -le (get-date).AddDays(-30).Date)){
                Add-Content -Path  "C:\scripts\results.txt" "The following account is enabled in Active Directory but flagged as disabled in GP: $($user.name)."
            }
        }
    }
}

$users = Get-ADUser -Filter {(extensionattribute10 -like "*") -and (enabled -eq $true)} -SearchBase "OU=KY,OU=User Accounts,DC=COMPANYNAME,DC=net" -Properties samaccountname,enabled,extensionattribute10,whenChanged

foreach($i in $import){
    foreach($user in $users){
        if($user.extensionattribute10 -eq $i.employid){
            if(($user.Enabled -eq $true) -and ($i.INACTIVE -eq "1") -and ($user.whenChanged -le (get-date).AddDays(-30).Date)){
                Add-Content -Path  "C:\scripts\results.txt" "The following account is enabled in Active Directory but flagged as disabled in GP: $($user.name)."
            }
        }
    }
}

$users = Get-ADUser -Filter {(extensionattribute10 -like "*") -and (enabled -eq $true)} -SearchBase "OU=MS,OU=User Accounts,DC=COMPANYNAME,DC=net" -Properties samaccountname,enabled,extensionattribute10,whenChanged

foreach($i in $import){
    foreach($user in $users){
        if($user.extensionattribute10 -eq $i.employid){
            if(($user.Enabled -eq $true) -and ($i.INACTIVE -eq "1") -and ($user.whenChanged -le (get-date).AddDays(-30).Date)){
                Add-Content -Path  "C:\scripts\results.txt" "The following account is enabled in Active Directory but flagged as disabled in GP: $($user.name)."
            }
        }
    }
}

#$users = $import | ForEach-Object { Get-ADUser -Filter {extensionattribute10 -like "*$($_.EMPLOYID)*"} -Properties samaccountname,extensionattribute10 } | select samaccountname,extensionattribute10

#expire users under the following criteria $users.count write-host $users.name $users.company
$users = Get-ADUser -Filter {(Enabled -eq $true)} -Properties lastlogondate,whencreated,passwordlastset,company,passwordexpired,accountexpirationdate,extensionattribute12  -SearchBase "OU=User Accounts,DC=COMPANYNAME,DC=net" | 
    Where-object {($_.name -ne "AR$") `
        -and ($_.extensionattribute12 -le (get-date).AddDays(-60).Date) `
        -and ($_.lastlogondate -le (get-date).AddDays(-180)) `
        -and ($_.distinguishedname -NotLike "*OU=BA,*") `
        -and ($_.distinguishedname -NotLike "*OU=Service,*") `
        -and ($_.distinguishedname -NotLike "*OU=YY - Pending,*") `
        -and ($_.distinguishedname -NotLike "*OU=TMP,*") `
        -and ($_.passwordlastset -le (get-date).AddDays(-180)) `
        -and ($_.accountexpirationdate -eq $null)}

foreach($user in $users){
    Set-ADAccountExpiration -Identity $user.SamAccountName -DateTime (get-date).AddDays(-1)
    Add-Content -Path  C:\scripts\results.txt "Expired user account $($user.SamAccountName) for the following reason: Inactivity"
    }


#move disabled users
$users = Get-ADUser -Filter {(Enabled -eq $false)} -SearchBase "OU=User Accounts,DC=COMPANYNAME,DC=net" -Properties enabled,distinguishedname,lastlogondate,whencreated,memberof | where{($_.distinguishedname -NotLike "*OU=ZZ - Disabled,*") -and ($_.lastlogondate -le (get-date).AddDays(-45).Date) -and ($_.whencreated -le (get-date).AddDays(-45).Date)}

foreach($user in $users){
    Move-ADObject -Identity $user.DistinguishedName -TargetPath "OU=ZZ - Disabled,OU=User Accounts,DC=COMPANYNAME,DC=net"
    Add-Content -Path  C:\scripts\results.txt "Moved disabled user account $($user.SamAccountName) to ZZ - Disabled OU."}

#Pharmacy Student Expirations
$users = Get-ADUser -Filter {(enabled -eq $true)} -Properties accountexpirationdate,title,whencreated | Where-Object title -eq "Pharmacy Student"

foreach($user in $users){
    if($user.accountexpirationdate -eq $null){
        Set-ADAccountExpiration -Identity $user.SamAccountName -DateTime ($user.whencreated).AddDays(45)
        }
    elseif($user.accountexpirationdate -le (get-date).adddays(-45)){
        #disable account
        Disable-ADAccount -Identity $user.SamAccountName
    }
}

#strip group membership of disabled users in zz - disabled
Get-ADUser -Filter {(Enabled -eq $false)} -SearchBase "OU=ZZ - Disabled,OU=User Accounts,DC=COMPANYNAME,DC=net" -Properties enabled,distinguishedname,lastlogondate,whencreated,memberof | ForEach-Object {$_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -Confirm:$false}

#endregion usercleanup


#region security groups

#vdi-enabled group assignment
#Grab all users in the AR / KY / MS Organizational Units that are NOT members of the vdi-enabled group and add them to the group if the account is not disabled.
$securitygroup = (Get-ADGroup 'vdi-enabled')

$users = Get-ADUser -Filter * -SearchBase "OU=AR,OU=User Accounts,DC=COMPANYNAME,DC=net" -Properties samaccountname,memberof | Where-Object {-not ($_.memberof -match $securitygroup.Name)}

foreach($user in $users){
    Add-ADGroupMember -Identity $securitygroup.DistinguishedName -Members $user.SamAccountName
    Add-Content -Path  C:\scripts\results.txt "Added user $($user.SamAccountName) to group $($securitygroup.Name)."}

$users = Get-ADUser -Filter * -SearchBase "OU=KY,OU=User Accounts,DC=COMPANYNAME,DC=net" -Properties samaccountname,memberof | Where-Object {-not ($_.memberof -match $securitygroup.Name)}

foreach($user in $users){
    Add-ADGroupMember -Identity $securitygroup -Members $user.SamAccountName
    Add-Content -Path  C:\scripts\results.txt "Added user $($user.SamAccountName) to group $($securitygroup.Name)."}

$users = Get-ADUser -Filter * -SearchBase "OU=MS,OU=User Accounts,DC=COMPANYNAME,DC=net" -Properties samaccountname,memberof | Where-Object {-not ($_.memberof -match $securitygroup.Name)}

foreach($user in $users){
    Add-ADGroupMember -Identity $securitygroup.DistinguishedName -Members $user.SamAccountName
    Add-Content -Path  C:\scripts\results.txt "Added user $($user.SamAccountName) to group $($securitygroup.Name)."}

$users = Get-ADUser -Filter * -SearchBase "OU=ICSRX,OU=User Accounts,DC=COMPANYNAME,DC=net" -Properties samaccountname,memberof | Where-Object {-not ($_.memberof -match $securitygroup.Name)}

foreach($user in $users){
    Add-ADGroupMember -Identity $securitygroup.DistinguishedName -Members $user.SamAccountName
    Add-Content -Path  C:\scripts\results.txt "Added user $($user.SamAccountName) to group $($securitygroup.Name)."}

$users = Get-ADUser -Filter * -SearchBase "OU=Pruitt,OU=User Accounts,DC=COMPANYNAME,DC=net" -Properties samaccountname,memberof | Where-Object {-not ($_.memberof -match $securitygroup.Name)}

foreach($user in $users){
    Add-ADGroupMember -Identity $securitygroup.DistinguishedName -Members $user.SamAccountName
    Add-Content -Path  C:\scripts\results.txt "Added user $($user.SamAccountName) to group $($securitygroup.Name)."}

$users = Get-ADUser -Filter {(memberOf -ne $securitygroup.DistinguishedName) -and (enabled -eq $true) -and (objectclass -eq "user")} -SearchBase "OU=BA,OU=User Accounts,DC=COMPANYNAME,DC=net"

foreach($user in $users){
    Add-ADGroupMember -Identity $securitygroup.DistinguishedName -Members $user.SamAccountName
    Add-Content -Path  C:\scripts\results.txt "Added user $($user.SamAccountName) to group $($securitygroup.Name)."}

#sso_kronos group assignment

$securitygroup = (Get-ADGroup 'sso_kronos')

$users = Get-ADUser -Filter * -SearchBase "OU=AR,OU=User Accounts,DC=COMPANYNAME,DC=net" -Properties samaccountname,memberof | Where-Object {-not ($_.memberof -match $securitygroup.Name)}

foreach($user in $users){
    Add-ADGroupMember -Identity $securitygroup.DistinguishedName -Members $user.SamAccountName
    Add-Content -Path  C:\scripts\results.txt "Added user $($user.SamAccountName) to group $($securitygroup.Name)."}

$users = Get-ADUser -Filter * -SearchBase "OU=KY,OU=User Accounts,DC=COMPANYNAME,DC=net" -Properties samaccountname,memberof | Where-Object {-not ($_.memberof -match $securitygroup.Name)}

foreach($user in $users){
    Add-ADGroupMember -Identity $securitygroup -Members $user.SamAccountName
    Add-Content -Path  C:\scripts\results.txt "Added user $($user.SamAccountName) to group $($securitygroup.Name)."}

$users = Get-ADUser -Filter * -SearchBase "OU=MS,OU=User Accounts,DC=COMPANYNAME,DC=net" -Properties samaccountname,memberof | Where-Object {-not ($_.memberof -match $securitygroup.Name)}

foreach($user in $users){
    Add-ADGroupMember -Identity $securitygroup.DistinguishedName -Members $user.SamAccountName
    Add-Content -Path  C:\scripts\results.txt "Added user $($user.SamAccountName) to group $($securitygroup.Name)."}

$users = Get-ADUser -Filter * -SearchBase "OU=ICSRX,OU=User Accounts,DC=COMPANYNAME,DC=net" -Properties samaccountname,memberof | Where-Object {-not ($_.memberof -match $securitygroup.Name)}

foreach($user in $users){
    Add-ADGroupMember -Identity $securitygroup.DistinguishedName -Members $user.SamAccountName
    Add-Content -Path  C:\scripts\results.txt "Added user $($user.SamAccountName) to group $($securitygroup.Name)."}

$users = Get-ADUser -Filter * -SearchBase "OU=Pruitt,OU=User Accounts,DC=COMPANYNAME,DC=net" -Properties samaccountname,memberof | Where-Object {-not ($_.memberof -match $securitygroup.Name)}

foreach($user in $users){
    Add-ADGroupMember -Identity $securitygroup.DistinguishedName -Members $user.SamAccountName
    Add-Content -Path  C:\scripts\results.txt "Added user $($user.SamAccountName) to group $($securitygroup.Name)."}

$users = Get-ADUser -Filter {(memberOf -ne $securitygroup.DistinguishedName) -and (enabled -eq $true) -and (objectclass -eq "user")} -SearchBase "OU=BA,OU=User Accounts,DC=COMPANYNAME,DC=net"

foreach($user in $users){
    Add-ADGroupMember -Identity $securitygroup.DistinguishedName -Members $user.SamAccountName
    Add-Content -Path  C:\scripts\results.txt "Added user $($user.SamAccountName) to group $($securitygroup.Name)."}

#appvolume assignment
#if you want to add a group to this script, you can copy all lines of a section and you only need to update the rules for $appvol and $assignment

#careware
$securitygroup = (Get-ADGroup 'appvol-careware')
$users = Get-ADUser -Filter {(department -eq "Special Services") -and (memberOf -ne $securitygroup.DistinguishedName)} -SearchBase "OU=User Accounts,DC=COMPANYNAME,DC=net"

foreach($user in $users){
    Add-ADGroupMember -Identity $securitygroup.DistinguishedName -Members $user.samaccountname 
    Add-Content -Path  C:\scripts\results.txt "Added user $($user.SamAccountName) to group $($securitygroup.Name)."}

#mitel connect
$securitygroup = (Get-ADGroup 'appvol-mitel')
$users = Get-ADUser -Filter {((department -eq "Professional Services") -or (department -eq "IT")  -or (department -eq "KMS")) -and (memberOf -ne $securitygroup.DistinguishedName)} -SearchBase "OU=User Accounts,DC=COMPANYNAME,DC=net"

foreach($user in $users){
    Add-ADGroupMember -Identity $securitygroup.DistinguishedName -Members $user.samaccountname 
    Add-Content -Path  C:\scripts\results.txt "Added user $($user.SamAccountName) to group $($securitygroup.Name)."}

#successehs
$securitygroup = (Get-ADGroup 'appvol-ehs')
$users = Get-ADUser -Filter {((department -eq "Professional Services")) -and (memberOf -ne $securitygroup.DistinguishedName)} -SearchBase "OU=AR,OU=User Accounts,DC=COMPANYNAME,DC=net"

foreach($user in $users){
    Add-ADGroupMember -Identity $securitygroup.DistinguishedName -Members $user.samaccountname 
    Add-Content -Path  C:\scripts\results.txt "Added user $($user.SamAccountName) to group $($securitygroup.Name)."}

#snagit
$securitygroup = (Get-ADGroup 'appvol-snagit')
$users = Get-ADUser -Filter {((department -eq "Professional Services") -or (department -eq "KMS")) -and (memberOf -ne $securitygroup.DistinguishedName)} -SearchBase "OU=AR,OU=User Accounts,DC=COMPANYNAME,DC=net"

foreach($user in $users){
    Add-ADGroupMember -Identity $securitygroup.DistinguishedName -Members $user.SamAccountName 
    Add-Content -Path  C:\scripts\results.txt "Added user $($user.SamAccountName) to group $($securitygroup.Name)."}

#add front office to usb passthrough group for scanning on zero clients
$securitygroup = (Get-ADGroup 'vdi-uem-usbpassthrough')
$users = Get-ADUser -Filter {(department -eq "Front Office") -and (memberOf -ne $securitygroup.DistinguishedName)} -SearchBase "OU=User Accounts,DC=COMPANYNAME,DC=net"

foreach($user in $users){
    Add-ADGroupMember -Identity $securitygroup.DistinguishedName -Members $user.SamAccountName 
    Add-Content -Path  C:\scripts\results.txt "Added user $($user.SamAccountName) to group $($securitygroup.Name)."}

#endregion security groups

#region email signature-assignment
$users = Get-ADUser -Filter {(enabled -eq $true)} -Properties samaccountname,company,telephoneNumber,mobile,facsimileTelephoneNumber,streetaddress,l,st,postalcode,extensionattribute2

#$users = Get-ADUser -Identity stephanie.hawkins -Properties samaccountname,company,telephoneNumber,mobile,facsimileTelephoneNumber,streetaddress,l,st,postalcode,extensionattribute2

foreach($user in $users){
    if((($user.Company -eq "COMPANYNAME") -and (($user.telephoneNumber -eq $null) -or ($user.facsimileTelephoneNumber -eq $null) -or ($user.StreetAddress -eq $null) -or ($user.l -eq $null) -or ($user.st -eq $null) -or ($user.postalcode -eq $null)))){
        if($user.extensionattribute2 -ne "arbasic"){
            Set-ADUser $user.SamAccountName -Replace @{'extensionattribute2'="arbasic"}
            Add-Content -Path  C:\scripts\results.txt "Updated user $($user.SamAccountName) for basic mail signature."}}
    elseif((($user.Company -eq "COMPANYNAME") -and ($user.telephoneNumber -ne $null) -and ($user.mobile -eq $null) -and ($user.facsimileTelephoneNumber -ne $null) -and ($user.StreetAddress -ne $null) -and ($user.l -ne $null) -and ($user.st -ne $null) -and ($user.postalcode -ne $null))){
        if($user.extensionattribute2 -ne "arstandard"){
            Set-ADUser $user.SamAccountName -Replace @{'extensionattribute2'="arstandard"}
            Add-Content -Path  C:\scripts\results.txt "Updated user $($user.SamAccountName) for standard mail signature."}}
    elseif((($user.Company -eq "COMPANYNAME") -and ($user.telephoneNumber -ne $null) -and ($user.mobile -ne $null) -and ($user.facsimileTelephoneNumber -ne $null) -and ($user.StreetAddress -ne $null) -and ($user.l -ne $null) -and ($user.st -ne $null) -and ($user.postalcode -ne $null))){
        if($user.extensionattribute2 -ne "arextended"){
            Set-ADUser $user.SamAccountName -Replace @{'extensionattribute2'="arextended"}
            Add-Content -Path  C:\scripts\results.txt "Updated user $($user.SamAccountName) for extended mail signature."}}
    elseif((($user.Company -eq "COMPANYNAME") -and (($user.telephoneNumber -eq $null) -or ($user.facsimileTelephoneNumber -eq $null) -or ($user.StreetAddress -eq $null) -or ($user.l -eq $null) -or ($user.st -eq $null) -or ($user.postalcode -eq $null)))){
        if($user.extensionattribute2 -ne "kybasic"){
            Set-ADUser $user.SamAccountName -Replace @{'extensionattribute2'="kybasic"}
            Add-Content -Path  C:\scripts\results.txt "Updated user $($user.SamAccountName) for basic mail signature."}}
    elseif((($user.Company -eq "COMPANYNAME") -and ($user.telephoneNumber -ne $null) -and ($user.mobile -eq $null)  -and ($user.facsimileTelephoneNumber -ne $null) -and ($user.StreetAddress -ne $null) -and ($user.l -ne $null) -and ($user.st -ne $null) -and ($user.postalcode -ne $null))){
        if($user.extensionattribute2 -ne "kystandard"){
            Set-ADUser $user.SamAccountName -Replace @{'extensionattribute2'="kystandard"}
            Add-Content -Path  C:\scripts\results.txt "Updated user $($user.SamAccountName) for standard mail signature."}}
    elseif((($user.Company -eq "COMPANYNAME") -and ($user.telephoneNumber -ne $null) -and ($user.mobile -ne $null) -and ($user.facsimileTelephoneNumber -ne $null) -and ($user.StreetAddress -ne $null) -and ($user.l -ne $null) -and ($user.st -ne $null) -and ($user.postalcode -ne $null))){
        if($user.extensionattribute2 -ne "kyextended"){
            Set-ADUser $user.SamAccountName -Replace @{'extensionattribute2'="kyextended"}
            Add-Content -Path  C:\scripts\results.txt "Updated user $($user.SamAccountName) for extended mail signature."}}
    elseif((($user.Company -eq "COMPANYNAME") -and (($user.telephoneNumber -eq $null) -or ($user.facsimileTelephoneNumber -eq $null) -or ($user.StreetAddress -eq $null) -or ($user.l -eq $null) -or ($user.st -eq $null) -or ($user.postalcode -eq $null)))){
        if($user.extensionattribute2 -ne "msbasic"){
            Set-ADUser $user.SamAccountName -Replace @{'extensionattribute2'="msbasic"}
            Add-Content -Path  C:\scripts\results.txt "Updated user $($user.SamAccountName) for basic mail signature."}}
    elseif((($user.Company -eq "COMPANYNAME") -and ($user.telephoneNumber -ne $null) -and ($user.mobile -eq $null)  -and ($user.facsimileTelephoneNumber -ne $null) -and ($user.StreetAddress -ne $null) -and ($user.l -ne $null) -and ($user.st -ne $null) -and ($user.postalcode -ne $null))){
        if($user.extensionattribute2 -ne "msstandard"){
            Set-ADUser $user.SamAccountName -Replace @{'extensionattribute2'="msstandard"}
            Add-Content -Path  C:\scripts\results.txt "Updated user $($user.SamAccountName) for standard mail signature."}}
    elseif((($user.Company -eq "COMPANYNAME") -and ($user.telephoneNumber -ne $null) -and ($user.mobile -ne $null) -and ($user.facsimileTelephoneNumber -ne $null) -and ($user.StreetAddress -ne $null) -and ($user.l -ne $null) -and ($user.st -ne $null) -and ($user.postalcode -ne $null))){
        if($user.extensionattribute2 -ne "msextended"){
            Set-ADUser $user.SamAccountName -Replace @{'extensionattribute2'="msextended"}
            Add-Content -Path  C:\scripts\results.txt "Updated user $($user.SamAccountName) for extended mail signature."}}}
#endregion signature-assignment

#region mailresults
$body = "Active Directory Changes:`n"
$body += (get-Content -Path C:\scripts\results.txt) -join "`n"

if($body -ne "Active Directory Changes:`n"){Send-MailMessage -From no_reply@COMPANYNAME.net -To usermanagement@COMPANYNAME.onmicrosoft.com -Subject "User Setup Results" -Body $body -SmtpServer ds-ca.COMPANYNAME.net}
else{}
#endregion mailresults