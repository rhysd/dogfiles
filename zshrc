###############
#   Exports   #
###############
# {{{
export LANG=ja_JP.UTF-8
export EDITOR=vim
# export LESS='--LONG-PROMPT --ignore-case'

export PATH=/usr/local/bin:$PATH

# ワード単位移動の挙動
export WORDCHARS=

# Haskell executables
if [ -d $HOME/.cabal ]; then
    export PATH=$HOME/.cabal/bin:$PATH
fi

export DOTZSH=$HOME/.zsh
if [ ! -d $DOTZSH ];then
    mkdir -p $DOTZSH
fi
# }}}

###############
#   Aliases   #
###############
# {{{
alias ls='ls --color=auto'
alias lr='ls -R'
alias ll='ls -lah'
alias llr='ls -laRh'
alias la='ls -A'
alias gr='grep -nl --color'
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
alias memo='cat > /dev/null'
alias memolist='vim +MemoList'
alias memonew='vim +MemoNew'
alias flavor='vim-flavor test'

alias l=ls
alias pd=popd
alias v=vim
alias gv=gvim
alias c=cd
alias s=sudo
alias hi='history 0'
alias k=kill
alias ng=noglob
alias d=dirs
alias g=git
alias e='emacs -nw'
alias h=hg
alias m=make

# global alias
alias -g G='| grep'
alias -g GI='| grep -i'
alias -g L='| less'
alias -g V='| view -R -'
alias -g H='| head'
alias -g S='| sed'
alias -g A='| awk'
alias -g D='> /dev/null 2>&1'
alias -g X='| xargs'
alias -g P='| percol'

if [[ $TMUX != "" ]]; then
    alias -g BG=' 2>&1 | tmux display-message &'
fi

# suffix alias
alias -s tex=platex
alias -s dvi=dvipdfmx
alias -s bib=bibtex

# aliases for C++
alias g++='g++ -std=c++11 -O2 -Wall -Wextra'
alias gpp=g++
alias rg=run-gcc
alias clang++='clang++ -stdlib=libc++ -std=c++11 -O2 -Wall -Wextra'
alias cl=clang++

# vspec
if [ -d "$HOME/.vim/bundle/vim-vspec-matchers" ]; then
    alias vspec='PATH=/usr/local/bin:$PATH ~/.vim/bundle/vim-vspec/bin/vspec ~/.vim/bundle/vim-vspec ~/.vim/bundle/vim-vspec-matchers'
else
    alias vspec='PATH=/usr/local/bin:$PATH ~/.vim/bundle/vim-vspec/bin/vspec ~/.vim/bundle/vim-vspec'
fi

# tmux wrapper
if which tmux > /dev/null; then
    function t(){
        if [[ $TMUX == "" && $# == 0 ]]; then
            tmux new-session \; split-window -h \; select-pane -t 0
        else
            tmux $@
        fi
    }
fi
# }}}

############
#   関数   #
############
# {{{
function separate(){
    echo -n $fg_bold[yellow]
    for i in $(seq 1 $COLUMNS); do
        echo -n '~'
    done
    echo -n $reset_color
}

function kiritori(){
    echo -n $fg_bold[blue]
    for i in $(seq 1 $(($COLUMNS/4-2))); do
        echo -n '- '
    done
    echo -n ' ｷﾘﾄﾘｾﾝ '
    for i in $(seq 1 $(($COLUMNS/4-2))); do
        echo -n ' -'
    done
    echo -n $reset_color
    echo
}

function run-gcc(){
    set -e
    g++ $* && ./a.out
}

function source-file(){
    [[ -s "$1" ]] && source "$1"
}

function reload(){
    source-file $HOME/.zshrc
    source-file $HOME/.zshenv
}

function pg(){
    ps aux | grep "$1" | grep -v grep
}
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
autoload -Uz smart-insert-last-word
autoload -Uz modify-current-argument
autoload -Uz chpwd_recent_dirs
autoload -Uz cdr
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

# git をエイリアス時にも補完できるようにする
compdef _git g=git
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
  local color
  local msg
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

# モードでプロンプトの色を変える
# XXX: vicmd で ^M や ^C 押下時に insert モードに入っても色が戻らない
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) PROMPT="%{$terminfo_down_sc$PROMPT_2$terminfo[rc]%}%{$fg_bold[yellow]%}%~%{$reset_color%} %# ";;
        main) PROMPT="%{$terminfo_down_sc$PROMPT_2$terminfo[rc]%}%{$fg_bold[green]%}%~%{$reset_color%} %# ";;
        viins) PROMPT="%{$terminfo_down_sc$PROMPT_2$terminfo[rc]%}%{$fg_bold[magenta]%}%~%{$reset_color%} %# ";;
    esac
    zle reset-prompt
}
zle -N zle-keymap-select
# }}}

#######################
#   histroy setting   #
#######################
# {{{
HISTFILE=$DOTZSH/zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# ワーキングディレクトリ履歴
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':completion:*:*:cdr:*:*' menu selection
zstyle ':chpwd:*' recent-dirs-max 5000
# }}}

####################
#   キーバインド   #
####################
# {{{
# Vim like keybinds as base
bindkey -v

# 単語削除や文字削除はどこでも消せるようにする
zle -A .backward-kill-word vi-backward-kill-word
zle -A .backward-delete-char vi-backward-delete-char

# <C-N>と<C-P>：複数行の処理と通常時で使い分ける
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

# Emacsバインディング（インサートモード）
bindkey -M viins '^F'    forward-char
bindkey -M viins '^B'    backward-char
bindkey -M viins '^P'    up-line-or-history
bindkey -M viins '^N'    down-line-or-history
bindkey -M viins '^A'    beginning-of-line
bindkey -M viins '^E'    end-of-line
bindkey -M viins '^K'    kill-line
bindkey -M viins '^R'    history-incremental-pattern-search-backward
bindkey -M viins '\er'   history-incremental-pattern-search-forward
bindkey -M viins '^Y'    yank
bindkey -M viins '^W'    backward-kill-word
bindkey -M viins '^U'    backward-kill-line
bindkey -M viins '^H'    backward-delete-char
bindkey -M viins '^?'    backward-delete-char
bindkey -M viins '^G'    send-break
bindkey -M viins '^D'    delete-char-or-list


# Emacsバインディング（コマンドラインモード）
bindkey -M vicmd '^A'    beginning-of-line
bindkey -M vicmd '^E'    end-of-line
bindkey -M vicmd '^K'    kill-line
bindkey -M vicmd '^P'    up-line-or-history
bindkey -M vicmd '^N'    down-line-or-history
bindkey -M vicmd '^Y'    yank
bindkey -M vicmd '^W'    backward-kill-word
bindkey -M vicmd '^U'    backward-kill-line
bindkey -M vicmd '/'     vi-history-search-forward
bindkey -M vicmd '?'     vi-history-search-backward
bindkey -M vicmd '\ef'   forward-word                      # Alt-f
bindkey -M vicmd '\eb'   backward-word                     # Alt-b
bindkey -M vicmd '\ed'   kill-word                         # Alt-d

# jj でノーマルモードに戻る
bindkey -M viins -s 'jj' '\e'

# TODO: 対応するクオート自動挿入

# ^J で parent directory に移動
function _parent() {
  pushd .. > /dev/null
  zle reset-prompt
}
zle -N _parent
bindkey -M viins "^J" _parent
bindkey -M vicmd "h"  _parent

# ^O で popd する
function _pop_hist(){
  popd > /dev/null
  zle reset-prompt
}
zle -N _pop_hist
bindkey -M viins "^O" _pop_hist
bindkey -M vicmd "l"  _pop_hist

# 前のコマンドで最後に打った単語の挿入
zle -N insert-last-word smart-insert-last-word
zstyle :insert-last-word match '*([^[:space:]][[:alpha:]/\\]|[[:alpha:]/\\][^[:space:]])*'
bindkey -M viins '^]' insert-last-word

# 1つ前の単語をシングルクォートで囲む
_quote-previous-word-in-single() {
    modify-current-argument '${(qq)${(Q)ARG}}'
    zle vi-forward-blank-word
}
zle -N _quote-previous-word-in-single
bindkey -M viins '^Q' _quote-previous-word-in-single

# 1つ前の単語をダブルクォートで囲む
_quote-previous-word-in-double() {
    modify-current-argument '${(qqq)${(Q)ARG}}'
    zle vi-forward-blank-word
}
zle -N _quote-previous-word-in-double
bindkey -M viins '^Xq' _quote-previous-word-in-double

# Shift + Tab で逆順選択
bindkey -M viins "$terminfo[kcbt]" reverse-menu-complete

# ファイルを確認する
function _ls() {
    echo
    local -a opt_ls
    case "${OSTYPE}" in
        freebsd*|darwin*)
            opt_ls=('-ACFG')
            ;;
        *)
            opt_ls=('-ACF' '--color=always')
            ;;
    esac

    command ls ${opt_ls[@]}
    zle reset-prompt
}
zle -N _ls
bindkey -M vicmd 'k' _ls
# }}}

####################
#  外部プラグイン  #
####################
# {{{
export ZSHPLUGIN=$DOTZSH/plugins
if [ ! -d $ZSHPLUGIN ]; then
    mkdir -p $ZSHPLUGIN
fi

# プラグインを更新するコマンド
function zsh-plugin-update(){
    local cwd
    cwd=$PWD
    for plugin in `ls $ZSHPLUGIN`; do
        cd $ZSHPLUGIN/$plugin
        git pull
        cd ..
    done
    cd $cwd
}


