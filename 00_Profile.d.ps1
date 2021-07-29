#region Profile.d
<#
Reduce the size of the PowerShell profile folder by dot sourcing customizations. 
1. Add this code region to your PowerShell profile. 
2. Create a directory named Profile.d in your PowerShell directory. 
3. Save your custom profile scripts to the Profile.d folder. 
#>
$ProfileD = Join-Path -Path $(Split-Path -Path $PROFILE) -ChildPath "Profile.d"
if (Test-Path -Path $ProfileD -PathType Container) {
	Write-Host "Dot Sourcing $ProfileD..." -ForegroundColor Cyan
	Get-ChildItem -Path $ProfileD -Filter "*.ps1" | ForEach-Object {
		Write-Host "Sourcing $($_.Name)."
		. $_.FullName # Dot Source each file in the Profile.d folder. 
	}
	Write-Host "Complete!" -ForegroundColor Green
}
#endregion Profile.d