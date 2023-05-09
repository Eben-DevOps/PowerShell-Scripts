# This script creates and licenses a new Microsoft 365 user

#Connect Msol service using admin credentials
Connect-MsolService

Write-Host "Please follow through the prompts to create a new user"

$Create_User = Read-Host -Prompt "Please enter 'Yes' to Create a user and 'No' to Cancel"

if ($Create_User -eq 'Yes') {

    $FirstName = Read-Host -prompt "Please enter the Firstname of the User"
    $LastName = Read-Host -prompt "Please enter the Lastname of the User"
    $DisplayName = Read-Host -prompt "Please enter the DisplayName of the User"
    $UPN = Read-Host -prompt "Please enter the desired UPN of the user"
    $Password = Read-Host -prompt "Please enter the password of the user" -AsSecureString
    $location = Read-Host -prompt "Please enter the Usage Location of the User in two letters"
    
    Write-Host "Apply License to this user"

    $license = Read-Host -Prompt "Please enter 'Yes' to apply a License to this user and 'No' to Cancel"

    if ($license -eq 'Yes'){

        $LicenseSKU = Get-MsolAccountSku | Out-GridView -Title 'Select a license plan to assign to user' -OutputMode Single | Select-Object -ExpandProperty AccountSkuId
        Write-Host "License successfully applied"
    }

    New-MsolUser -DisplayName $DisplayName -FirstName $FirstName -LastName $LastName -UserPrincipalName $UPN -UsageLocation $location -Password $Password -ForceChangePassword:$true -LicenseAssignment $LicenseSKU

    Write-Host "User creation Success"

    Write-Host "Give this user a role assignment"
    $RoleAssignment = Read-Host -Prompt "Please Select 'Yes' to give user an Admin Role or 'No' to arbort"
    if ($RoleAssignment -eq 'Yes'){

    $Role = Get-MsolRole | Out-GridView -Title 'Select a Role for this User' -OutputMode Single | Select-Object -ExpandProperty Name
    Add-MsolRoleMember -RoleName $Role -RoleMemberEmailAddress $UPN
    
    Write-Host "Role added successfully"

    }
    else {
    if ($RoleAssignment -eq 'No'){
    Write-Host "No roles assigned to user"}
    }
}

else {
    if ($Create_User -eq 'NO'){
        Write-Host "Operation cancelled"
        exit
    }
} 
