$qa = New-Object -ComObject shell.application

#Remove all facility folder paths from quick access menu
if($qa.Namespace("shell:::{679F85CB-0220-4080-B29B-5540CC05AAB6}").Items() | Where-Object { $_.Path -like '*facilities*' }){
    ($qa.Namespace("shell:::{679F85CB-0220-4080-B29B-5540CC05AAB6}").Items() | Where-Object { $_.Path -like '*facilities*' }).InvokeVerb("unpinfromhome")
}

#Using current FA environment variable, add current facility to quick access
if($env:fa -ne $null){
    $path = Get-ChildItem -Path "\\fs-pd\facilities" | Where-Object Name -EQ $env:fa
    $qa.NameSpace($($path.FullName)).Self.InvokeVerb("pintohome")
}