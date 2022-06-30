Import-Module activedirectory

Remove-Item -Path C:\signatures -Include *.htm -Recurse -Force

$save_location = <#Path#>

$users = Get-ADUser -Filter {(enabled -eq $true)} -SearchBase <#SearchBase#> -Properties samaccountname,company,telephoneNumber,mobile,fax,streetaddress,city,state,postalcode,extensionattribute2,mail,title,mobile,mail,description

foreach ($user in $users) {
    $full_name = "$($user.GivenName) $($User.Surname)"
    $account_name = "$($user.samaccountname)"
    $job_title = "$($user.title)"
    $description = "$($user.description)"
    $location = "$($user.office)"
    $dept = "$($user.department)"
    $comp = "$($user.company)"
    $email = "$($user.mail)"
    $phone = "$($user.telephoneNumber)"
    $mobile = "$($user.mobile)"
    $logo = "$($user.wWWHomePage)"
    $address = "$($user.StreetAddress)"
    $fax = "$($user.Fax)"
    $city = "$($user.City)"
    $state = "$($user.State)"
    $zip = "$($user.PostalCode)"

$output_file = $save_location + $account_name + ".htm"

write-host "Attempting to create signature html file for " $full_name

    if($user.extensionattribute2 -eq "arbasic"){
            "<div style=`"height:150px;width:650px;font-family:calibri,sans-serif;font-size:14px;`"><div style=><strong style=`"color:#0079c1`">" + $full_name + " " + $description + "</strong>" + " | ", $job_title + "<br />", "<strong style=`"color:#0079c1`">" + $comp + "</strong>" + " | " + "<a href=`"https://www.COMPANYNAME.net`"style=`"text-decoration:none;color:#0079c1;`">www.COMPANYNAME.net</a><br /> Like us on <a href=`"https://www.facebook.com/COMPANYNAME`"style=`"text-decoration:none;color:#0079c1;`">Facebook! <img src=`"LOGOPATH`"> </a>", "<br /></div>" | Out-File $output_file}
    elseif($user.extensionattribute2 -eq "arstandard"){
            "<div style=`"height:150px;width:650px;font-family:calibri,sans-serif;font-size:14px;`"><div style=><strong style=`"color:#0079c1`">" + $full_name + " " + $description + "</strong>" + " | ", $job_title + "<br />", "<strong style=`"color:#0079c1`">" + $comp + "</strong>" + " | " + $address  + " | " + $city + ", " + $state + " " + $zip + "<br />" + "O: " + $phone + " | F: " + $fax + "<br /><a href=`"https://www.COMPANYNAME.net`"style=`"text-decoration:none;color:#0079c1;`">www.COMPANYNAME.net</a><br /> Like us on <a href=`"https://www.facebook.com/COMPANYNAME`"style=`"text-decoration:none;color:#0079c1;`">Facebook! <img src=`"LOGOPATH`"> </a>", "<br /></div>" | Out-File $output_file}
    elseif($user.extensionattribute2 -eq "arextended"){
            "<div style=`"height:150px;width:650px;font-family:calibri,sans-serif;font-size:14px;`"><div style=><strong style=`"color:#0079c1`">" + $full_name + " " + $description + "</strong>" + " | ", $job_title + "<br />", "<strong style=`"color:#0079c1`">" + $comp + "</strong>" + " | " + $address  + " | " + $city + ", " + $state + " " + $zip + "<br />" + "O: " + $phone + " | M: " + $mobile + " | F: " + $fax + "<br /><a href=`"https://www.COMPANYNAME.net`"style=`"text-decoration:none;color:#0079c1;`">www.COMPANYNAME.net</a><br /> Like us on <a href=`"https://www.facebook.com/COMPANYNAME`"style=`"text-decoration:none;color:#0079c1;`">Facebook! <img src=`"LOGOPATH`"> </a>", "<br /></div>" | Out-File $output_file}
    elseif($user.extensionattribute2 -eq "kybasic"){
            "<div style=`"height:150px;width:650px;font-family:calibri,sans-serif;font-size:14px;`"><div style=><strong style=`"color:#0079c1`">" + $full_name + " " + $description + "</strong>" + " | ", $job_title + "<br />", "<strong style=`"color:#0079c1`">" + $comp + "</strong>" + " | " + "<a href=`"https://www.COMPANYNAME.net`"style=`"text-decoration:none;color:#0079c1;`">www.COMPANYNAME.net</a><br /> Like us on <a href=`"https://www.facebook.com/COMPANYNAME`"style=`"text-decoration:none;color:#0079c1;`">Facebook! <img src=`"LOGOPATH`"> </a>", "<br /></div>" | Out-File $output_file}
    elseif($user.extensionattribute2 -eq "kystandard"){
            "<div style=`"height:150px;width:650px;font-family:calibri,sans-serif;font-size:14px;`"><div style=><strong style=`"color:#0079c1`">" + $full_name + " " + $description + "</strong>" + " | ", $job_title + "<br />", "<strong style=`"color:#0079c1`">" + $comp + "</strong>" + " | " + $address  + " | " + $city + ", " + $state + " " + $zip + "<br />" + "O: " + $phone + " | F: " + $fax + "<br /><a href=`"https://www.COMPANYNAME.net`"style=`"text-decoration:none;color:#0079c1;`">www.COMPANYNAME.net</a><br /> Like us on <a href=`"https://www.facebook.com/COMPANYNAME`"style=`"text-decoration:none;color:#0079c1;`">Facebook! <img src=`"LOGOPATH`"> </a>", "<br /></div>" | Out-File $output_file}
    elseif($user.extensionattribute2 -eq "kyextended"){
            "<div style=`"height:150px;width:650px;font-family:calibri,sans-serif;font-size:14px;`"><div style=><strong style=`"color:#0079c1`">" + $full_name + " " + $description + "</strong>" + " | ", $job_title + "<br />", "<strong style=`"color:#0079c1`">" + $comp + "</strong>" + " | " + $address  + " | " + $city + ", " + $state + " " + $zip + "<br />" + "O: " + $phone + " | M: " + $mobile + " | F: " + $fax + "<br /><a href=`"https://www.COMPANYNAME.net`"style=`"text-decoration:none;color:#0079c1;`">www.COMPANYNAME.net</a><br /> Like us on <a href=`"https://www.facebook.com/COMPANYNAME`"style=`"text-decoration:none;color:#0079c1;`">Facebook! <img src=`"LOGOPATH`"> </a>", "<br /></div>" | Out-File $output_file}
    elseif($user.extensionattribute2 -eq "msbasic"){
            "<div style=`"height:150px;width:650px;font-family:calibri,sans-serif;font-size:14px;`"><div style=><strong style=`"color:#0079c1`">" + $full_name + " " + $description + "</strong>" + " | ", $job_title + "<br />", "<strong style=`"color:#0079c1`">" + $comp + "</strong>" + " | " + "<a href=`"https://www.COMPANYNAME.net`"style=`"text-decoration:none;color:#0079c1;`">www.COMPANYNAME.net</a><br /> Like us on <a href=`"https://www.facebook.com/COMPANYNAME`"style=`"text-decoration:none;color:#0079c1;`">Facebook! <img src=`"LOGOPATH`"> </a>", "<br /></div>" | Out-File $output_file}
    elseif($user.extensionattribute2 -eq "msstandard"){
            "<div style=`"height:150px;width:650px;font-family:calibri,sans-serif;font-size:14px;`"><div style=><strong style=`"color:#0079c1`">" + $full_name + " " + $description + "</strong>" + " | ", $job_title + "<br />", "<strong style=`"color:#0079c1`">" + $comp + "</strong>" + " | " + $address  + " | " + $city + ", " + $state + " " + $zip + "<br />" + "O: " + $phone + " | F: " + $fax + "<br /><a href=`"https://www.COMPANYNAME.net`"style=`"text-decoration:none;color:#0079c1;`">www.COMPANYNAME.net</a><br /> Like us on <a href=`"https://www.facebook.com/COMPANYNAME`"style=`"text-decoration:none;color:#0079c1;`">Facebook! <img src=`"LOGOPATH`"> </a>", "<br /></div>" | Out-File $output_file}
    elseif($user.extensionattribute2 -eq "msextended"){
            "<div style=`"height:150px;width:650px;font-family:calibri,sans-serif;font-size:14px;`"><div style=><strong style=`"color:#0079c1`">" + $full_name + " " + $description + "</strong>" + " | ", $job_title + "<br />", "<strong style=`"color:#0079c1`">" + $comp + "</strong>" + " | " + $address  + " | " + $city + ", " + $state + " " + $zip + "<br />" + "O: " + $phone + " | M: " + $mobile + " | F: " + $fax + "<br /><a href=`"https://www.COMPANYNAME.net`"style=`"text-decoration:none;color:#0079c1;`">www.COMPANYNAME.net</a><br /> Like us on <a href=`"https://www.facebook.com/COMPANYNAME`"style=`"text-decoration:none;color:#0079c1;`">Facebook! <img src=`"LOGOPATH`"> </a>", "<br /></div>" | Out-File $output_file}
    }

$save_location = '\\SERVERFQDN.COMPANYNAME.net\c$\signatures\ky\'

$users = Get-ADUser -Filter {(enabled -eq $true)} -SearchBase <#SearchBase#> -Properties samaccountname,company,telephoneNumber,mobile,fax,streetaddress,city,state,postalcode,extensionattribute2,mail,title,mobile,mail,description

foreach ($user in $users) {
    $full_name = "$($user.GivenName) $($User.Surname)"
    $account_name = "$($user.samaccountname)"
    $job_title = "$($user.title)"
    $description = "$($user.description)"
    $location = "$($user.office)"
    $dept = "$($user.department)"
    $comp = "$($user.company)"
    $email = "$($user.mail)"
    $phone = "$($user.telephoneNumber)"
    $mobile = "$($user.mobile)"
    $logo = "$($user.wWWHomePage)"
    $address = "$($user.StreetAddress)"
    $fax = "$($user.Fax)"
    $city = "$($user.City)"
    $state = "$($user.State)"
    $zip = "$($user.PostalCode)"

$output_file = $save_location + $account_name + ".htm"

write-host "Attempting to create signature html file for " $full_name

    if($user.extensionattribute2 -eq "arbasic"){
            "<div style=`"height:150px;width:650px;font-family:calibri,sans-serif;font-size:14px;`"><div style=><strong style=`"color:#0079c1`">" + $full_name + " " + $description + "</strong>" + " | ", $job_title + "<br />", "<strong style=`"color:#0079c1`">" + $comp + "</strong>" + " | " + "<a href=`"https://www.COMPANYNAME.net`"style=`"text-decoration:none;color:#0079c1;`">www.COMPANYNAME.net</a><br /> Like us on <a href=`"https://www.facebook.com/COMPANYNAME`"style=`"text-decoration:none;color:#0079c1;`">Facebook! <img src=`"LOGOPATH`"> </a>", "<br /></div>" | Out-File $output_file}
    elseif($user.extensionattribute2 -eq "arstandard"){
            "<div style=`"height:150px;width:650px;font-family:calibri,sans-serif;font-size:14px;`"><div style=><strong style=`"color:#0079c1`">" + $full_name + " " + $description + "</strong>" + " | ", $job_title + "<br />", "<strong style=`"color:#0079c1`">" + $comp + "</strong>" + " | " + $address  + " | " + $city + ", " + $state + " " + $zip + "<br />" + "O: " + $phone + " | F: " + $fax + "<br /><a href=`"https://www.COMPANYNAME.net`"style=`"text-decoration:none;color:#0079c1;`">www.COMPANYNAME.net</a><br /> Like us on <a href=`"https://www.facebook.com/COMPANYNAME`"style=`"text-decoration:none;color:#0079c1;`">Facebook! <img src=`"LOGOPATH`"> </a>", "<br /></div>" | Out-File $output_file}
    elseif($user.extensionattribute2 -eq "arextended"){
            "<div style=`"height:150px;width:650px;font-family:calibri,sans-serif;font-size:14px;`"><div style=><strong style=`"color:#0079c1`">" + $full_name + " " + $description + "</strong>" + " | ", $job_title + "<br />", "<strong style=`"color:#0079c1`">" + $comp + "</strong>" + " | " + $address  + " | " + $city + ", " + $state + " " + $zip + "<br />" + "O: " + $phone + " | M: " + $mobile + " | F: " + $fax + "<br /><a href=`"https://www.COMPANYNAME.net`"style=`"text-decoration:none;color:#0079c1;`">www.COMPANYNAME.net</a><br /> Like us on <a href=`"https://www.facebook.com/COMPANYNAME`"style=`"text-decoration:none;color:#0079c1;`">Facebook! <img src=`"LOGOPATH`"> </a>", "<br /></div>" | Out-File $output_file}
    elseif($user.extensionattribute2 -eq "kybasic"){
            "<div style=`"height:150px;width:650px;font-family:calibri,sans-serif;font-size:14px;`"><div style=><strong style=`"color:#0079c1`">" + $full_name + " " + $description + "</strong>" + " | ", $job_title + "<br />", "<strong style=`"color:#0079c1`">" + $comp + "</strong>" + " | " + "<a href=`"https://www.COMPANYNAME.net`"style=`"text-decoration:none;color:#0079c1;`">www.COMPANYNAME.net</a><br /> Like us on <a href=`"https://www.facebook.com/COMPANYNAME`"style=`"text-decoration:none;color:#0079c1;`">Facebook! <img src=`"LOGOPATH`"> </a>", "<br /></div>" | Out-File $output_file}
    elseif($user.extensionattribute2 -eq "kystandard"){
            "<div style=`"height:150px;width:650px;font-family:calibri,sans-serif;font-size:14px;`"><div style=><strong style=`"color:#0079c1`">" + $full_name + " " + $description + "</strong>" + " | ", $job_title + "<br />", "<strong style=`"color:#0079c1`">" + $comp + "</strong>" + " | " + $address  + " | " + $city + ", " + $state + " " + $zip + "<br />" + "O: " + $phone + " | F: " + $fax + "<br /><a href=`"https://www.COMPANYNAME.net`"style=`"text-decoration:none;color:#0079c1;`">www.COMPANYNAME.net</a><br /> Like us on <a href=`"https://www.facebook.com/COMPANYNAME`"style=`"text-decoration:none;color:#0079c1;`">Facebook! <img src=`"LOGOPATH`"> </a>", "<br /></div>" | Out-File $output_file}
    elseif($user.extensionattribute2 -eq "kyextended"){
            "<div style=`"height:150px;width:650px;font-family:calibri,sans-serif;font-size:14px;`"><div style=><strong style=`"color:#0079c1`">" + $full_name + " " + $description + "</strong>" + " | ", $job_title + "<br />", "<strong style=`"color:#0079c1`">" + $comp + "</strong>" + " | " + $address  + " | " + $city + ", " + $state + " " + $zip + "<br />" + "O: " + $phone + " | M: " + $mobile + " | F: " + $fax + "<br /><a href=`"https://www.COMPANYNAME.net`"style=`"text-decoration:none;color:#0079c1;`">www.COMPANYNAME.net</a><br /> Like us on <a href=`"https://www.facebook.com/COMPANYNAME`"style=`"text-decoration:none;color:#0079c1;`">Facebook! <img src=`"LOGOPATH`"> </a>", "<br /></div>" | Out-File $output_file}
    elseif($user.extensionattribute2 -eq "msbasic"){
            "<div style=`"height:150px;width:650px;font-family:calibri,sans-serif;font-size:14px;`"><div style=><strong style=`"color:#0079c1`">" + $full_name + " " + $description + "</strong>" + " | ", $job_title + "<br />", "<strong style=`"color:#0079c1`">" + $comp + "</strong>" + " | " + "<a href=`"https://www.COMPANYNAME.net`"style=`"text-decoration:none;color:#0079c1;`">www.COMPANYNAME.net</a><br /> Like us on <a href=`"https://www.facebook.com/COMPANYNAME`"style=`"text-decoration:none;color:#0079c1;`">Facebook! <img src=`"LOGOPATH`"> </a>", "<br /></div>" | Out-File $output_file}
    elseif($user.extensionattribute2 -eq "msstandard"){
            "<div style=`"height:150px;width:650px;font-family:calibri,sans-serif;font-size:14px;`"><div style=><strong style=`"color:#0079c1`">" + $full_name + " " + $description + "</strong>" + " | ", $job_title + "<br />", "<strong style=`"color:#0079c1`">" + $comp + "</strong>" + " | " + $address  + " | " + $city + ", " + $state + " " + $zip + "<br />" + "O: " + $phone + " | F: " + $fax + "<br /><a href=`"https://www.COMPANYNAME.net`"style=`"text-decoration:none;color:#0079c1;`">www.COMPANYNAME.net</a><br /> Like us on <a href=`"https://www.facebook.com/COMPANYNAME`"style=`"text-decoration:none;color:#0079c1;`">Facebook! <img src=`"LOGOPATH`"> </a>", "<br /></div>" | Out-File $output_file}
    elseif($user.extensionattribute2 -eq "msextended"){
            "<div style=`"height:150px;width:650px;font-family:calibri,sans-serif;font-size:14px;`"><div style=><strong style=`"color:#0079c1`">" + $full_name + " " + $description + "</strong>" + " | ", $job_title + "<br />", "<strong style=`"color:#0079c1`">" + $comp + "</strong>" + " | " + $address  + " | " + $city + ", " + $state + " " + $zip + "<br />" + "O: " + $phone + " | M: " + $mobile + " | F: " + $fax + "<br /><a href=`"https://www.COMPANYNAME.net`"style=`"text-decoration:none;color:#0079c1;`">www.COMPANYNAME.net</a><br /> Like us on <a href=`"https://www.facebook.com/COMPANYNAME`"style=`"text-decoration:none;color:#0079c1;`">Facebook! <img src=`"LOGOPATH`"> </a>", "<br /></div>" | Out-File $output_file}
    }

$save_location = '\\SERVERFQDN.COMPANYNAME.net\c$\signatures\ms\'

$users = Get-ADUser -Filter {(enabled -eq $true)} -SearchBase <#SearchBase#> -Properties samaccountname,company,telephoneNumber,mobile,fax,streetaddress,city,state,postalcode,extensionattribute2,mail,title,mobile,mail,description

foreach ($user in $users) {
    $full_name = "$($user.GivenName) $($User.Surname)"
    $account_name = "$($user.samaccountname)"
    $job_title = "$($user.title)"
    $description = "$($user.description)"
    $location = "$($user.office)"
    $dept = "$($user.department)"
    $comp = "$($user.company)"
    $email = "$($user.mail)"
    $phone = "$($user.telephoneNumber)"
    $mobile = "$($user.mobile)"
    $logo = "$($user.wWWHomePage)"
    $address = "$($user.StreetAddress)"
    $fax = "$($user.Fax)"
    $city = "$($user.City)"
    $state = "$($user.State)"
    $zip = "$($user.PostalCode)"

$output_file = $save_location + $account_name + ".htm"

write-host "Attempting to create signature html file for " $full_name

    if($user.extensionattribute2 -eq "arbasic"){
            "<div style=`"height:150px;width:650px;font-family:calibri,sans-serif;font-size:14px;`"><div style=><strong style=`"color:#0079c1`">" + $full_name + " " + $description + "</strong>" + " | ", $job_title + "<br />", "<strong style=`"color:#0079c1`">" + $comp + "</strong>" + " | " + "<a href=`"https://www.COMPANYNAME.net`"style=`"text-decoration:none;color:#0079c1;`">www.COMPANYNAME.net</a><br /> Like us on <a href=`"https://www.facebook.com/COMPANYNAME`"style=`"text-decoration:none;color:#0079c1;`">Facebook! <img src=`"LOGOPATH`"> </a>", "<br /></div>" | Out-File $output_file}
    elseif($user.extensionattribute2 -eq "arstandard"){
            "<div style=`"height:150px;width:650px;font-family:calibri,sans-serif;font-size:14px;`"><div style=><strong style=`"color:#0079c1`">" + $full_name + " " + $description + "</strong>" + " | ", $job_title + "<br />", "<strong style=`"color:#0079c1`">" + $comp + "</strong>" + " | " + $address  + " | " + $city + ", " + $state + " " + $zip + "<br />" + "O: " + $phone + " | F: " + $fax + "<br /><a href=`"https://www.COMPANYNAME.net`"style=`"text-decoration:none;color:#0079c1;`">www.COMPANYNAME.net</a><br /> Like us on <a href=`"https://www.facebook.com/COMPANYNAME`"style=`"text-decoration:none;color:#0079c1;`">Facebook! <img src=`"LOGOPATH`"> </a>", "<br /></div>" | Out-File $output_file}
    elseif($user.extensionattribute2 -eq "arextended"){
            "<div style=`"height:150px;width:650px;font-family:calibri,sans-serif;font-size:14px;`"><div style=><strong style=`"color:#0079c1`">" + $full_name + " " + $description + "</strong>" + " | ", $job_title + "<br />", "<strong style=`"color:#0079c1`">" + $comp + "</strong>" + " | " + $address  + " | " + $city + ", " + $state + " " + $zip + "<br />" + "O: " + $phone + " | M: " + $mobile + " | F: " + $fax + "<br /><a href=`"https://www.COMPANYNAME.net`"style=`"text-decoration:none;color:#0079c1;`">www.COMPANYNAME.net</a><br /> Like us on <a href=`"https://www.facebook.com/COMPANYNAME`"style=`"text-decoration:none;color:#0079c1;`">Facebook! <img src=`"LOGOPATH`"> </a>", "<br /></div>" | Out-File $output_file}
    elseif($user.extensionattribute2 -eq "kybasic"){
            "<div style=`"height:150px;width:650px;font-family:calibri,sans-serif;font-size:14px;`"><div style=><strong style=`"color:#0079c1`">" + $full_name + " " + $description + "</strong>" + " | ", $job_title + "<br />", "<strong style=`"color:#0079c1`">" + $comp + "</strong>" + " | " + "<a href=`"https://www.COMPANYNAME.net`"style=`"text-decoration:none;color:#0079c1;`">www.COMPANYNAME.net</a><br /> Like us on <a href=`"https://www.facebook.com/COMPANYNAME`"style=`"text-decoration:none;color:#0079c1;`">Facebook! <img src=`"LOGOPATH`"> </a>", "<br /></div>" | Out-File $output_file}
    elseif($user.extensionattribute2 -eq "kystandard"){
            "<div style=`"height:150px;width:650px;font-family:calibri,sans-serif;font-size:14px;`"><div style=><strong style=`"color:#0079c1`">" + $full_name + " " + $description + "</strong>" + " | ", $job_title + "<br />", "<strong style=`"color:#0079c1`">" + $comp + "</strong>" + " | " + $address  + " | " + $city + ", " + $state + " " + $zip + "<br />" + "O: " + $phone + " | F: " + $fax + "<br /><a href=`"https://www.COMPANYNAME.net`"style=`"text-decoration:none;color:#0079c1;`">www.COMPANYNAME.net</a><br /> Like us on <a href=`"https://www.facebook.com/COMPANYNAME`"style=`"text-decoration:none;color:#0079c1;`">Facebook! <img src=`"LOGOPATH`"> </a>", "<br /></div>" | Out-File $output_file}
    elseif($user.extensionattribute2 -eq "kyextended"){
            "<div style=`"height:150px;width:650px;font-family:calibri,sans-serif;font-size:14px;`"><div style=><strong style=`"color:#0079c1`">" + $full_name + " " + $description + "</strong>" + " | ", $job_title + "<br />", "<strong style=`"color:#0079c1`">" + $comp + "</strong>" + " | " + $address  + " | " + $city + ", " + $state + " " + $zip + "<br />" + "O: " + $phone + " | M: " + $mobile + " | F: " + $fax + "<br /><a href=`"https://www.COMPANYNAME.net`"style=`"text-decoration:none;color:#0079c1;`">www.COMPANYNAME.net</a><br /> Like us on <a href=`"https://www.facebook.com/COMPANYNAME`"style=`"text-decoration:none;color:#0079c1;`">Facebook! <img src=`"LOGOPATH`"> </a>", "<br /></div>" | Out-File $output_file}
    elseif($user.extensionattribute2 -eq "msbasic"){
            "<div style=`"height:150px;width:650px;font-family:calibri,sans-serif;font-size:14px;`"><div style=><strong style=`"color:#0079c1`">" + $full_name + " " + $description + "</strong>" + " | ", $job_title + "<br />", "<strong style=`"color:#0079c1`">" + $comp + "</strong>" + " | " + "<a href=`"https://www.COMPANYNAME.net`"style=`"text-decoration:none;color:#0079c1;`">www.COMPANYNAME.net</a><br /> Like us on <a href=`"https://www.facebook.com/COMPANYNAME`"style=`"text-decoration:none;color:#0079c1;`">Facebook! <img src=`"LOGOPATH`"> </a>", "<br /></div>" | Out-File $output_file}
    elseif($user.extensionattribute2 -eq "msstandard"){
            "<div style=`"height:150px;width:650px;font-family:calibri,sans-serif;font-size:14px;`"><div style=><strong style=`"color:#0079c1`">" + $full_name + " " + $description + "</strong>" + " | ", $job_title + "<br />", "<strong style=`"color:#0079c1`">" + $comp + "</strong>" + " | " + $address  + " | " + $city + ", " + $state + " " + $zip + "<br />" + "O: " + $phone + " | F: " + $fax + "<br /><a href=`"https://www.COMPANYNAME.net`"style=`"text-decoration:none;color:#0079c1;`">www.COMPANYNAME.net</a><br /> Like us on <a href=`"https://www.facebook.com/COMPANYNAME`"style=`"text-decoration:none;color:#0079c1;`">Facebook! <img src=`"LOGOPATH`"> </a>", "<br /></div>" | Out-File $output_file}
    elseif($user.extensionattribute2 -eq "msextended"){
            "<div style=`"height:150px;width:650px;font-family:calibri,sans-serif;font-size:14px;`"><div style=><strong style=`"color:#0079c1`">" + $full_name + " " + $description + "</strong>" + " | ", $job_title + "<br />", "<strong style=`"color:#0079c1`">" + $comp + "</strong>" + " | " + $address  + " | " + $city + ", " + $state + " " + $zip + "<br />" + "O: " + $phone + " | M: " + $mobile + " | F: " + $fax + "<br /><a href=`"https://www.COMPANYNAME.net`"style=`"text-decoration:none;color:#0079c1;`">www.COMPANYNAME.net</a><br /> Like us on <a href=`"https://www.facebook.com/COMPANYNAME`"style=`"text-decoration:none;color:#0079c1;`">Facebook! <img src=`"LOGOPATH`"> </a>", "<br /></div>" | Out-File $output_file}
    }