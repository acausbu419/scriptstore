#Clinic Regions 1
$1 = "060", "025", "026", "045", "090", "131"
$2 = "085", "023", "100", "035", "048", "041", "028", "137"
$3 = "075", "064", "080", "093", "046", "089"
$4 = "010", "029", "050", "120", "016", "031"
$5 = "055", "059", "022", "065"
$6 = "018", "078", "088b", "024", "042", "032", "111", "121"
$7 = "020", "070", "030", "040", "047", "017"
$8 = "033", "136", "124", "135", "105"
#Clinic Regions 2
$9 = "021", "043a", "043b", "044a", "044b", "063", "112", "128", "240"
#Clinic Regions 3
$10 = "113", "129"

$qa = New-Object -ComObject shell.application

#Remove all facility folder paths from quick access menu
if($qa.Namespace("shell:::{679F85CB-0220-4080-B29B-5540CC05AAB6}").Items() | Where-Object { $_.Path -like '<#Path#>*' }){
    ($qa.Namespace("shell:::{679F85CB-0220-4080-B29B-5540CC05AAB6}").Items() | Where-Object { $_.Path -like '<#Path#>*' }).InvokeVerb("unpinfromhome")
}

for($site = 0; $1[$site] -match '\d\d\d'; $site++){
    if($1[$site] -eq $env:fa){
        for($pin = 0; $1[$pin] -match '\d\d\d'; $pin++){
            $path = Get-ChildItem -Path "\\fileserver\folder" | Where-Object Name -EQ $1[$pin]
            $qa.NameSpace($($path.FullName)).Self.InvokeVerb("pintohome")
        }
    }
    elseif($null -ne $env:fa){
        $path = Get-ChildItem -Path "\\fileserver\folder" | Where-Object Name -EQ $env:fa
        $qa.NameSpace($($path.FullName)).Self.InvokeVerb("pintohome")
    }
}

for($site = 0; $2[$site] -match '\d\d\d'; $site++){
    if($2[$site] -eq $env:fa){
        for($pin = 0; $2[$pin] -match '\d\d\d'; $pin++){
            $path = Get-ChildItem -Path "\\fileserver\folder" | Where-Object Name -EQ $2[$pin]
            $qa.NameSpace($($path.FullName)).Self.InvokeVerb("pintohome")
        }
    }
    elseif($null -ne $env:fa){
        $path = Get-ChildItem -Path "\\fileserver\folder" | Where-Object Name -EQ $env:fa
        $qa.NameSpace($($path.FullName)).Self.InvokeVerb("pintohome")
    }
}

for($site = 0; $3[$site] -match '\d\d\d'; $site++){
    if($3[$site] -eq $env:fa){
        for($pin = 0; $3[$pin] -match '\d\d\d'; $pin++){
            $path = Get-ChildItem -Path "\\fileserver\folder" | Where-Object Name -EQ $3[$pin]
            $qa.NameSpace($($path.FullName)).Self.InvokeVerb("pintohome")
        }
    }
    elseif($null -ne $env:fa){
        $path = Get-ChildItem -Path "\\fileserver\folder" | Where-Object Name -EQ $env:fa
        $qa.NameSpace($($path.FullName)).Self.InvokeVerb("pintohome")
    }
}

for($site = 0; $4[$site] -match '\d\d\d'; $site++){
    if($4[$site] -eq $env:fa){
        for($pin = 0; $4[$pin] -match '\d\d\d'; $pin++){
            $path = Get-ChildItem -Path "\\fileserver\folder" | Where-Object Name -EQ $4[$pin]
            $qa.NameSpace($($path.FullName)).Self.InvokeVerb("pintohome")
        }
    }
    elseif($null -ne $env:fa){
        $path = Get-ChildItem -Path "\\fileserver\folder" | Where-Object Name -EQ $env:fa
        $qa.NameSpace($($path.FullName)).Self.InvokeVerb("pintohome")
    }
}

