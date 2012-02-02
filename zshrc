export LANG=ja_JP.UTF-8
export TERM=xterm-256color

export EDITOR=vim

alias g++='g++ -std=c++0x -Wall -Wextra -O2'

alias ls='ls --color=auto'
alias l='ls'
alias ll='ls -la'
alias la='ls -a'
alias pd='popd'
alias v='vim'
alias V='Vim'
alias gvim='vim -g'
alias gv='gvim'
alias c='cd'
alias s='sudo'
alias -g gr='grep -nl --color'
alias -g g=git
alias -g pg='ps aux | grep'
alias -g md='mkdir'
alias -g mkdir='mkdir -pv'
alias -g h='history 0'
alias -g k='kill'
alias -g rm!='rm -R'
alias -g x='exit'
alias -g ja='LANG=ja_JP.UTF8 LC_ALL=ja_JP.UTF-8'
alias -g en='LANG=en_US.UTF8 LC_ALL=en_US.UTF-8'

#suffix alias
alias -s pdf='acroread'

# global alias
# alias -g G='| grep'

# Completion
fpath=(~/.zsh/functions ${fpath})
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

# cd
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups

# コマンド修正
# setopt correct

# 補完を詰めて表示
setopt list_packed

# ビープ音OFF
setopt nolistbeep

# /を除去しない
setopt noautoremoveslash

# 日本語表示
setopt print_eight_bit
