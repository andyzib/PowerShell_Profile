Function Get-CatFact {
    (Invoke-RestMethod -Uri 'https://catfact.ninja/fact').fact
}