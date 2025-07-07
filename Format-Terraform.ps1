Function Format-Terraform {
    <#
    .SYNOPSIS
    Runs terraform fmt on the current directory and subdirectories.

    .DESCRIPTION
    Runs terraform fmt on the current directory and subdirectories.

    .PARAMETER Path
    Path to the directory containing the Terraform files. Defaults to the current directory.

    .PARAMETER Recurse
    Switch parameter. If specified, runs terraform fmt recursively on all subdirectories.

    .EXAMPLE
    Format-Terraform -Path C:\Code\Terraform -Recurse
    #>

    Param (
    [Parameter(Mandatory=$false,
    ValueFromPipeline=$true,
    Position=0,
    HelpMessage="Path containing Terraform files.")]        
    [ValidateNotNullOrEmpty()] # Specifies that the parameter value cannot be $null and cannot be an empty string "".         
    [string]$Path=$pwd.Path,
    # Don't forget a comma between parameters. 
    [Parameter(Mandatory=$false,
    ValueFromPipeline=$true,
    Position=1,
    HelpMessage="Recurse.")]    
    [switch]$Recurse
    )

    if ( Test-Path -Path $Path -PathType Container ) {
        $TerraformDirectories = Get-ChildItem -Path $Path -Attributes Directory -Recurse:$Recurse | Where-Object -FilterScript { $_.FullName -notlike "*.terraform*" }
		Write-Host "Formatting Terraform files in $Path..."
            Start-Process terraform -ArgumentList "fmt" -WorkingDirectory $Path -WindowStyle Hidden
        ForEach ($TFDir in $TerraformDirectories) {
			Write-Host "Formatting Terraform files in $($TFDir.FullName)..."
            Start-Process terraform -ArgumentList "fmt" -WorkingDirectory $TFDir.FullName -WindowStyle Hidden
        }
        Write-Host "Terraform files formatted successfully." -ForegroundColor Green
    } else {
        Write-Host "The specified path does not exist: $Path" -ForegroundColor Red
    }
}
