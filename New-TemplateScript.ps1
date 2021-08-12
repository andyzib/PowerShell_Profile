<#
Got tired of copying my template file. 
#>
Function New-TemplateScript {
	Param(
		[Parameter(Mandatory=$true,
		Position=0)]
		[alias("ScriptName","FileName")]
		[string]$NewScriptName,
		[Parameter(Mandatory=$false,
		Position=1)]
		[string]$TemplateURI="https://raw.githubusercontent.com/andyzib/Templates/master/PowerShell_ScriptTemplate.ps1",		
	)	  
	# Strip illegal file name characters with a RegEx.
	# https://gallery.technet.microsoft.com/scriptcenter/Remove-Invalid-Characters-39fa17b1
	$NewScriptName = [RegEx]::Replace($NewScriptName, "[{0}]" -f ([RegEx]::Escape([String][System.IO.Path]::GetInvalidFileNameChars())), '')
	Invoke-WebRequest -Uri $TemplateURI -OutFile $NewScriptName
}