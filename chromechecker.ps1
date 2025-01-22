$processName = "chrome"
$url = "https://www.champlain.edu"

if (!(Get-Process $processName -ErrorAction SilentlyContinue)) {
    Start-Process "C:\Program Files\Google\Chrome\Application\chrome.exe" -ArgumentList $url
} else {
    Stop-Process -Name $processName -Force
}
