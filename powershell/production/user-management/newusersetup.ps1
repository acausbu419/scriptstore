#Clear errors from memory for testing purposes
#$Error.Clear()

#region ResultList
$resultList = @(
    '0 - Success.'
    '1000 - Business Associate submission. Process as EMPLOYID + current year.'
    '1001 - Employee rehire submission.'
    '1002 - Employee new hire submission.'
    '2000 - Submitted employee ID is not valid. SSN Field submitted with less than 4 digits.'
    '2001 - Business Associate submission. Duplicate EID found in Active Directory.'
    '2002 - Employee new hire submission - Duplicate EID in submission.'
    '2003 - Employee new hire submisison - Duplicate account and EID found.'
)
#endregion

#region Prereqs#Modules required script to function#Check for ImportExcel module and install if not foundif (Get-Module -ListAvailable -Name ImportExcel) {    Set-ExecutionPolicy Bypass -Force    Import-Module ImportExcel} else {    Set-PackageSource -Name MyNuget -NewName NewNuGet -Trusted -ProviderName NuGet -Force -ErrorAction SilentlyContinue    Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted -ErrorAction SilentlyContinue    Install-Module ImportExcel    Import-Module ImportExcel}

Import-Module ActiveDirectory

#Clear results doc from any previous run
Clear-Content -Path "C:\scripts\results.txt"

#Import newemp.xlsx submission and current locations.xlsx files
$users =  Import-Excel "C:\scripts\newemp.xlsx" -ErrorAction SilentlyContinue -EndColumn 10
#Strip out entries with empty EMPLOYID field to clear out junk entries
$users = $users | where {$_.EMPLOYID -match "[A-Za-z]"}

$locations = Import-Excel '\\ds-dc01\c$\scripts\locations.xlsx' -ErrorAction SilentlyContinue
#Strip out entries with empty NAME field to clear out junk entries
$locations = $locations | where {$_.NAME -match "[A-Za-z]"}
#endregion

