Function Get-GeekJoke {
    Write-Host "Your joke: " -NoNewline -ForegroundColor DarkCyan
    (Invoke-RestMethod -Uri 'https://geek-jokes.sameerkumar.website/api' -Method Get)
}