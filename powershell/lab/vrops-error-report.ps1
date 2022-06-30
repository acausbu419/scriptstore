$report = Import-Csv -Path <#Path To File#>

#Critical Reports
foreach($r in $report){
    #write-host $r.'Criticality Level' $r.Name $r.'Object Name'
    if($r.Name -like '*Hardware sensor health state degraded*'){
        $r.Name = "Hardware Health Sensor"
    }
    if($r.Name -like 'One or more virtual machine guest file systems are running out of disk space*'){
        $r.Name = "Disk Space"
    }    
    if($r.Name -eq "The host has lost redundant connectivity to a dvPort"){
        $r.Name = "dvPort Redundancy Lost"
    }
    if($r.Name -eq "The host has lost connectivity to a dvPort"){
        $r.Name = "dvPort Disconnected"
    }
    if($r.Name -eq "Virtual machine is running on snapshots for more than 2 days"){
        $r.Name = "Snapshot Warning"
    }    
    
    $r.Name + " " + $r.'Object Name' + " " + $r.'Alert Type' + " " + $r.'Criticality Level' + " " + $r.'Start Time' + $r.Status
}