for($site = 0; $5[$site] -match '\d\d\d'; $site++){
    if($5[$site] -eq $env:fa){
        for($pin = 0; $5[$pin] -match '\d\d\d'; $pin++){
            $path = Get-ChildItem -Path "\\fileserver\folder" | Where-Object Name -EQ $5[$pin]
            $qa.NameSpace($($path.FullName)).Self.InvokeVerb("pintohome")
        }
    }
    elseif($null -ne $env:fa){
        $path = Get-ChildItem -Path "\\fileserver\folder" | Where-Object Name -EQ $env:fa
        $qa.NameSpace($($path.FullName)).Self.InvokeVerb("pintohome")
    }
}

for($site = 0; $6[$site] -match '\d\d\d'; $site++){
    if($6[$site] -eq $env:fa){
        for($pin = 0; $6[$pin] -match '\d\d\d'; $pin++){
            $path = Get-ChildItem -Path "\\fileserver\folder" | Where-Object Name -EQ $6[$pin]
            $qa.NameSpace($($path.FullName)).Self.InvokeVerb("pintohome")
        }
    }
    elseif($null -ne $env:fa){
        $path = Get-ChildItem -Path "\\fileserver\folder" | Where-Object Name -EQ $env:fa
        $qa.NameSpace($($path.FullName)).Self.InvokeVerb("pintohome")
    }
}

for($site = 0; $7[$site] -match '\d\d\d'; $site++){
    if($7[$site] -eq $env:fa){
        for($pin = 0; $7[$pin] -match '\d\d\d'; $pin++){
            $path = Get-ChildItem -Path "\\fileserver\folder" | Where-Object Name -EQ $7[$pin]
            $qa.NameSpace($($path.FullName)).Self.InvokeVerb("pintohome")
        }
    }
    elseif($null -ne $env:fa){
        $path = Get-ChildItem -Path "\\fileserver\folder" | Where-Object Name -EQ $env:fa
        $qa.NameSpace($($path.FullName)).Self.InvokeVerb("pintohome")
    }
}

for($site = 0; $8[$site] -match '\d\d\d'; $site++){
    if($8[$site] -eq $env:fa){
        for($pin = 0; $8[$pin] -match '\d\d\d'; $pin++){
            $path = Get-ChildItem -Path "\\fileserver\folder" | Where-Object Name -EQ $8[$pin]
            $qa.NameSpace($($path.FullName)).Self.InvokeVerb("pintohome")
        }
    }
    elseif($null -ne $env:fa){
        $path = Get-ChildItem -Path "\\fileserver\folder" | Where-Object Name -EQ $env:fa
        $qa.NameSpace($($path.FullName)).Self.InvokeVerb("pintohome")
    }
}

for($site = 0; $9[$site] -match '\d\d\d'; $site++){
    if($9[$site] -eq $env:fa){
        for($pin = 0; $9[$pin] -match '\d\d\d'; $pin++){
            $path = Get-ChildItem -Path "\\fileserver\folder" | Where-Object Name -EQ $9[$pin]
            $qa.NameSpace($($path.FullName)).Self.InvokeVerb("pintohome")
        }
    }
    elseif($null -ne $env:fa){
        $path = Get-ChildItem -Path "\\fileserver\folder" | Where-Object Name -EQ $env:fa
        $qa.NameSpace($($path.FullName)).Self.InvokeVerb("pintohome")
    }
}

for($site = 0; $10[$site] -match '\d\d\d'; $site++){
    if($10[$site] -eq $env:fa){
        for($pin = 0; $10[$pin] -match '\d\d\d'; $pin++){
            $path = Get-ChildItem -Path "\\fileserver\folder" | Where-Object Name -EQ $10[$pin]
            $qa.NameSpace($($path.FullName)).Self.InvokeVerb("pintohome")
        }
    }
    elseif($null -ne $env:fa){
        $path = Get-ChildItem -Path "\\fileserver\folder" | Where-Object Name -EQ $env:fa
        $qa.NameSpace($($path.FullName)).Self.InvokeVerb("pintohome")
    }
}