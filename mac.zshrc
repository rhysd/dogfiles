unalias ls
alias ls='ls -G'
alias top='sudo htop'

if which grm > /dev/null; then
    alias rm=grm
    alias tar=gtar
fi

# suffix aliases
alias -s pdf='open -a Preview'
alias -s html='open -a Google\ Chrome'

# global aliases
alias -g C='| pbcopy'

# completions
if [ -d /usr/local/share/zsh-completions ]; then
    fpath=($HOME/brew/share/zsh-completions $fpath)
fi

#Homebrew
export HOMEBREW_VERBOSE=true
export HOMEBREW_EDITOR=vim

# Go
if which go > /dev/null; then
    if [ ! -d "$HOME/.go" ]; then
        mkdir -p "$HOME/.go"
    fi
    export GOPATH=$HOME/.go
    export PATH=$GOPATH/bin:$PATH
fi

# Appium
export JAVA_HOME=`/usr/libexec/java_home`

# vim: set ft=zsh fdm=marker ff=unix fileencoding=utf-8:
