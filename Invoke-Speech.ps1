#requires -version 5
#Requires -PSEdition Desktop

Function Invoke-Speech {
	Param (
		[string]$Message
	)
	Add-Type -AssemblyName System.speech
	([System.Speech.Synthesis.SpeechSynthesizer]::New()).Speak($Message)
}
