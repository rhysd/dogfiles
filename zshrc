set -e

export LANG=ja_JP.UTF-8

export PATH=/usr/local/bin:$PATH
export PATH=$HOME/.cabal/bin:$PATH

export EDITOR=vim

alias sudo='sudo '

alias g++='g++ -std=c++11 -O2 -g -Wall -Wextra'
alias g=g++
function run-gcc(){
    set -e
    /usr/local/bin/g++-4.7 -g -O2 -Wall -Wextra -std=c++11 $* && ./a.out
}
alias rg=run-gcc
alias clang++='clang++ -stdlib=libc++ -std=c++11 -O2 -g -Wall -Wextra'
alias cl=clang++
alias gvim='vim -g'

alias ls='ls -G'
alias lr='ls -R'
alias ll='ls -lah'
alias llr='ls -laRh'
alias la='ls -a'
alias gr='grep -nl --color'
alias pg='ps aux | grep'
alias md='mkdir -pv'
alias rmr='rm -R'
alias rm!='rm -f'
alias rmr!='rm -Rf'
alias ja='LANG=ja_JP.UTF8 LC_ALL=ja_JP.UTF-8'
alias en='LANG=en_US.UTF8 LC_ALL=en_US.UTF-8'
alias cp='cp -p'
alias cpr='cp -pR'
alias df='df -h'
alias su='su -'
alias be='bundle exec'
alias diff=colordiff
alias quit=exit
alias vimfiler='vim +VimFiler'
alias vimshell='vim +VimShell'

alias l=ls
alias pd=popd
alias v=vim
alias gv=gvim
alias c=cd
alias s=sudo
alias h='history 0'
alias k=kill

# global alias
alias -g G='| grep'
alias -g L='| less'

function sshi(){
    ssh -i $HOME/.ssh/id_rsa r-hayashida@$1
}

# Completion
if [ -d ~/.zsh/site-functions ]; then
  fpath=(~/.zsh/site-functions ${fpath})
fi
autoload -U compinit
compinit -u
zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
# SmartCase
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' '+m:{A-Z}={a-z}'
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

setopt prompt_subst
autoload -Uz VCS_INFO_get_data_git; VCS_INFO_get_data_git 2> /dev/null

function current-git-branch() {
  local name st color gitdir action

  name=$(basename "`git symbolic-ref HEAD 2> /dev/null`")
  if [[ -z $name ]]; then
    return
  fi
  if [[ "$PWD" =~ '/¥.git(/.*)?$' ]]; then
    return
  fi

  gitdir=`git rev-parse --git-dir 2> /dev/null`
  action=`VCS_INFO_git_getaction "$gitdir"` && action="($action)"

  st=`git status 2> /dev/null`
  if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
    color=%F{green}
  elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
    color=%F{yellow}
  elif [[ -n `echo "$st" | grep "^# Untracked"` ]]; then
    color=%B%F{red}
  else
     color=%F{red}
  fi
  echo "[$color$name$action%f%b]"
}

PROMPT="${GREEN}%~${DEFAULT} %# "
RPROMPT='`current-git-branch` [${RED}%D{%m/%d %H:%M}${DEFAULT}]'

# histroy setting
HISTFILE=$HOME/.zsh/zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt hist_ignore_dups
setopt share_history
setopt append_history
# zstyle ':completion:*:default' menu select=1
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

# rbenv
if which rbenv > /dev/null; then
  # initialize rbenv
  eval "$(rbenv init -)"
  # rehash rbenv executable file database at [un]installation
  function gem(){
      /Users/rhayasd/.rbenv/shims/gem $*
      if [ "$1" = "install" ] || [ "$1" = "i" ] || [ "$1" = "uninstall" ] || [ "$1" = "uni" ]
      then
          rbenv rehash
          rehash
      fi
  }
fi

# git uses hub (this is not dangerous)
if which hub > /dev/null; then
  eval "$(hub alias -s)"
fi

# source platform-dependant settings
case $OSTYPE in
  darwin*)
    # Mac OS
    if [ -f ~/.mac.zshrc ]; then
      source ~/.mac.zshrc
    fi
    ;;
  linux*)
    # Linux
    if [ -f ~/.linux.zshrc ]; then
      source ~/.linux.zshrc
    fi
    ;;
esac
