#netmon-snippets.ps1
#Adam Ausburn

#This script is used as a sort of testing area for PRTG
#using the PrtgAPI module.


#lab space for remote dc connect
#delet dis
#$credstore = Get-Content $env:USERPROFILE\OneDrive\Desktop\creds.txt
#$adpasswd = ConvertTo-SecureString $credstore[0] -AsPlainText -Force
#$adcreds = New-Object System.Management.Automation.PSCredential ($credstore[2], $adpasswd)

#lab space for netmon connect
#replace with api or hash
$netmonuser = "netmon"
$netmonpasswd = ConvertTo-SecureString "KHpJPpiHTXqyC7DhRbRf5BRFhiHauZzg" -AsPlainText -Force

$netmoncreds = New-Object System.Management.Automation.PSCredential ($netmonuser, $netmonpasswd)
#end temp area

#modules
Import-Module ActiveDirectory   #Installed with RSAT ADLDS Optional Feature
Import-Module PrtgAPI           #Installed with Install-Module PrtgAPI

#connect to netmon
#Connect-PrtgServer -Server netmon.arcare.net -Credential $netmoncreds #Comment out when doing script updates since it keeps the instance

#get-device | Where-Object {($_.name -like "*switch*") -and ($_.name -like "*voice*")} | Set-ObjectProperty name "Voice Switch"
#Get-Object | Where-Object {$_.name -eq "switch"} | set-object

#Netmon query and conversion section
$p = Get-Sensor | Where-Object {$_.status -eq 'Warning'} #Grab all sensors from netmon in the warning state

$p = Get-Sensor | Where-Object {$_.name -like "*fan*"} | Select-Object name,active

#Disable Notifications by sensor type
foreach($pp in $p){
    $pp.Active = $false
}

function ToggleNotificationActions($name)
{
    # Connect to your PRTG Server. As a scheduled task, you should create a dedicated API user
    #Connect-PrtgServer https://prtg.example.com (New-Credential prtgadmin prtgadmin) -Force

    # Construct a list each engineer's notification actions
    $actions = Get-NotificationAction "Ticket Notification","Email and push notification to admin"

    # Loop over each engineer and decide whether their action should be enabled or disabled
    foreach($action in $actions)
    {
        if($action.Name -like $name)
        {
            # Engineer is on call. Enable
            Write-Host "Enabling notification action $($action.Name)"

            (Get-PrtgClient).SetObjectProperty($action.Id, [PrtgAPI.ObjectProperty]::Active, $true)
        }
        else
        {
            # Engineer is off call. Disable
            Write-Host "Disabling notification action $($action.Name)"

            (Get-PrtgClient).SetObjectProperty($action.Id, [PrtgAPI.ObjectProperty]::Active, $false)
        }
    }
}

ToggleNotificationActions "*PRTG Users*"


$objects = Get-Object -Resolve | Where-Object { $_ -is "PrtgAPI.SensorOrDeviceOrGroupOrProbe" }
$triggers = $objects | Get-Trigger -Inherited:$false
$unique = $triggers | group { "$($_.parentid)_$($_.subid)" } | ForEach-Object { $_.Group | select -first 1 }
$unique

$objects | 
Select-Object device,name,notificationtypes | 
Where-Object name -Like {'002 -*'}

foreach($o in $objects){
    write-host $o.device $o.name $o.notificationtypes
}

#Get-PrtgClient

#rename to Special Services
$newgroup = Get-Group | Where-Object name -Match '\d\d\d'
foreach($g in $newgroup){
    if($g.Name -like "*Specialservices*"){
        $g.Name = $g.Name -replace "Specialservices","Special Services"
        Set-ObjectProperty -Id $g.Id -Property Name -Value $g.Name
    }
    elseif(($g.Name -like "*Ss") -and ($g.Name -notlike "*Fitness") ){
        $g.Name = $g.Name -replace "Ss","Special Services"
        Set-ObjectProperty -Id $g.Id -Property Name -Value $g.Name
    }
    else{}
    
}
###

#group rename for branch sites
$groups = Get-Group | Where-Object name -Match '\d\d\d'


