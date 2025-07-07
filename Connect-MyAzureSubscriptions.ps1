<#
Function for PowerShell profile to connect all your Azure subscriptions. 
Create an AzureTenants.json file in your Documents\PowerShell folder. Example JSON:
    Name - Friendly name for this script to use. Whatever you want. 
    TenantID - AzureAD TenantID to login to.
    Username - Username for the Tenant.
    PrimaryDomain - AzureAD domain.
    Default_Subscription - Default subscription to change to once logged in. 
    Azure_PowerShell - (true|false) Run Connect-AzAccount for this tenant.
    Azure_CLI - (true|false) Run az login for this tenant.
    Profile_Active - (true|false) Set to false and the script won't display this subscription.
[
  {
    "Name": "Contoso Example",
    "TenantID": "12345678-1234-1234-1234-1234567890AB",
    "Username": "yourself@contoso.com",
    "PrimaryDomain": "contosoexample.onmicrosoft.com",
    "Default_Subscription": "12345678-1234-1234-1234-1234567890AB",
    "Azure_PowerShell": true,
    "Azure_CLI": false,
    "Profile_Active": true
  },
    {
    "Name": "Fabrikam Example",
    "TenantID": "12345678-1234-1234-1234-1234567890AB",
    "Username": "yourself@fabrikam.com",
    "PrimaryDomain": "fabrikam.onmicrosoft.com",
    "Default_Subscription": "",
    "Azure_PowerShell": true,
    "Azure_CLI": false,
    "Profile_Active": true
  }
]
#>
Function Connect-MyAzureSubscriptions {
    if (Get-Module -ListAvailable -Name Microsoft.PowerShell.ConsoleGuiTools) {
        Import-Module Microsoft.PowerShell.ConsoleGuiTools
        $ConsoleGridView = $true
    } else {
        $ConsoleGridView = $false
    }

    $PowerShellFolder = Join-Path -Path $([environment]::getfolderpath("mydocuments")) -ChildPath "PowerShell"
    $AzureTenantsJSON = Join-Path -Path $PowerShellFolder -ChildPath AzureTenants.json
    $AzureTenants = Get-Content -Path $AzureTenantsJSON | ConvertFrom-json
    
    $Title = "Select Azure Tenants to Connect"
    if ($ConsoleGridView) {
        $Selection = $AzureTenants | Where-Object -Property Profile_Active -eq $true | Out-ConsoleGridView -Title $Title -OutputMode Multiple
    } else {
        $Selection = $AzureTenants | Where-Object -Property Profile_Active -eq $true | Out-GridView -Title $Title -OutputMode Multiple
    }

    ForEach ($Tenant in $Selection) {
        Write-Host "Connecting to $($Tenant.Name)"
        if ($Tenant.Azure_PowerShell) {
            Connect-AzAccount -AccountId $Tenant.Username -Tenant $Tenant.TenantId 
            if ( -Not ( ($null -eq $Tenant.Default_Subscription) -or ("" -eq $Tenant.Default_Subscription) ) ) {
                Set-AzContext -Subscription $Tenant.Default_Subscription
            } 
        }
        if ($Tenant.Azure_CLI) {
            & az login --tenant $Tenant.TenantId
            if ( -Not ( ($null -eq $Tenant.Default_Subscription) -or ("" -eq $Tenant.Default_Subscription) ) ) {
                & az account set --subscription $Tenant.Default_Subscription
            }
        }
    }
}
Set-Alias -Name "conazsub" -Value Connect-MyAzureSubscriptions
Set-Alias -Name "conazsubs" -Value Connect-MyAzureSubscriptions
Set-Alias -Name "conaz" -Value Connect-MyAzureSubscriptions
