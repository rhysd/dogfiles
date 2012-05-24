export LANG=ja_JP.UTF-8

# export PATH=/opt/local/bin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/switcher.bin:$PATH
export PATH=/usr/local/texlive/2011/bin/x86_64-darwin:$PATH

export EDITOR=vim

alias sudo='sudo '

alias g++='g++ -std=c++0x -Wall -Wextra -O2'
alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'
alias Vim='open -a /Applications/MacVim.app'
# alias pvim='vim -u /Users/rhayasd/.pvimrc'
alias pvim='vim -u $HOME/.pvimrc'
alias pv=pvim
alias vi=pvim
alias emacs='/usr/local/bin/emacs -nw'
alias Emacs='open -a /usr/local/bin/emacs'
alias locate='/usr/bin/locate'

alias ls='ls -Gh'
alias -g l='ls'
alias -g lr='ls -R'
alias -g ll='ls -la'
alias -g llr='ls -laR'
alias -g la='ls -a'
alias -g pd='popd'
alias -g v='vim'
alias -g V='Vim'
alias -g c='cd'
alias -g s='sudo'
alias -g gr='grep -nl --color'
# alias -g g=git
alias -g g=g++
alias -g pg='ps aux | grep'
alias -g md='mkdir -pv'
alias -g h='history 0'
alias -g k='kill'
alias rm='grm'
alias -g rmr='rm -R'
alias -g rm!='rm -f'
alias -g rmr!='rm -Rf'
alias -g ja='LANG=ja_JP.UTF8 LC_ALL=ja_JP.UTF-8'
alias -g en='LANG=en_US.UTF8 LC_ALL=en_US.UTF-8'
alias cp='cp -p'
alias -g cpr='cp -r'
alias -g cpr!='cp -R'
alias -g gita='git add'
alias -g gitc='git commit'
alias -g gitl='git log'
alias -g gitp='git push'
alias -g gitpl='git pull'
alias -g gitls='git ls-files'
alias df='df -h'
alias su='su -'
alias be='bundle exec'
alias quit=exit


# suffix alias
alias -s pdf='open -a Preview'
alias -s html='open -a Google\ Chrome'

# global alias
# alias -g G='| grep'

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

# rbenv
eval "$(rbenv init -)"

# Completion
fpath=(~/.zsh/site-functions ${fpath})
autoload -U compinit
compinit -u
zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
# SmartCase
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' '+m:{A-Z}={a-z}'
# eval `dircolors`
# zstyle ':completion:*:default' list-colors ${LS_COLORS}
# =のあとも補完する
setopt magic_equal_subst
# 対応する括弧などを自動で補完
setopt auto_param_keys

# Prompt Setting
local GREEN=$'%{\e[1;32m%}'
local RED=$'%{\e[1;31m%}'
# local YELLOW=$'%{\e[1;33m%}'
# local BLUE=$'%{\e[1;34m%}'
local DEFAULT=$'%{\e[1;m%}'
# PROMPT="${RED}%D %T${DEFAULT} %# "
PROMPT="${RED}%D{%m/%d %H:%M}${DEFAULT} %# "
RPROMPT="[${GREEN}%~${DEFAULT}]"

# histroy setting
HISTFILE=~/.zsh/zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups
setopt share_history
setopt append_history
zstyle ':completion:*:default' menu select=1
# 先頭がスペースの場合、ヒストリに追加しない
setopt hist_ignore_space

# Emacs like keybind
bindkey -e

# <C-N>と<C-P>：複数行の処理と通常時で使い分る
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
bindkey '^[^i' reverse-menu-complete

# history pattern matching
# zsh 4.3.10 or later is required
bindkey '^R' history-incremental-pattern-search-backward
bindkey '^S' history-incremental-pattern-search-forward

# cd
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups

# フロー制御の無効化
unsetopt flow_control
setopt no_flow_control
stty -ixon

# コマンド修正
# setopt correct

# 補完を詰めて表示
setopt list_packed

# ビープ音OFF
setopt nolistbeep



# 日本語表示
setopt print_eight_bit

function Emacs(){
    if [ "$1" != "" ]; then
        touch $1
    fi
    open -a /usr/local/bin/emacs $1
}

# Twitter Timeline Prompt
ruby /Users/rhayasd/programs/ruby/twitter_prompt.rb init
# function precmd(){
#     ruby /Users/rhayasd/programs/ruby/twitter_prompt.rb
# }
function init_twit_prompt(){
    ruby /Users/rhayasd/programs/ruby/twitter_prompt.rb init
}
function tweet(){
    ruby /Users/rhayasd/programs/ruby/twitter_prompt.rb update "$1"
}

# switcher setting
function switcher(){
    /usr/local/bin/switcher $*

    if [ "$1" = "use" ]; then
        echo "rehash shell database"
        rehash
    fi
}

# for rbenv
function gem(){
    /Users/rhayasd/.rbenv/shims/gem $*
    if [ "$1" = "install" ] || [ "$1" = "i" ] || [ "$1" = "uninstall" ] || [ "$1" = "uni" ]
    then
        rbenv rehash
        rehash
    fi
}

# auto-fu.zsh
# source $HOME/.zsh/auto-fu.zsh/auto-fu.zsh
# zle-line-init(){auto-fu-init;}; zle -N zle-line-init
# zstyle ':completion:*' completer _oldlist _complete _match
# # vi-cmd の場合
# # zle -N zle-keymap-select auto-fu-zle-keymap-select
# # '-azfu-' を消す
# zstyle ':auto-fu:var' postdisplay
# # git はオプション補完でバグるのでOFFにする
# # zstyle ':auto-fu:var' autoable-function/skipwords "^git *"
# # 最初の2文字の補完を無効に
# # zstyle ':auto-fu:var' autoable-function/skipwords "^((???)##)"
# # /が重複しないように unsetopt
# unsetopt noautoremoveslash

# z
_Z_CMD=j
source $HOME/.zsh/z/z.sh
precmd(){
    _z --add "$(pwd -P)"
    ruby /Users/rhayasd/programs/ruby/twitter_prompt.rb
}

# git uses hub (this is not dangerous)
eval "$(hub alias -s)"
