Function New-DigiCertDnsCname {
    #region - Comment Based Help
    <#
    .SYNOPSIS
    Creates CNAMEs record for DigiCert DCV verification in Azure DNS. 
    
    .DESCRIPTION
    Creates CNAMEs record for DigiCert DCV verification in Azure DNS. 
    
    .PARAMETER Token
    Token from DigiCert Portal. 
    
    .PARAMETER Hostname
    Hostname(s) portion of the Fully Qualified Domain Name (FQDN) used in the Common name field submitted to DigiCert. 

    .PARAMETER Zonename
    DNS Zone portion of the Fully Qualified Domain Name (FQDN) used in the Common name field submitted to DigiCert. 

    .PARAMETER ResourceGroupName
    Name of Azure Resource Group containing the DNS zone. Defaults to DNS.

    .PARAMETER Subscription
    Azure Subscription ID. Defaults to RamQuest Prod, d9c6725b-5bea-4f2a-a691-b82747c1add5.

    .INPUTS
    None
    
    .OUTPUTS
    None
    
    .NOTES
    Author: Andrew Zbikowski <azbikowski@ramquest.com>
    
    .EXAMPLE
    New-DigiCertAzDNSCNAME.ps1 -Token c3mmkhvmq8p8j50dvynz0rrf6tfn15h3 -Hostname somename -Zonename example.com 
    #>
    #endregion - Comment Based Help

    #region - Parameters   
    # Advanced Parameters: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-6
    # Be sure to edit this to meet the validatations required as the allows and validate lines below may conflict with each other.  
    Param (
        [Parameter(Mandatory=$true,
        ValueFromPipeline=$false,
        HelpMessage="Enter a help message for this parameter.")]
        [ValidateNotNullOrEmpty()] # Specifies that the parameter value cannot be $null and cannot be an empty string "". 
        [string]$Token,
        # Don't forget a comma between parameters. 
        [Parameter(Mandatory=$true,
        ValueFromPipeline=$false,
        HelpMessage="Enter hostname used in the Common name field submitted to DigiCert.")]
        [ValidateNotNullOrEmpty()]
        [string[]]$Hostname,
        # Don't forget a comma between parameters. 
        [Parameter(Mandatory=$true,
        ValueFromPipeline=$false,
        HelpMessage="Enter DNZ zone name used in the Common name field submitted to DigiCert.")]
        [ValidateNotNullOrEmpty()]
        [string]$Zonename,
        # Don't forget a comma between parameters. 
        [Parameter(Mandatory=$false,
        ValueFromPipeline=$false,
        HelpMessage="Enter the name of the Azure Resource Group.")]
        [ValidateNotNullOrEmpty()]
        [string]$ResourceGroupName="DNS",
        # Don't forget a comma between parameters. 
        [Parameter(Mandatory=$false,
        ValueFromPipeline=$false,
        HelpMessage="Enter the Azure Subscription ID")]
        [ValidatePattern("^[A-Fa-f0-9]{8,8}-[A-Fa-f0-9]{4,4}-[A-Fa-f0-9]{4,4}-[A-Fa-f0-9]{4,4}-[A-Fa-f0-9]{12,12}$")]        
        [string]$Subscription="d9c6725b-5bea-4f2a-a691-b82747c1add5"
    )
    #endregion - Parameters
    
    # Set AD Subscription
    Set-AzContext -Subscription $Subscription
    $Zone = Get-AzDnsZone -ResourceGroupName $ResourceGroupName -Name $Zonename
    if (!$Zone) {
        Write-Host "Error: DNS zone $Zonename was not found." -ForegroundColor Red
        Return
    }
    $Ttl = 3600
    $Alias = "dcv.digicert.com"
    
    ForEach ($HName in $Hostname) {
        $RecordName = "$Token.$HName"    
        New-AzDnsRecordSet -Name $RecordName `
            -RecordType CNAME `
            -ZoneName $Zonename `
            -ResourceGroupName $ResourceGroupName `
            -Ttl $Ttl `
            -DnsRecords (New-AzDnsRecordConfig -Cname $Alias)
    }
}

<#

Notes: 

Going to improve this a bit to use CNAME and TXT. 

Also going add more flexiblity with DNS providers so I can quickly update Azure, AWS, possibly CloudFlare. (the three providers I use at the moment.) 

And output plain text that can be added to DNS I don't support in this. 

DNS TXT Entry
TXT entry on either subdomain.example.com or
_dnsauth.subdomain.example.com
Random Value
fblphpfzxjghkrrykzpklma5odw4fjpv


#>