Function Confirm-WillAzureMakeYouAngryToday {
    Write-Host "Q: Will Azure make you angry today? " -ForegroundColor Cyan
    $EightBall = @(
        "It is certain.",
        "It is decidedly so.",
        "Without a doubt.",
        "Yes, definitely.",
        "You may rely on it.",
        "As I see it, yes.",
        "Most likely.",
        "Outlook good.",
        "Yes.",
        "All signs point to yes."
    )
    $day = get-date -Format dddd
    if ( $day.substring($day.length - 1, 1) -eq "y" ) {
        Write-Host "A: $(Get-Random -InputObject $EightBall)" -ForegroundColor Green
    } else {
        Write-Host "Hahaha. This will never happen."
    }
}