function Get-Excuse {
    $Uri = 'http://pages.cs.wisc.edu/~ballard/bofh/excuses'
    $result = Invoke-WebRequest -Uri $Uri
    # Formating got weird...?
    $excuses = ($result.RawContent.Split([Environment]::NewLine)[8]).Split("`n")
    $excuse = Get-Random -InputObject $excuses
    Write-Host "Your excuse: " -NoNewline -ForegroundColor DarkCyan
    Write-Host $excuse
}