foreach($user in $users){
    #
    if($user.EMPLOYID -ne ""){
        #Set submitted EID to uppercase
        $user.EMPLOYID = $user.EMPLOYID.ToUpper()
        #Strip out any space characters in first or last name
        $user.FIRSTNAME = $user.FIRSTNAME -replace '[ ]',''
        $user.LASTNAME = $user.LASTNAME -replace '[ ]',''
        #Convert BDAY and STARTTDATE to expected format
        $user.BDAY = ("$($user.BDAY.Month)/$($user.BDAY.Day)/$($user.BDAY.Year)")
        $user.STARTDATE = ("$($user.STARTDATE.Month)/$($user.STARTDATE.Day)/$($user.STARTDATE.Year)")
        #Convert array values to strings for New-ADUser and Set-ADUser functions
        $company = $user.Company
        $employeeid = $user.EMPLOYID
        $ext11 = $user.BDAY 
        $ext12 = $user.STARTDATE
        $ext13 = $user.SITENUMBER | Out-String
        #$ext14 = $user.SITENUMBER | Out-String
        $mail = $null
        $username = ($user.firstname + "." + $user.lastname)

        #Detect if number pattern for employee ID is missing or incomplete in a 4 digit pattern
        if($user.EMPLOYID -notmatch '\d\d\d\d'){
            #Check for a lost digit like a leading 0 and invalidate as a 3 digit pattern.
            if($user.EMPLOYID -match '\d'){
                #2000 - Submitted employee ID is not valid. SSN Field submitted with less than 4 digits.
                Add-Content -Path  "C:\scripts\results.txt" "2000 - User account $($user.FIRSTNAME) $($user.LASTNAME) has an invalid EID of $($user.EMPLOYID) and will not be processed."
            }
            #Process as BA if there is no numeric pattern.
            elseif($user.EMPLOYID -notmatch '\d\d\d'){
                $baemployeeid = $user.EMPLOYID + (Get-Date -Format yyyy)
                $upn = "@arcare.net"
                    $OU = "OU=BA,OU=User Accounts,DC=arcare,DC=net"
                    $state = "AR"
                    $splat = @{ 
                        SamAccountName = ($user.firstname + "." + $user.lastname) 
                        UserPrincipalName = ($user.firstname + "." + $user.lastname + $upn) 
	                    Name = ($user.firstname + " " + $user.lastname) 
                        GivenName = $user.firstname
                        Surname = $user.lastname
                        Title = $user.TITLE
                        Department = $user.DEPARTMENT
                        EmployeeID = $baemployeeid
                        Enabled = $false 
                        Path = $OU 
                        DisplayName = ($user.firstname + " " + $user.lastname) 
                        OtherAttributes = @{'company' = $company;'extensionattribute12' = "$ext12";} 
                        AccountPassword = ConvertTo-SecureString "Arcare1234" -AsPlainText -Force
                        ChangePasswordAtLogon = $true
                    }
                
                #1000 - Business Associate submission. Process as EMPLOYID + current year.
                Add-Content -Path  "C:\scripts\results.txt" "1000 - User account $($user.FIRSTNAME) $($user.LASTNAME) has an EID without a number. Account will be processed as business associate with EID $($baemployeeid)"
                if((Get-ADUser -Filter {employeeid -eq $baemployeeid} -Properties employeeid )){
                #2001 - Business Associate submission. Duplicate EID found in Active Directory.
                Add-Content -Path  "C:\scripts\results.txt" "2001 - User account $($user.FIRSTNAME) $($user.LASTNAME) submitted as business associate but already exists in Active Directory."
                }
                else{
                    New-ADUser @splat -ErrorAction SilentlyContinue
                    if((Get-ADUser -Filter {(samaccountname -eq $username) -and (employeeid -eq $baemployeeid)})){
                    #0 - Success
                    Add-Content -Path  "C:\scripts\results.txt" "0 - Successfully added $($user.FIRSTNAME) $($user.LASTNAME)."
                    }
                }
            }
        }
        #Process as a regular user matching a 4 digit pattern
        elseif($employeeid -match '\d\d\d\d'){
            #Detect rehire or duplicate user
            if((Get-ADUser -Filter {employeeid -eq $employeeid})){
                #Cross check a match with the submitted birthday
                #Process as rehire if EID, BDAY, NAME match
                if(Get-ADUser -Filter {(extensionattribute11 -eq $ext11) -and (samaccountname -eq $username) -and (employeeid -eq $employeeid)}){
                    #Continue if additional match is found
                    if($user.COMPANY -eq "ARcare"){
                        $upn = "@arcare.net"
                        $OU = "OU=AR,OU=User Accounts,DC=arcare,DC=net"
                        $state = "AR"
                        $mail = ($user.firstname + "." + $user.lastname + $upn)}
                    elseif($user.COMPANY -eq "KentuckyCare"){
                        $company = "KentuckyCare"
                        $upn = "@kentuckycare.net"
                        $OU = "OU=KY,OU=User Accounts,DC=arcare,DC=net"
                        $state = "KY"
                        $mail = ($user.firstname + "." + $user.lastname + $upn)}
                    elseif($user.COMPANY -eq "MississippiCare"){
                        $upn = "@mississippicare.net"
                        $OU = "OU=MS,OU=User Accounts,DC=arcare,DC=net"
                        $state = "MS"
                        $mail = ($user.firstname + "." + $user.lastname + $upn)}
                    elseif($user.COMPANY -eq "Pruitt Insurance"){
                        $upn = "@arcare.net"
                        $OU = "OU=Pruitt,OU=User Accounts,DC=arcare,DC=net"
                        $state = "MS"
                        $mail = ($user.firstname + "." + $user.lastname + $upn)}
                    elseif($user.COMPANY -eq "Primary Health"){
                        $upn = "@arcare.net"
                        $OU = "OU=AR,OU=User Accounts,DC=arcare,DC=net"
                        $state = "AR"
                        $mail = ($user.firstname + "." + $user.lastname + $upn)}
                    elseif($user.COMPANY -eq "ICSRX"){
                        $upn = "@arcare.net"
                        $OU = "OU=ICSRX,OU=User Accounts,DC=arcare,DC=net"
                        $state = "AR"
                        $mail = ($user.firstname + "." + $user.lastname + $upn)}
                                        
                        if($mail -ne $null){
                            $splat = @{ 
                                #SamAccountName = ($user.firstname + "." + $user.lastname) 
                                #UserPrincipalName = ($user.firstname + "." + $user.lastname + $upn) 
	                            #Name = ($user.firstname + " " + $user.lastname) 
                                #GivenName = $user.firstname
                                #Surname = $user.lastname
                                Title = $user.TITLE
                                Department = $user.DEPARTMENT
                                EmployeeID = $baemployeeid
                                Enabled = $false 
                                #Path = $OU
                            }
                            #1001 - Employee rehire submission.
                            Add-Content -Path  "C:\scripts\results.txt" "1001 - User account $($user.FIRSTNAME) $($user.LASTNAME) submitted for processing."
                            Set-ADUser -Identity $username @splat -ErrorAction SilentlyContinue
                            if((Get-ADUser -Filter {samaccountname -eq $username})){
                            #0 - Success
                            Add-Content -Path  "C:\scripts\results.txt" "0 - Successfully added $($user.FIRSTNAME) $($user.LASTNAME)."
                            }
                        }
                }
                #Detect if user is unique but EID is already in use.
                elseif((Get-ADUser -Filter {(extensionattribute11 -ne $ext11) -and (samaccountname -ne $username) -and (employeeid -eq $employeeid)})){
                    #2002 - Employee new hire submission - Duplicate EID found.
                    Add-Content -Path  "C:\scripts\results.txt" "2002 - User account $($user.FIRSTNAME) $($user.LASTNAME) submitted but EID $($employeeid) already exists."
                }
                #If there's already an account with the same username & EID
                elseif((Get-ADUser -Filter {(samaccountname -eq $username) -and (employeeid -eq $employeeid)})){
                    #2003 - Employee new hire submission. Duplicate account and EID found.
                    Add-Content -Path  "C:\scripts\results.txt" "2003 - User account $($user.FIRSTNAME) $($user.LASTNAME) with EID $($employeeid) already exists."
            
                }
                #If user does not match at all, create new user as an employee.
                elseif(!(Get-ADUser -Filter {(samaccountname -ne $username) -and (employeeid -ne $employeeid)})) {
                        if($user.COMPANY -eq "ARcare"){
                            $upn = "@arcare.net"
                            $OU = "OU=AR,OU=User Accounts,DC=arcare,DC=net"
                            $state = "AR"
                            $mail = ($user.firstname + "." + $user.lastname + $upn)}
                        elseif($user.COMPANY -eq "KentuckyCare"){
                            $company = "KentuckyCare"
                            $upn = "@kentuckycare.net"
                            $OU = "OU=KY,OU=User Accounts,DC=arcare,DC=net"
                            $state = "KY"
                            $mail = ($user.firstname + "." + $user.lastname + $upn)}
                        elseif($user.COMPANY -eq "MississippiCare"){
                            $upn = "@mississippicare.net"
                            $OU = "OU=MS,OU=User Accounts,DC=arcare,DC=net"
                            $state = "MS"
                            $mail = ($user.firstname + "." + $user.lastname + $upn)}
                        elseif($user.COMPANY -eq "Pruitt Insurance"){
                            $upn = "@arcare.net"
                            $OU = "OU=Pruitt,OU=User Accounts,DC=arcare,DC=net"
                            $state = "MS"
                            $mail = ($user.firstname + "." + $user.lastname + $upn)}
                        elseif($user.COMPANY -eq "Primary Health"){
                            $upn = "@arcare.net"
                            $OU = "OU=AR,OU=User Accounts,DC=arcare,DC=net"
                            $state = "MS"
                            $mail = ($user.firstname + "." + $user.lastname + $upn)}
                        elseif($user.COMPANY -eq "ICSRX"){
                            $upn = "@arcare.net"
                            $OU = "OU=ICSRX,OU=User Accounts,DC=arcare,DC=net"
                            $state = "AR"
                            $mail = ($user.firstname + "." + $user.lastname + $upn)}

                        if($mail -ne $null){
                            $splat = @{ 
                                SamAccountName = ($user.firstname + "." + $user.lastname) 
                                UserPrincipalName = ($user.firstname + "." + $user.lastname + $upn) 
	                            Name = ($user.firstname + " " + $user.lastname) 
                                GivenName = $user.firstname
                                Surname = $user.lastname
                                Title = $user.TITLE
                                Department = $user.DEPARTMENT
                                EmployeeID = $user.EMPLOYID
                                Enabled = $false 
                                Path = $OU
                                DisplayName = ($user.firstname + " " + $user.lastname)
                                OtherAttributes = @{'mail' = "$mail";'company' = "$company";'extensionattribute11' = "$ext11";'extensionattribute12' = "$ext12";'extensionattribute13' = "$ext13";} 
                                AccountPassword = ConvertTo-SecureString "Arcare1234" -AsPlainText -Force
                                ChangePasswordAtLogon = $true
                            }

                            #1002 - Employee new hire submission.
                            Add-Content -Path  "C:\scripts\results.txt" "1002 - User account $($user.FIRSTNAME) $($user.LASTNAME) submitted for processing."
                            New-ADUser @splat -ErrorAction SilentlyContinue
                            if((Get-ADUser -Filter {samaccountname -eq $username})){
                                #0 - Success
                                Add-Content -Path  "C:\scripts\results.txt" "0 - Successfully added $($user.FIRSTNAME) $($user.LASTNAME)."
                            }
                        }
                }
            }
        }
    }
}

#Destroy the evidence
    Remove-Item -Path "C:\flows\newemp.xlsx"

#region mailResults
$body = "Active Directory Changes:`n"
$body += (get-Content -Path "C:\scripts\results.txt") -join "`n"

if($body -ne "Active Directory Changes:`n"){
    $body += "Result Status List:`n`n"
    $body += $resultList -join "`n"
    Send-MailMessage -From no_reply@arcare.net -To usermanagement@arcare.onmicrosoft.com -Subject "User Setup Results" -Body $body -SmtpServer ds-ca.arcare.net
}
#endregion