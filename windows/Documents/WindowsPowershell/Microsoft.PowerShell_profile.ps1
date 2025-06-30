##################################
#           MODULES              #
##################################

# Fish-like predictions
Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -EditMode Emacs

Invoke-Expression (&starship init powershell)

##################################
#           WSL COMMANDS         #
##################################

# Thanks to https://devblogs.microsoft.com/commandline/integrate-linux-commands-into-windows-with-powershell-and-the-windows-subsystem-for-linux/

# The commands to import.
$commands = "awk", "emacs", "grep", "head", "less", "man", "sed", "seq", "ssh", "tail", "wc", "rg", "fdfind"

# Register a function for each command.
$commands | ForEach-Object { Invoke-Expression @"
Remove-Item Alias:$_ -Force -ErrorAction ignore
function global:$_() {
    for (`$i = 0; `$i -lt `$args.Count; `$i++) {
        # If a path is absolute with a qualifier (e.g. C:), run it through wslpath to map it to the appropriate mount point.
        if (Split-Path `$args[`$i] -IsAbsolute -ErrorAction Ignore) {
            `$args[`$i] = Format-WslArgument (wsl.exe wslpath (`$args[`$i] -replace "\\", "/"))
        # If a path is relative, the current working directory will be translated to an appropriate mount point, so just format it.
        } elseif (Test-Path `$args[`$i] -ErrorAction Ignore) {
            `$args[`$i] = Format-WslArgument (`$args[`$i] -replace "\\", "/")
        }
    }

    if (`$input.MoveNext()) {
        `$input.Reset()
        `$input | wsl.exe $_ (`$args -split ' ')
    } else {
        wsl.exe $_ (`$args -split ' ')
    }
}
"@
}

##################################
#           ALIASES              #
##################################

Set-Alias -Name c -Value Clear-Host
Set-Alias -Name fd -Value fdfind

Set-Alias -Name g -Value git
Set-Alias -Name v -Value nvim

function gg {
    git status
}

function q {
    exit
}

function .. {
    cd ..
}

function ... {
    cd ..\..
}

##################################
#          UTILITIES             #
##################################

function daysbetween([string]$startDate, [string]$endDate) {
  $ts = New-TimeSpan -Start $startDate -End $endDate
  Write-Output $ts.Days
}

function nugadd([string]$namespace, [string]$package, [string]$version) {
  nuget add .\$package\bin\Debug\$namespace.$package.$version.nupkg -source $HOME\nuggets
}

function nugaddr([string]$namespace, [string]$package, [string]$version) {
  nuget add .\$package\bin\Release\$namespace.$package.$version.nupkg -source $HOME\nuggets
}

function guid {
  New-Guid | Select-Object -ExpandProperty Guid | clip
}
