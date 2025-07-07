Function Get-DadJoke {
	Invoke-RestMethod -Uri https://icanhazdadjoke.com/ -Headers @{accept="text/plain"}
}
