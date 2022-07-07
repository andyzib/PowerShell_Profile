<#

Created by: Andrew Zbikowski <andrew@itouthouse.com>

This adds Swtich-AzSubscription (Alias: chazsub) to your PowerShell Profile. 
If you have the Microsoft.PowerShell.ConsoleGuiTools module installed (Required for Non-Windows, Highly Recommended for Windows)
available Azure Subsriptions will be presented with Out-ConsoleGridView. Otherwise Out-GridView is used. 
I really should fix this to fail gracefully on non-Windows platforms. 

#>
Function Switch-AzSubscription {

    if (Get-Module -ListAvailable -Name Microsoft.PowerShell.ConsoleGuiTools) {
        Import-Module Microsoft.PowerShell.ConsoleGuiTools
        $ConsoleGridView = $true
    } else {
        $ConsoleGridView = $false
    }
    
    #region Verify Connection to Azure.
    $AzContext = Get-AzContext
    if ($null -eq $AzContext ) {
        Connect-AzAccount
    } else {
        Write-Host "Already logged into Azure as $($AzContext.account)." -ForegroundColor Green
    }
    $AzContext = Get-AzContext
    if ($null -eq $AzContext ) {
        Write-Host "Error: Unable to connect to Azure." -ForegroundColor Red
        Break    
    }
    Write-Host "Current Subscription: $($AzContext.Subscription.Name)"

    if ($ConsoleGridView) {
        $selection = Get-AzSubscription | Select-Object Name,Id,State | Out-ConsoleGridView -Title "Select Azure Subscription" -OutputMode Single
    } else {
        $selection = Get-AzSubscription | Select-Object Name,Id,State | Out-GridView -Title "Select Azure Subscription" -OutputMode Single
    }
    
    if ( $null -eq $selection) {
        Write-Host "Cancel was clicked."
        Break
    } else {
        Set-AzContext $selection.id
        az account set --subscription "$($selection.id)"
    }
}
Set-Alias -Name "cdazsub" -Value Switch-AzSubscription
Set-Alias -Name "chazsub" -Value Switch-AzSubscription