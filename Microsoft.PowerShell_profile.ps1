if ($host.Name -eq 'ConsoleHost')
{
    Import-Module PSReadLine

    Set-PSReadlineOption -EditMode Emacs

    Set-PSReadLineKeyHandler -Key Ctrl+i -Function Complete
    Set-PSReadLineKeyHandler -Key Ctrl+j -Function AcceptLine
    Set-PSReadLineKeyHandler -Key Ctrl+y -Function Paste
    Set-PSReadLineKeyHandler -Key Ctrl+d -Function DeleteChar
}