# zaw: incremental search interface
# https://github.com/zsh-users/zaw
if ! which percol &> /dev/null && [ -d $ZSHPLUGIN/zaw ]; then
    source $ZSHPLUGIN/zaw/zaw.zsh

    # zaw-cd-or-edit
    # zaw source to open file or cd cwd
    function zaw-src-cd-or-edit() { # {{{
        local root parent d f
        setopt local_options null_glob

        if (( $# == 0 )); then
            root="${PWD}/"
        else
            root="$1"
        fi

        parent="${root:h}"
        if [[ "${parent}" != */ ]]; then
            parent="${parent}/"
        fi
        candidates+=("${parent}")
        cand_descriptions+=("../")

        for d in "${root%/}"/*(/); do
            candidates+=("${d}/")
            cand_descriptions+=("${d:t}/")
        done

        for f in "${root%/}"/*(^/); do
            candidates+=("${f}")
            cand_descriptions+=("${f:t}")
        done

        actions=( "zaw-callback-cd-or-edit" "zaw-callback-append-to-buffer" )
        act_descriptions=( "cd directory or edit file" "append to edit buffer" )
        #options=( "-m" )
        options=( "-t" "${root}" )
    }

    zaw-register-src -n cd-or-edit zaw-src-cd-or-edit

    function zaw-callback-cd-or-edit() {
        local editor
        if [[ "$EDITOR" == "" ]]; then
            editor="vim"
        else
            editor="$EDITOR"
        fi

        if [[ -d "$1" ]]; then
            echo
            cd "$1"
            zle reset-prompt
        else
            BUFFER="${editor} ${(q)1}"
            zle accept-line
        fi
    }
    # }}}

    # 最大でも画面の縦幅半分までしか使わない
    zstyle ':filter-select' max-lines $(($LINES / 2))
    # 絞り込みをcase-insensitiveに
    zstyle ':filter-select' case-insensitive yes
    # キーバインド
    bindkey -M viins '^Xc' zaw-cdr
    bindkey -M viins '^Xh' zaw-history
    bindkey -M viins '^@'  zaw-history
    bindkey -M viins '^Xg' zaw-git-files
    bindkey -M viins '^Xt' zaw-tmux
    bindkey -M viins '^Xo' zaw-open-file
    bindkey -M vicmd 'j'   zaw-cd-or-edit
    bindkey -M vicmd '^R'  zaw-history
    bindkey -M vicmd '^M'  zaw-applications
    # 空行の状態で Tab を入れると zaw-cdr する
    function _advanced_tab(){
    if [[ $#BUFFER == 0 ]]; then
        zaw-cdr
        zle redisplay
    else
        zle expand-or-complete
    fi
    }
    zle -N _advanced_tab
    bindkey -M viins '^I' _advanced_tab
    bindkey -M vicmd '^I' _advanced_tab
fi

# zsh-syntax-highlighting
# https://github.com/zsh-users/zsh-syntax-highlighting
if [ -d $ZSHPLUGIN/zsh-syntax-highlighting ]; then
    source $ZSHPLUGIN/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# zsh-bundle-exec
# if [ -d ~/Github/zsh-bundle-exec ]; then
#     source ~/Github/zsh-bundle-exec/zsh-bundle-exec.zsh
# fi
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

# PWD を移動するごとにディレクトリ内のファイルを表示
# ただし，ファイルが多すぎるときは省略する
_ls_abbrev() {
    # -a : Do not ignore entries starting with ..
    # -C : Force multi-column output.
    # -F : Append indicator (one of */=>@|) to entries.
    local cmd_ls='ls'
    local -a opt_ls
    case "${OSTYPE}" in
        freebsd*|darwin*)
            opt_ls=('-ACFG')
            ;;
        *)
            opt_ls=('-ACF' '--color=always')
            ;;
    esac

    local ls_result
    ls_result=$(CLICOLOR_FORCE=1 COLUMNS=$COLUMNS command $cmd_ls ${opt_ls[@]} | sed $'/^\e\[[0-9;]*m$/d')

    local ls_lines=$(echo "$ls_result" | wc -l | tr -d ' ')

    if [ $ls_lines -gt 8 ]; then
        echo "$ls_result" | head -n 3
        echo '...'
        echo "$ls_result" | tail -n 3
        echo "$(command ls -1 -A | wc -l | tr -d ' ') files exist"
    else
        echo "$ls_result"
    fi
}
add-zsh-hook chpwd _ls_abbrev

# }}}

[[ -f ~/Github/zsh-bundle-exec/zsh-bundle-exec.zsh ]] && source ~/Github/zsh-bundle-exec/zsh-bundle-exec.zsh

#   percol
function percol-pgrep() {
    if [[ $1 == "" ]]; then
        PERCOL=percol
    else
        PERCOL="percol --query $1"
    fi
    ps aux | eval $PERCOL | awk '{ print $2 }'
}
zle -N percol-pgrep

