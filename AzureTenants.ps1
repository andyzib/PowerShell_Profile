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
            # Beginning with Azure CLI version 2.61.0, if you have access to multiple subscriptions, you're prompted to select an Azure subscription at the time of login.
            # Turn off az subscription selector. 
            # https://learn.microsoft.com/en-us/cli/azure/authenticate-azure-cli-interactively?view=azure-cli-latest&source=recommendations
            & az config set core.login_experience_v2=off
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

<#

Created by: Andrew Zbikowski <andrew@itouthouse.com>

This adds Switch-AzSubscription (Alias: chazsub) to your PowerShell Profile. 
If you have the Microsoft.PowerShell.ConsoleGuiTools module installed (Required for Non-Windows, Highly Recommended for Windows)
available Azure Subscriptions will be presented with Out-ConsoleGridView. Otherwise Out-GridView is used. 
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
        & az account set --subscription "$($selection.id)"
    }
}
Set-Alias -Name "cdazsub" -Value Switch-AzSubscription
Set-Alias -Name "chazsub" -Value Switch-AzSubscription

Function Initialize-AzureTenantsJSON {
    $PowerShellFolder = Join-Path -Path $([environment]::getfolderpath("mydocuments")) -ChildPath "PowerShell"
    if ( -Not (Test-Path -Path $PowerShellFolder) ) {
        New-Item -Path $PowerShellFolder -ItemType Directory
    }
    $AzureTenantsJSON = Join-Path -Path $PowerShellFolder -ChildPath AzureTenants.json
    if ( Test-Path -Path $AzureTenantsJSON ) {
        Write-Host "AzureTenants.json already exists at $AzureTenantsJSON" -ForegroundColor Yellow
    } else {
        $ExampleJSON = @'
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
'@
        $ExampleJSON | Out-File -FilePath $AzureTenantsJSON -Encoding UTF8
        Write-Host "Created example AzureTenants.json at $AzureTenantsJSON" -ForegroundColor Green
    }
}
Create-AzureTenantsJSON

# Console Grid View Module Install
if ( -Not (Get-Module -ListAvailable -Name Microsoft.PowerShell.ConsoleGuiTools) ) {
        Install-Module Microsoft.PowerShell.ConsoleGuiTools -Scope CurrentUser
}

