#netmon-error-report.ps1
#Adam Ausburn

#This script is used to generate a weekly report of any PRTG sensor
#in the warning state.

$netmonuser = "netmon"
$netmonpasswd = ConvertTo-SecureString "KHpJPpiHTXqyC7DhRbRf5BRFhiHauZzg" -AsPlainText -Force
$netmoncreds = New-Object System.Management.Automation.PSCredential ($netmonuser, $netmonpasswd)
#end temp area

#modules
Import-Module ActiveDirectory   #Installed with RSAT ADLDS Optional Feature
Import-Module PrtgAPI           #Installed with Install-Module PrtgAPI

#connect to netmon
Connect-PrtgServer -Server netmon.arcare.net -Credential $netmoncreds #Comment out when doing script updates since it keeps the instance

#get-device | Where-Object {($_.name -like "*switch*") -and ($_.name -like "*voice*")} | Set-ObjectProperty name "Voice Switch"
#Get-Object | Where-Object {$_.name -eq "switch"} | set-object

#Netmon query and conversion section
$p = Get-Sensor | Where-Object {$_.status -eq 'Warning'} #Grab all sensors from netmon in the warning state

foreach($pp in $p){
    #Sensor Types not added yet
    #10zig (monitors tftp server)
    #additional (monitors folder share on fs-pd)
    #facilities (monitors folder share on fs-pd)
    #users (monitors folder share on fs-userprofile)
    #Cloud HTTP
    #Free Disk Space
    #Service
    #ssh (ehsdb)
    #database connection (ehsdb)
    #HTTP
    #Generator Running
    #Hot Side Temp (server room temp)
    #Cold Side Temp (server room temp)
    #System Health (netmon)
    #Core Health (netmon)
    #Probe Health (netmon)
    #stack - slot 1 (extreme)
    #stack - slot 2 (extreme)
    #fan operational (extreme)
    #serial number (extreme)
    #utilization - upload
    #utilization - download
    #Eventlog

    $pp.url = "https://netmon.arcare.net" + $pp.url
    $pp.url = "'<a href=" + $pp.url + ">$($pp.Id)</a>'"

    if($pp.Name -like "Ping*"){
        $temp = [regex]::Matches($pp.Message,('ICMP error'))| Select-Object -ExpandProperty Value
        $pp.Message = "Device has been offline since " + $pp.LastUp
    }
    if($pp.Name -eq "primary image version"){
        $pp.Name = "Switch Firmware Outdated"
        $firmware = [regex]::Matches($pp.Message,('\d\d.\d.\d.\d'))| Select-Object -ExpandProperty Value
        $pp.Message = "Version Detected: " + $firmware[1] + ". Version Needed: " + $firmware[0]
    }
    if($pp.Message -like "*# (extreme current temperature) is above the warning limit of 80 # in extreme current temperature*"){
        $temp = [regex]::Matches($pp.Message,('\b([8-9])\d # ')) | Select-Object -ExpandProperty Value        
        $pp.Message = "Temp Detected: " + ([int]$temp[0].Substring(0,2) * 1.8) + " degrees. Warning Threshold: " + ([int]$temp[1].Substring(0,2) * 1.8) + " Critical Threshold: " + (100 * 1.8)
    }
    if($pp.Comments -like "*freshdesk*"){
        $pp.Comments = "'<a href=" + $pp.Comments + ">Ticket Reference</a>'"
    }
}
 
$a = "<style>"
$a = $a + "BODY{background-color:peachpuff;}"
$a = $a + "TABLE{border-width: 2px;border-style: solid;border-color: black;border-collapse: collapse;}"
$a = $a + "TH{border-width: 1px;padding: 2px;border-style: solid;border-color: black;background-color:thistle}"
$a = $a + "TD{border-width: 1px;padding: 4px;border-style: solid;border-color: black;background-color:white}"
$a = $a + "</style>"
$dd = (get-date)
$a = $a + "<h2>$Heading ($dd)</h2>"

$emailbody = $p | Where-Object {$_.status -ne 'Up' -and $_.status -ne 'Paused (paused by parent)' -and $_.status -ne 'Paused (paused)'} | Select-Object @{L='Location';E='group'},@{L='Sensor Type';E='name'},@{L='Description';E='message'},device,@{L='Netmon URL';E='Url'},comments |ConvertTo-Html -Head $a
$emailbody = $emailbody -replace '&gt;','>' -replace '&lt;','<' -replace '&#39;',""

#email
$users = Get-ADUser -Filter {(department -eq "IT") -and (enabled -eq $true)} -Properties name,mail -Server "ds-rodc01.arcare.net"
#$users = Get-ADUser -Filter {(mail -eq "Adam.Ausburn@arcare.net") -and (enabled -eq $true)} -Properties name,mail -Server "ds-rodc01.arcare.net"

foreach($u in $users){
    Send-MailMessage -to $u.mail -Subject "Netmon Report - Action Items" -BodyAsHtml -body "$emailbody" -from no_reply@arcare.net -SmtpServer ds-ca.arcare.net
    }
