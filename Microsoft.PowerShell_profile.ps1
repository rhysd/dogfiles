if ($host.Name -eq "ConsoleHost")
{
    # Aliases
    Set-Alias g git
    Set-Alias v gvim
    Set-Alias m make
    function nr {
        npm run @args
    }

    # Set the default encoding of > and >>
    $PSDefaultParameterValues["Out-File:Encoding"] = "utf8"

    # Environment variables
    $Env:HGREP_DEFAULT_OPTS = "--theme ayu-mirage --background"

    # Line editor config
    Import-Module PSReadLine
    Set-PSReadlineOption -BellStyle Visual
    Set-PSReadlineOption -EditMode Emacs
    Set-PSReadLineKeyHandler -Key Ctrl+i -Function Complete
    Set-PSReadLineKeyHandler -Key Ctrl+j -Function AcceptLine
    Set-PSReadLineKeyHandler -Key Ctrl+y -Function Paste
    Set-PSReadLineKeyHandler -Key Ctrl+d -Function DeleteChar

    # Custom commands
    function time() {
        echo "Measuring `"${args}`"..."
        $head, $tail = $args
        Measure-Command { & $head $tail | Out-Default }
    }

    # Send OSC 9;9 to tell the terminal the current working directory. This configuration is necessary to keep the
    # current working directory when splitting a pane in Windows Terminal. Otherwise Windows Terminal opens a new pane
    # with the starting directory instead of the current working directory.
    # https://learn.microsoft.com/ja-jp/windows/terminal/tutorials/new-tab-same-directory
    #
    # Note: `$ExecutionContext.SessionState.Path.LocationChanged` is better but not available on PowerShell 5.1
    function prompt {
        $loc = $executionContext.SessionState.Path.CurrentLocation;

        $out = ""
        if ($loc.Provider.Name -eq "FileSystem") {
            $out += "$([char]27)]9;9;`"$($loc.ProviderPath)`"$([char]27)\"
        }
        $out += "PS $loc$('>' * ($nestedPromptLevel + 1)) ";
        return $out
    }
}
