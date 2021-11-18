Connect-ExchangeOnline

#Microsoft 365 Groups
$groups = Get-UnifiedGroup

foreach($group in $groups){
    #Clear Results
    #$groupmembers
    #Get Owners
    $groupowners = Get-UnifiedGroupLinks -LinkType Owners -Identity $group.Name
    #Get Members
    $groupmembers = Get-UnifiedGroupLinks -LinkType Members -Identity $group.Name
    
    foreach($go in $groupowners){
        #Generate email body
        $body = "You are receiving this email since you are listed as an owner of the '" + $group.DisplayName + "' group.`n`n"
        $body += "Please review the information below. If you need to make changes, you can do so at https://outlook.office.com/people/group/owner `n`n"
        $body += "Group: " + $group.DisplayName + "`n`n"
        $body += "Group Owner(s):`n" 

        foreach($go in $groupowners){
            $body += $go.name + "`n"
        }

        $body += "`nGroup Member(s):`n"

        foreach($gm in $groupmembers){
            $body += $gm.name + "`n"
        }

        write-output $body
    }
}






#Distribution Groups
#Get-DistributionGroup

#Security Groups (main enabled only)?

#Shared mailboxes