<#
Add this to...
Windows PowerShell 5: Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
PowerShell Core 6+: Documents\PowerShell\Microsoft.PowerShell_profile.ps1
Have not tested on non-Windows platforms or Azure Cloud Shell. 
#>
Function Switch-AzSubscription {
    [CmdletBinding()]
    
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
    $selection = Get-AzSubscription | Select-Object Name,Id,State | Out-GridView -Title "Select Azure Subscription" -OutputMode Single
    if ( $null -eq $selection) {
        Write-Host "Cancel was clicked."
        Break
    } else {
        Set-AzContext $selection.id
    }
}
Set-Alias -Name "cdazsub" -Value Switch-AzSubscription
Set-Alias -Name "chazsub" -Value Switch-AzSubscription