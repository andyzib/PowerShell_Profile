Function Get-JoelLeeFact {
    $fact = "Did you know, $($(Invoke-RestMethod -Uri 'https://api.chucknorris.io/jokes/random' -Method Get | Select-Object -ExpandProperty Value) -replace "Chuck","Joel" -replace "Norris", "Lee")"
    #Write-Host $fact
    $fact
}