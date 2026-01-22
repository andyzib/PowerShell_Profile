Function Get-1Password {
    Param (
        [Parameter(Mandatory=$false,
        ValueFromPipeline=$false,
        Position=0,
        HelpMessage="Name of 1Password Vault.")]
        [alias("VaultName")]
        [ValidateNotNullOrEmpty()] # Specifies that the parameter value cannot be $null and cannot be an empty string "". 
        [string]$Vault="Employee",
        # Don't forget a comma between parameters. 
        [Parameter(Mandatory=$true,
        ValueFromPipeline=$false,
        Position=1,
        HelpMessage="Name of 1Password Secret.")]
        [alias("SecretName")]
        [ValidateNotNullOrEmpty()]
        [string]$Secret,
        # Don't forget a comma between parameters. 
        [Parameter(Mandatory=$false,
        ValueFromPipeline=$false,
        Position=2,
        HelpMessage="Value of 1Password Secret.")]
        [alias("ValueName")]    
        [ValidateNotNullOrEmpty()]
        [string]$Value="Password"
    )
    $opcli = "C:\ProgramData\chocolatey\bin\op.exe"

    $URI = "op://$Vault/$Secret/$Value"

    $Result = & $opcli read $URI
    Return $Result
}