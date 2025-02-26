. (Join-Path $PSScriptRoot Users.ps1)
. (Join-Path $PSScriptRoot Event-Logs.ps1)
. (Join-Path $PSScriptRoot String-Helper.ps1)

clear

$Prompt = "`n"
$Prompt += "Please choose your operation:`n"
$Prompt += "1 - List Enabled Users`n"
$Prompt += "2 - List Disabled Users`n"
$Prompt += "3 - Create a User`n"
$Prompt += "4 - Remove a User`n"
$Prompt += "5 - Enable a User`n"
$Prompt += "6 - Disable a User`n"
$Prompt += "7 - Get Log-In Logs`n"
$Prompt += "8 - Get Failed Log-In Logs`n"
$Prompt += "9 - List at Risk Users`n"
$Prompt += "10 - Exit`n"

$operation = $true

while($operation){
    Write-Host $Prompt | Out-String
    $choice = Read-Host 

    switch ($choice) {
        '10' {
            Write-Host "Goodbye" | Out-String
            exit
            $operation = $false 
        }
        '1' {
            $enabledUsers = getEnabledUsers
            Write-Host ($enabledUsers | Format-Table | Out-String)
        }
        '2' {
            $notEnabledUsers = getNotEnabledUsers
            Write-Host ($notEnabledUsers | Format-Table | Out-String)
        }
        '3' {
            $name = Read-Host -Prompt "Please enter the username for the new user"
            if (checkUser $name) {
                Write-Host "User already exists. Please choose a different username." | Out-String
                continue
            }
            $password = Read-Host -AsSecureString -Prompt "Please enter the password for the new user"
            $passwordString = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
            if (-not (checkPassword $passwordString)) {
                Write-Host "Password does not meet the requirements. It must be at least 6 characters long and contain at least 1 special character, 1 number, and 1 letter." | Out-String
                continue
            }
            createAUser $name $password
            Write-Host "User: $name is created." | Out-String
        }
        '4' {
            $name = Read-Host -Prompt "Please enter the username for the user to be removed"
            if (-not (checkUser $name)) {
                Write-Host "User does not exist." | Out-String
                continue
            }
            removeAUser $name
            Write-Host "User: $name Removed." | Out-String
        }
        '5' {
            $name = Read-Host -Prompt "Please enter the username for the user to be enabled"
            if (-not (checkUser $name)) {
                Write-Host "User does not exist." | Out-String
                continue
            }
            enableAUser $name
            Write-Host "User: $name Enabled." | Out-String
        }
        '6' {
            $name = Read-Host -Prompt "Please enter the username for the user to be disabled"
            if (-not (checkUser $name)) {
                Write-Host "User does not exist." | Out-String
                continue
            }
            disableAUser $name
            Write-Host "User: $name Disabled." | Out-String
        }
        '7' {
            $name = Read-Host -Prompt "Please enter the username for the user logs"
            if (-not (checkUser $name)) {
                Write-Host "User does not exist." | Out-String
                continue
            }
            $days = Read-Host -Prompt "Please enter the number of days to check"
            $userLogins = getLogInAndOffs $days
            Write-Host ($userLogins | Where-Object { $_.User -ilike "*$name"} | Format-Table | Out-String)
        }
        '8' {
            $name = Read-Host -Prompt "Please enter the username for the user's failed login logs"
            if (-not (checkUser $name)) {
                Write-Host "User does not exist." | Out-String
                continue
            }
            $days = Read-Host -Prompt "Please enter the number of days to check"
            $userLogins = getFailedLogins $days
            Write-Host ($userLogins | Where-Object { $_.User -ilike "*$name"} | Format-Table | Out-String)
        }
        '9' {
            $days = Read-Host -Prompt "Please enter the number of days to check"
            $failedLogins = getFailedLogins $days
            $atRiskUsers = $failedLogins | Group-Object User | Where-Object { $_.Count -gt 10 } | Select-Object Name, Count
            Write-Host "Users with more than 10 failed logins in the last $days days:" | Out-String
            Write-Host ($atRiskUsers | Format-Table | Out-String)
        }
        default {
            Write-Host "Invalid choice. Please enter a number between 1 and 10." | Out-String
        }
    }
}
