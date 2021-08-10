Function Get-ADUserPWExpireDate {
#region - Comment Based Help
<#
  .SYNOPSIS
  Gets the password expiration date for an AD User. 
  
  .DESCRIPTION
  Gets the password expiration date for an AD User. 
  
  .PARAMETER Identity
  An AD account object, specified with one of the following values: Distinguished Name, GUID, Security Identifier, Sam Account Name. 
  
  .EXAMPLE
  Get-ADUserPWExpireDate -Identity azbikowski
#>
#endregion
  Param(
      [Parameter(Mandatory=$true,
      Position=0)]
      [alias("Username","DistinguishedName","SamAccountName","UserPrincipalName")]
      [string]$Identity
  )
  Get-ADUser -Identity $Identity –Properties "DisplayName", "msDS-UserPasswordExpiryTimeComputed" `
    | Select-Object -Property "Displayname",@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}
}
Set-Alias -Name "Get-ADPWExpireDate" -Value Get-ADUserPWExpireDate 