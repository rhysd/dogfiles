
export PATH=/usr/local/texlive/2011/bin/x86_64-darwin:$PATH

unalias ls
alias ls='ls -G'
alias g++='g++-4.8 -std=c++0x -Wall -Wextra -O2'
# alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'
# alias gvim='open -n -a /Applications/MacVim.app'
alias emacs='/usr/local/bin/emacs -nw'
alias locate='/usr/bin/locate'
alias vi="vim --cmd \"let g:linda_pp_startup_with_tiny = 1\""
alias rm=grm
alias update='brew update && gem update && vim -N -V1 -e -s --cmd "source ~/.vimrc" --cmd NeoBundleUpdate --cmd qall!'
alias sshi='ssh -i $HOME/.ssh/id_rsa'

alias Vim=gvim

# suffix alias
alias -s pdf='open -a Preview'
alias -s html='open -a Google\ Chrome'
alias -s cpp=g++-4.8
alias -s cc=g++-4.8

#Homebrew
export HOMEBREW_VERBOSE=true
export HOMEBREW_EDITOR=vim

function Emacs(){
    if [ "$1" != "" ]; then
        touch $1
    fi
    open -a /Applications/Emacs.app $1
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
    gem update
}

# Twitter Timeline Prompt
# ruby /Users/rhayasd/programs/ruby/twitter_prompt.rb init
# function precmd(){
#     ruby /Users/rhayasd/programs/ruby/twitter_prompt.rb
# }
# function init_twit_prompt(){
#     ruby /Users/rhayasd/programs/ruby/twitter_prompt.rb init
# }
# function tweet(){
#     ruby /Users/rhayasd/programs/ruby/twitter_prompt.rb update "$1"
# }

