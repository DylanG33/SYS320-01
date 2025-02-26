function ApacheLogs1 {
    $LogFolder = "C:\xampp\apache\logs"  
    $LogExtension = ".log"
    
    $Logs = Get-ChildItem -Path $LogFolder | Where-Object {$_.Name -match $LogExtension} | Select-Object -ExpandProperty FullName
    $LogContent = Get-Content $Logs | Select-Object -Last 10
    return $LogContent
}
