function Get-Excuse {
    Write-Host "Your excuse: " -NoNewline -ForegroundColor DarkCyan
    (Invoke-WebRequest http://pages.cs.wisc.edu/~ballard/bofh/excuses -OutVariable excuses).content.split([Environment]::NewLine)[(get-random $excuses.content.split([Environment]::NewLine).count)]
}
