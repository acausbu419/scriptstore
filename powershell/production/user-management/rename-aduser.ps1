#Prompt for username
$old_username = Read-Host "Enter the current username i.e. Lester.Tester"
$new_username = Read-Host "Enter the new username i.e. Lester.TesterNew"

$first_last = $new_username.Split('.')
$displayname = $first_last[0] + " " + $first_last[1]

$user = Get-ADUser $old_username -Properties Company,Mail,proxyAddresses,displayname

if(($user.Company -ne "COMPANYNAME") -and ($user.company -ne "COMPANYNAME")){
$user.Company = "COMPANYNAME"
}

$newupn = $first_last[0] + "." + $first_last[1] + "@" + $user.company + ".net"
$oldupn = $user.UserPrincipalName
$samaccountname = $first_last[0] + "." + $first_last[1]
$user.Company = $user.Company.ToLower()

#On Prem Rename Section
try{
    $error.Clear()
    Set-ADUser -Identity $user.DistinguishedName `
               -DisplayName $displayname `
               -UserPrincipalName $newupn `
               -EmailAddress $newupn `
               -SamAccountName $samaccountname `
               -GivenName $first_last[0] `
               -Surname $first_last[1] `
               -Replace @{proxyAddresses = "SMTP:" + $newupn}

    $renameduser = Get-ADUser $new_username -Properties Company,Mail,proxyAddresses,displayname

    Set-ADUser -Identity $renameduser.DistinguishedName `
               -Add @{proxyAddresses = "smtp:" + $oldupn}

    Rename-ADObject -Identity $renameduser.DistinguishedName -NewName $displayname
}
catch{
    Write-Host $error[0]
}
finally{
    $renameduser = Get-ADUser $new_username -Properties Company,Mail,proxyAddresses,displayname

    if(($renameduser.Name -eq $displayname) -and ($null -eq $error[0])){
        Write-Host "Results: Updated $user.displayname to $renameduser.displayname"
    }
}

#Azure AD Rename Section
#Install-Module AzureAD
#Import-Module AzureAD

#Connect-AzureAD
#Get-AzureADUser -ObjectId $newupn
#Set-AzureADUser -ObjectId $oldupn -UserPrincipalName $newupn

Read-Host -Prompt "Hit enter to close"