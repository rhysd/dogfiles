if ($host.Name -eq "ConsoleHost")
{
    # Aliases
    Set-Alias g git
    Set-Alias v gvim
    function nr {
        npm run @args
    }

    # Set the default encoding of > and >>
    $PSDefaultParameterValues["Out-File:Encoding"] = "utf8"

    # Environment variables
    $Env:HGREP_DEFAULT_OPTS = "--theme ayu-mirage --background"

    # Line editor config
    Import-Module PSReadLine
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
}
