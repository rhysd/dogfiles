unalias ls
alias ls='ls -G'
alias g++='g++-4.9 -std=c++11 -Wall -Wextra -O2'
alias emacs='/usr/local/bin/emacs -nw'
alias vi="vim --cmd \"let g:linda_pp_startup_with_tiny = 1\""
alias rm=grm
alias tar=gtar
alias top='sudo htop'
alias update='brew update && gem update && vim -N -V1 -e -s --cmd "source ~/.vimrc" --cmd NeoBundleUpdate --cmd qall!'
alias sshi='ssh -i $HOME/.ssh/id_rsa'
alias Vim=gvim
alias clang++='clang++-3.5 -std=c++1y -stdlib=libc++ -O2 -Wall -Wextra'
alias cl='clang++-3.5 -std=c++1y -stdlib=libc++ -O2 -Wall -Wextra'
alias here='open .'

# suffix alias
alias -s pdf='open -a Preview'
alias -s html='open -a Google\ Chrome'

if which pbcopy > /dev/null; then
    alias -g C='| pbcopy'
fi

if which terminal-notifier > /dev/null; then
    alias -g BG=' 2>&1 | terminal-notifier &'
fi

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

function Emacs(){
    if [ "$1" != "" ]; then
        touch $1
    fi
    open -a Emacs.app $1
}

function up(){
    local outdated
    brew update
    outdated=`brew outdated`
    if [[ outdated != '' ]]; then
        echo
        echo 'Outdated fomulae:'
        echo $outdated
        echo
    fi
}

# vim: set ft=zsh fdm=marker ff=unix fileencoding=utf-8:
