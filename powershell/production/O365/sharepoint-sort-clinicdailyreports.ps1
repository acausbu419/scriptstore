#Folder Creation Spam
#md -Name $_ $(1..254 | % {"{0:000}" -f $_ } )

#Declare base path for reports
$path = "E:\additional\clinicdailyreports\"
#Grab all files under each site's folder
$files = Get-ChildItem -Path $path -Recurse -Include *.* | Select-Object name,fullname,creationtime

foreach($f in $files){
    #variable buildout for folder paths
    $fpath = $f.FullName | Split-Path
    $site = $fpath -replace "[^0-9]"
    $year = $f.CreationTime.Year
    $month = (Get-Culture).DateTimeFormat.GetMonthName($f.CreationTime.Month)
    #$day = $f.CreationTime.Day
    $yearpath = $path + $site + "\" + $year
    $monthpath = $yearpath + "\" + $month
    #$daypath = $monthpath + "\" + $day
    #For each file, check the subfolder path for the year.
    #If no year subfolder, make it.
    if(!(Test-Path -Path $yearpath)){
        New-Item -ItemType Directory -Path $yearpath
        }
    #For each file, check the subfolder path for the month.
    #If no month subfolder, make it.
    if(!(Test-Path -Path $monthpath)){
        New-Item -ItemType Directory -Path $monthpath
        }
    #For each file, check the subfolder path for the day.
    #If no day subfolder, make it.
    #if(!(Test-Path -Path $daypath)){
        #New-Item -ItemType Directory -Path $daypath
        #}
    #After the full path is made with the above statements, move each file to
    #the path the corresponds to the date it was created.
    Move-Item -Path $f.FullName -Destination $monthpath
    }