# Dot-source the required script files
. .\ApacheLogs1.ps1
. $PSScriptRoot\Event-Logs2.ps1
. .\ProcessManagement.ps1

function Show-Menu {
    Clear-Host
    Write-Host "           MENU          "
    Write-Host "1: Display last 10 apache logs"
    Write-Host "2: Display last 10 failed logins for all users"
    Write-Host "3: Display at risk users"
    Write-Host "4: Start Chrome and navigate to champlain.edu"
    Write-Host "5: Exit"
}

do {
    Show-Menu
    $choice = Read-Host "Enter your choice"

    switch ($choice) {
        '1' {
            Write-Host "Displaying last 10 apache logs:"
            ApacheLogs1 | Select-Object -First 10
            pause
        }
        '2' {
            Write-Host "Displaying last 10 failed logins for all users:"
            FailedLogins -days 90 | Select-Object -First 10
            pause
        }
        '3' {
            Write-Host "Displaying at risk users:"
            $days = Read-Host "Enter the number of days to check"
            $failedLogins = FailedLogins $days
            $atRiskUsers = $failedLogins | Group-Object User | Where-Object { $_.Count -gt 10 } | Select-Object Name, Count
            $atRiskUsers | Format-Table
            pause
        }
        '4' {
            $chromeProcess = Get-Process chrome -ErrorAction SilentlyContinue
            if (-not $chromeProcess) {
                Start-Process chrome "https://www.champlain.edu"
                Write-Host "Chrome started and navigated to champlain.edu"
            } else {
                Write-Host "Chrome is already running"
            }
            pause
        }
        '5' {
            Write-Host "Exiting..."
            return
        }
        default {
            Write-Host "Invalid choice. Please enter a number between 1 and 5."
            pause
        }
    }
} while ($true)
