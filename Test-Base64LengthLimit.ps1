#requires -version 5
Function Test-Base64LengthLimit {
  Param(
    [Parameter(Mandatory=$true,
    ValueFromPipeline=$false,
    HelpMessage="Path of file to test.")]
    [ValidateNotNullOrEmpty()] # Specifies that the parameter value cannot be $null and cannot be an empty string "". 
    [ValidateScript({Test-Path -Path $_ -PathType Leaf})] # Specifies a script that is used to validate a parameter or variable value.
    [string]$FilePath
  )
  $Base64Txt = Get-Content -Path $FilePath -Encoding utf8 
  $Base64Txt = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($Base64Txt))
  if ($Base64Txt.length -gt 8192) {
    Write-Host "Warning!!!" -ForegroundColor Red
    Write-Host "After Base64 encoding, $FilePath is greater than 8192 characters. Length = $($Base64Txt.length)"
  } else {
      Write-Host "After Base64 encoding, $FilePath is less than 8192 characters. Length = $($Base64Txt.length)"
      Write-Host "Happy Terraforming!" -ForegroundColor Green
  }
}
