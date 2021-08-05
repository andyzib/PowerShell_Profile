<#
    Creates an alias for NotepadPlusPlus. 
    Or BBEdit on MacOS. (Install BBEdit CLI, /usr/local/bin/bbedit)
    Or on anything else... 
#>
# "C:\Program Files\Notepad++\notepad++.exe"

# PowerShell Core

if ( ($PSVersionTable.PSVersion.Major -eq 5) -or ($IsWindows) ) { # Windows PowerShell 5 only runs on Windows.
    if ( Test-Path -Path $(Join-Path -Path $env:ProgramFiles -ChildPath 'Notepad++\notepad++.exe') ) {
        new-item alias:npp -value "$(Join-Path -Path $env:ProgramFiles -ChildPath 'Notepad++\notepad++.exe')"
    } elseif ( Test-Path -Path $(Join-Path -Path ${env:ProgramFiles(x86)} -ChildPath 'Notepad++\notepad++.exe') ) {
        new-item alias:npp -value "$(Join-Path -Path ${env:ProgramFiles(x86)} -ChildPath 'Notepad++\notepad++.exe')"
    } else {
        new-item alias:npp -value "$env:SYSTEMROOT\System32\notepad.exe"
    }
} else {
    if ($IsMacOS) {
        if ( Test-Path -Path "/usr/local/bin/bbedit" ) {
            new-item alias:npp -value "/usr/local/bin/bbedit"
        } else {
            # Write-Host "BBEdit Command Line Tools not installed. See https://www.barebones.com/products/bbedit/benefitscommand.html"
            new-item alias:npp -value "/usr/bin/nano"
        }
    } elseif ($IsLinux) {
        new-item alias:npp -value "/usr/bin/nano"
    }
} 
Write-Host ""
