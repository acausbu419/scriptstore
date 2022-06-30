$users = get-aduser -Filter *

foreach($user in $users){
Function Test-ADAuthentication {
    param($user,$password)
    $null -ne (new-object directoryservices.directoryentry "",$user,$password).psbase.name
}

Test-ADAuthentication "$($user.samaccountname)" "<#Password To Test#>"
}