foreach($g in $groups){
    #$num = $g.name.Substring(0,3)
    #$g.Name
    $g.Name = $g.Name -replace " - "," "
    $g.Name = $g.Name -replace "-"," "
    $temp = [regex]::Split($g.name," ")

    if(($temp[1] -ne $null) -and ($temp[2] -eq $null)){
        $g.Name = $temp[0] + " - " + $temp[1].Substring(0,1).ToUpper() + $temp[1].Substring(1).ToLower()
    }
    elseif(($temp[2] -ne $null) -and ($temp[3] -eq $null)){
        $g.Name = $temp[0] + " - " + $temp[1].Substring(0,1).ToUpper() + $temp[1].Substring(1).ToLower() + " " + $temp[2].Substring(0,1).ToUpper() + $temp[2].Substring(1).ToLower()
    }
    elseif(($temp[3] -ne $null) -and ($temp[4] -eq $null)){
        $g.Name = $temp[0] + " - " + $temp[1].Substring(0,1).ToUpper() + $temp[1].Substring(1).ToLower() + " " + $temp[2].Substring(0,1).ToUpper() + $temp[2].Substring(1).ToLower() + " " + $temp[3].Substring(0,1).ToUpper() + $temp[3].Substring(1).ToLower()
    }
    elseif(($temp[4] -ne $null) -and ($temp[5] -eq $null)){
        $g.Name = $temp[0] + " - " + $temp[1].Substring(0,1).ToUpper() + $temp[1].Substring(1).ToLower() + " " + $temp[2].Substring(0,1).ToUpper() + $temp[2].Substring(1).ToLower() + " " + $temp[3].Substring(0,1).ToUpper() + $temp[3].Substring(1).ToLower() + " " + $temp[4].Substring(0,1).ToUpper() + $temp[4].Substring(1).ToLower()
    }
    elseif($temp[5] -ne $null){
        Write-Host "holup"
    }



    Set-ObjectProperty -Id $g.Id -Property Name -Value $g.Name
}

###

### add ping sensor to edge switches

$switches = Get-Device | Where-Object name -EQ "Edge Switch"
foreach($s in $switches){
    $temp = [regex]::Split($s.group," - ")
    $name = $temp[0] + " - " + $s.Name
    Set-ObjectProperty -Id $s.Id -Property Name -Value $name
}


$switches = Get-Device | Where-Object name -Like "*Edge Switch"
foreach($s in $switches){
    if($null -ne (Get-Sensor -Device $s.Name | Where-Object name -like "*ping*")){}
    else{
        $param = Get-Device $s.Name | New-SensorParameters -RawType ping
        $param.size = 16
        $param.Interval = "00:05:00"
        $param.Name = "Ping"
        $param.tags = "pingsensor"

        $sensor = Get-Device $s.Name | Add-Sensor $param

        $sensor | Set-ObjectProperty -RawParameters @{
            scheduledependency = 0
            dependencytype_ = 2
        } -Force
    }
}

###

### disable notifications for non-critical sensors

$switches = Get-Device | Where-Object name -Like "*Edge Switch"
foreach($s in $switches){}
$sensor = Get-Sensor | Where-Object name -like "utilization*" | Remove-Object -Force
foreach($s in $sensor){}
$s | Format-List

Get-Trigger -Object $s.Name

function ToggleNotificationActions($name)
{
    # Connect to your PRTG Server. As a scheduled task, you should create a dedicated API user
    #Connect-PrtgServer https://prtg.example.com (New-Credential prtgadmin prtgadmin) -Force

    # Construct a list each engineer's notification actions
    $actions = Get-NotificationAction "Email to all members of group PRTG Users Group","Critical - PRTG Users","Warning - PRTG Users"

    # Loop over each engineer and decide whether their action should be enabled or disabled
    foreach($action in $actions)
    {
        if($action.Name -like $name)
        {
            # Engineer is on call. Enable
            Write-Host "Enabling notification action $($action.Name)"

            (Get-PrtgClient).SetObjectProperty($action.Id, [PrtgAPI.ObjectProperty]::Active, $true)
        }
        else
        {
            # Engineer is off call. Disable
            Write-Host "Disabling notification action $($action.Name)"

            (Get-PrtgClient).SetObjectProperty($action.Id, [PrtgAPI.ObjectProperty]::Active, $false)
        }
    }
}

ToggleNotificationActions "*Critical*"

###

Disconnect-PrtgServer
$temp = [regex]::Matches($pp.Message,('ICMP error'))| Select-Object -ExpandProperty Value
        