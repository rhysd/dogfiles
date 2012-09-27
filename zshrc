export LANG=ja_JP.UTF-8
export EDITOR=vim

export PATH=/usr/local/bin:$PATH
export PATH=$HOME/.cabal/bin:$PATH

###############
#   Aliases   #
###############
# {{{
alias ls='ls --color=auto'
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
alias gvim='vim -g'
alias sudo='sudo '
alias sshi='ssh -i $HOME/.ssh/id_rsa'

alias l=ls
alias pd=popd
alias v=vim
alias gv=gvim
alias c=cd
alias s=sudo
alias h='history 0'
alias k=kill
alias ng=noglob
alias d=dirs
alias g=git

# global alias
alias -g G='| grep'
alias -g L='| less'

# suffix alias
alias -s cpp=g++
alias -s cc=g++

# aliases for C++
alias g++='g++ -std=c++11 -O2 -g -Wall -Wextra'
alias gpp=g++
function run-gcc(){
    set -e
    /usr/local/bin/g++-4.7 -g -O2 -Wall -Wextra -std=c++11 $* && ./a.out
}
alias rg=run-gcc
alias clang++='clang++ -stdlib=libc++ -std=c++11 -O2 -g -Wall -Wextra'
alias cl=clang++

# aliase for git
alias gad="git add"
alias gbl="git blame"
alias gbr="git branch"
alias gch="git checkout"
alias gcl="git clone"
alias gco="git commit"
alias gdi="git diff"
alias gfe="git fetch"
alias glo="git log"
alias gme="git merge"
alias gpl="git pull"
alias gps="git push"
alias grb="git rebase"
alias gst="git status"
alias gre="git remote"
# }}}

##########################
#   モジュールのロード   #
##########################
# {{{
autoload -Uz compinit; compinit -u
autoload -Uz colors; colors
autoload -Uz history-search-end
autoload -Uz vcs_info
autoload -Uz terminfo
autoload -Uz zmv
autoload -Uz zcalc
autoload -Uz add-zsh-hook
# }}}

###############
#   Options   #
###############
# {{{
setopt \
  always_last_prompt \
  append_history \
  auto_cd \
  auto_list \
  auto_menu \
  auto_param_keys \
  auto_param_slash \
  auto_pushd \
  brace_ccl \
  complete_aliases \
  complete_in_word \
  csh_null_glob \
  hist_expand \
  hist_ignore_dups \
  hist_ignore_space \
  hist_no_store \
  hist_reduce_blanks \
  interactive_comments \
  listambiguous \
  long_list_jobs \
  magic_equal_subst \
  mark_dirs \
  no_autoremoveslash \
  no_beep \
  no_flow_control \
  nolistbeep \
  print_eight_bit \
  prompt_subst \
  pushd_ignore_dups \
  share_history \
;
# }}}

##################
#   Completion   #
##################
# {{{
# ユーザ定義補完
if [ -d ~/.zsh/site-functions ]; then
  fpath=(~/.zsh/site-functions ${fpath})
fi

# 補完に使うソース
zstyle ':completion:*' completer _complete _expand _list _match _prefix

# 補完候補の色付け
zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'

# スマートケースで補完
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' '+m:{A-Z}={a-z}'

# 補完を選択できるように
zstyle ':completion:*' menu select=2

# sudo を含めても保管できるようにする
zstyle ':completion:*:sudo:*' command-path $sudo_path $path

# キャッシュ
zstyle ':completion:*' use-cache true
# }}}

##############
#   Prompt   #
##############
# {{{
# 扱う VCS
zstyle ':vcs_info:*' enable git hg svn

# コミットしていない変更をチェックする
zstyle ":vcs_info:*" check-for-changes true

zstyle ':vcs_info:*' stagedstr "+"
zstyle ':vcs_info:*' unstagedstr "?"

# 通常時フォーマット
zstyle ':vcs_info:*' formats '%u%c%b (%s)'

# VCS で何かアクション中のフォーマット
zstyle ':vcs_info:*' actionformats '%u%c%b (%s) !%a'

# VCS 情報（ブランチ名・VCS名・アクション名・状態（色））
function vcs_info_precmd(){
  LANG=en_US.UTF-8 vcs_info
  if [[ -n "$vcs_info_msg_0_" ]]; then
    if [[ $vcs_info_msg_0_ =~ "^\?" ]]; then
      color=%B%F{red}
      msg=${vcs_info_msg_0_##\?(\+|)}
    elif [[ $vcs_info_msg_0_ =~ "^\+" ]]; then
      color=%B%F{yellow}
      msg=${vcs_info_msg_0_#\+}
    else
      color=%B%F{green}
      msg=$vcs_info_msg_0_
    fi
    echo "[$color$msg%f%b]"
  fi
}

# 左プロンプト
terminfo_down_sc=$terminfo[cud1]$terminfo[cuu1]$terminfo[sc]$terminfo[cud1]
function _left_down_prompt_preexec () { print -rn -- $terminfo[el]; }
add-zsh-hook preexec _left_down_prompt_preexec
PROMPT_2='`vcs_info_precmd`'
PROMPT="%{$terminfo_down_sc$PROMPT_2$terminfo[rc]%}%{$fg_bold[green]%}%~%{$reset_color%} %# "

# 右プロンプト
RPROMPT='[%{$fg_bold[red]%}${HOST}%{$reset_color%}][%{$fg_bold[red]%}%D{%m/%d %H:%M}%{$reset_color%}]'
# }}}

#######################
#   histroy setting   #
#######################
# {{{
HISTFILE=$HOME/.zsh/zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
# }}}

####################
#   キーバインド   #
####################
# {{{
# Emacs like keybind
bindkey -e

# <C-N>と<C-P>：複数行の処理と通常時で使い分る
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
bindkey '^[^i' reverse-menu-complete

# history pattern matching
# zsh 4.3.10 or later is required
bindkey '^R' history-incremental-pattern-search-backward
bindkey '^S' history-incremental-pattern-search-forward

# ^J で parent directory に移動
function _parent() {
  pushd .. > /dev/null
  zle reset-prompt
}
zle -N _parent
bindkey "^J" _parent

# ^O で popd する
function _pop_hist(){
  popd > /dev/null
  zle reset-prompt
}
zle -N _pop_hist
bindkey "^O" _pop_hist

# ^Q で git status を見る
function _git_status(){
  echo
  git status -sb
  zle reset-prompt
}
zle -N _git_status
bindkey "^Q" _git_status

# 空行の状態で Tab を入れると ls する
function _advanced_tab(){
  if [[ $#BUFFER == 0 ]]; then
    echo ""
    eval ls
    zle redisplay
  else
    zle expand-or-complete
  fi
}
zle -N _advanced_tab
bindkey "^I" _advanced_tab

# }}}

##############
#   その他   #
##############
# {{{

# フロー制御の無効化
stty -ixon

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


##########################################
#   source platform-dependant settings   #
##########################################

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
# }}}

