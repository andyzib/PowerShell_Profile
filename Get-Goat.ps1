Function Get-Goat {
    $URI = "http://www.heldeus.nl/goat/GoatFarming.html"
    $HTML = Invoke-WebRequest -Uri $URI
    Write-Host "Why goat farming is better than IT: " -NoNewline -ForegroundColor DarkCyan
    ($HTML.ParsedHtml.getElementsByTagName("p") | Where { $_.className -eq "goat" } ).innerText | Get-Random
    Write-Host ""
} 