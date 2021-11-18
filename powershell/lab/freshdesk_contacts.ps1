#freshdesk_contact.ps1
#Adam Ausburn

#This script will be used to consolidate contacts from a few different
#sources, and import them into Freshdesk, improving the quality of the
#contacts within the application.
#This is only intended as a baseline import, not an ongoing sync tool.

$verizon = import-csv C:\Users\acaus\OneDrive\Documents\scriptstore\powershell\lab\verizon.csv

$verizon | Select-Object number,username