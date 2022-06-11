$users = get-aduser -Filter *

foreach($user in $users){
Function Test-ADAuthentication {
    param($user,$password)
    (new-object directoryservices.directoryentry "",$user,$password).psbase.name -ne $null
}

Test-ADAuthentication "$($user.samaccountname)" "Password1"
}