function percol-pkill() {
    if [[ $1 =~ "^-" ]]; then
        QUERY=""            # options only
    else
        QUERY=$1            # with a query
        [[ $# > 0 ]] && shift
    fi
    percol-pgrep $QUERY | xargs kill $*
}
zle -N percol-pkill

function percol-history-insert() {
    local tac
    which gtac &> /dev/null && tac="gtac" || { which tac &> /dev/null && tac="tac" || { tac="tail -r" } }
    tac="tail -r"
    BUFFER=$(fc -l -n 1 | eval $tac | percol --query "$LBUFFER")
    CURSOR=$#BUFFER         # move cursor
    zle -R -c               # refresh
}
zle -N percol-history-insert

function percol-history() {
    local tac
    which gtac &> /dev/null && tac="gtac" || { which tac &> /dev/null && tac="tac" || { tac="tail -r" } }
    tac="tail -r"
    BUFFER=$(fc -l -n 1 | eval $tac | percol --query "$LBUFFER")
    zle clear-screen
    zle accept-line
}
zle -N percol-history
bindkey -M viins '^ h' percol-history

function percol-cdr-impl() {
    cdr -l | \
        sed -e 's/^[[:digit:]]*[[:blank:]]*//' | \
        percol --query "$LBUFFER"
}
function percol-cdr-insert() {
    local selected
    selected=$(cdr -l | sed -e 's/^[[:digit:]]*[[:blank:]]*//' | percol)
    BUFFER=${BUFFER}${selected}
    CURSOR=$#BUFFER
    zle redisplay
}
zle -N percol-cdr-insert

function percol-cdr() {
    local destination="$(percol-cdr-impl)"
    if [ -n "$destination" ]; then
        BUFFER="cd $destination"
        zle accept-line
    else
        zle reset-prompt
    fi
}
zle -N percol-cdr

function _advanced_tab(){
if [[ $#BUFFER == 0 ]]; then
    percol-cdr
    zle redisplay
else
    zle expand-or-complete
fi
}
zle -N _advanced_tab

bindkey -M viins '^I' _advanced_tab
bindkey -M viins '^ r' _advanced_tab

if which ghq &> /dev/null; then
    function percol-ghq () {
        local selected_dir=$(ghq list --full-path | percol --query "$LBUFFER")
        if [ -n "$selected_dir" ]; then
            BUFFER="cd ${selected_dir}"
            zle accept-line
        fi
        zle clear-screen
    }
    zle -N percol-ghq
    bindkey -M viins '^ g' percol-ghq
fi

function percol-git-log() {
    local sed
    case $OSTYPE in
    darwin*)
        sed="gsed"
        ;;
    linux*)
        sed="sed"
        ;;
    esac

    local hash
    hash=$(git log --no-color --oneline --graph --all --decorate | percol | $sed -e "s/^\W\+\([0-9A-Fa-f]\+\).*$/\1/")
    BUFFER="${BUFFER}${hash}"
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N percol-git-log
bindkey -M viins '^ o' percol-git-log

function percol-ls-l(){
    local selected
    selected=$(ls -l | grep -v ^total | percol | awk '{print $(NF)}')
    if [ -d "$selected" ]; then
        BUFFER="cd $selected"
        zle accept-line
        zle clear-screen
    elif [ -f "$selected" ]; then
        BUFFER="vim $selected"
        zle accept-line
        zle clear-screen
    fi
}
zle -N percol-ls-l
bindkey -M viins '^ l' percol-ls-l

function percol-ls-l-insert(){
    local selected
    selected=$(ls -l | grep -v ^total | percol | awk '{print $(NF)}')
    BUFFER="${BUFFER}$selected"
    CURSOR=$#BUFFER
    zle redisplay
}
zle -N percol-ls-l-insert
bindkey -M viins '^ l' percol-ls-l-insert

function percol-find-insert(){
    local selected
    selected=$(find ./* | percol)
    BUFFER="${BUFFER}${selected}"
    CURSOR=$#BUFFER
    zle redisplay
}
zle -N percol-find-insert
bindkey -M viins '^ f' percol-find-insert

function percol-insert(){
    local selected
    selected=$(eval ${BUFFER} | percol)
    BUFFER="${selected}"
    CURSOR=$#BUFFER
    zle redisplay
}
zle -N percol-insert
bindkey -M viins '^ ^M' percol-insert

function percol-source(){
    local percols
    local selected_source
    sources=(pgrep pkill history history-insert cdr cdr-insert ghq git-log ls-l ls-l-insert find-insert locate)
    selected_source=$(echo ${(j:\n:)sources} | percol)
    zle clear-screen
    zle percol-${selected_source}
}
zle -N percol-source
bindkey -M viins '^ ' percol-source

##########################################
#   source platform-dependant settings   #
##########################################
# {{{

case $OSTYPE in
  darwin*)
    # Mac OS
    [ -f ~/.mac.zshrc ] && source ~/.mac.zshrc
    ;;
  linux*)
    # Linux
    [ -f ~/.linux.zshrc ] && source ~/.linux.zshrc
    ;;
esac
# }}}
