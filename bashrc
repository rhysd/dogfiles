export PATH=/opt/local/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/rvm/bin:$PATH

export HISTCONTROL=ignoreboth

alias ls='ls -G'
alias l='ls'
alias ll='ls -la'
alias la='ls -a'
alias pu='pushd'
alias po='popd'
alias v='vim'
alias c='cd'
#alias grep='/opt/local/bin/grep'
# alias g++46='g++-mp-4.6 -std=c++0x -Wall -Wextra -O2'
alias g++='g++ -std=c++0x -Wall -Wextra -O2'
alias Emacs='open -a /Applications/MacPorts/Emacs.app'
alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'
alias Vim='open -a /Applications/MacVim.app'
PS1="\u:\w \$ "

#Homebrew
export HOMEBREW_VERBOSE=true
export HOMEBREW_EDITOR=vim

#Gentoo
# alias ls='ls --color=auto'
# alias mman='/usr/bin/man'
# export EPREFIX="$HOME/gentoo"
# export PATH="$EPREFIX/usr/bin:$EPREFIX/bin:$EPREFIX/tmp/usr/bin:$EPREFIX/tmp/bin:$PATH"
# export PATH="$PATH:$EPREFIX/usr/portage/scripts"
# export DYLD_LIBRARY_PATH=/Users/rhayasd/gentoo/usr/lib:$DYLD_LIBRARY_PATH
