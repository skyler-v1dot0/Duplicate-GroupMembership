#This script duplicates group membership from an existing setup user to a 
#user that needs the same access. It does not filter out any of the default
#groups the user is added to by the NOC so a few errors may arise on those
#groups but stderr is redirected to null so they won't show on the console


$currentuser = Read-Host "Enter samaccount name for the current user with access: " 
$newuser = Read-Host "Enter samaccount name for the new user needing access: " 

#Get group membership from current user and isolate the distinguished name
$groups = Get-ADPrincipalGroupMembership -Identity (Get-ADUser -Filter "Name -like '$currentuser'") | Select-Object -ExpandProperty distinguishedname 

#Add new user to groups from current user redirect errors to null
#the below method doesn't work because -Identity is not getting its info from the pipe so the wrong object type is presented
#Add-ADGroupMember -Identity (Get-ADGroup $groups) -Members $newuser -WhatIf
echo $groups | Add-ADGroupMember -Members $newuser 2> $null 
Write-Host "Press any key to continue: " -ForegroundColor Green -NoNewline; Read-Host
