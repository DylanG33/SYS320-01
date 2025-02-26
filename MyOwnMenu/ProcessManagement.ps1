function Start-ChromeIfNotRunning {
    $chromeProcess = Get-Process chrome -ErrorAction SilentlyContinue
    if (-not $chromeProcess) {
        Start-Process chrome "https://www.champlain.edu"
        Write-Host "Chrome started and navigated to champlain.edu"
    } else {
        Write-Host "Chrome is already running"
    }
}
