###############
#   Exports   #
###############
# {{{
export LANG=ja_JP.UTF-8
export EDITOR=vim

export PATH=/usr/local/bin:$PATH

# ワード単位移動の挙動
export WORDCHARS=

if [ -d $HOME/.cabal ]; then
    export PATH=$HOME/.cabal/bin:$PATH
fi

if [ -d $HOME/.cargo/bin ]; then
    export PATH=$HOME/.cargo/bin:$PATH
fi

if [ -d $HOME/.opam ]; then
    export PATH=$HOME/.opam/system/bin:$PATH
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
alias gvim='vim -g'
alias sudo='sudo '
alias memo='cat > /dev/null'
alias nr='npm run'
alias cr='cargo run --'

alias l=ls
alias v=vim
alias gv=gvim
alias t=time
alias ng=noglob
alias g=git
alias cl='clang++ -stdlib=libc++ -std=c++1y -Wall -Wextra'
alias m=make
alias d=docker

# global alias
alias -g G='| grep'
alias -g GI='| grep -i'
alias -g L='| less'
alias -g V='| view -R -'
alias -g D='> /dev/null 2>&1'
alias -g X='| xargs'
alias -g XV='| xargs -o | vim'
alias -g SPONGE='> /tmp/zsh-sponge-tmp; cat /tmp/zsh-sponge-tmp >'

if [[ $TMUX != "" ]]; then
    alias -g BG=' 2>&1 | xargs tmux display-message &'
fi

# vspec
if [ -d "$HOME/.vim/bundle/vim-vspec-matchers" ]; then
    alias vspec='PATH=/usr/local/bin:$PATH ~/.vim/bundle/vim-vspec/bin/vspec ~/.vim/bundle/vim-vspec ~/.vim/bundle/vim-vspec-matchers'
else
    alias vspec='PATH=/usr/local/bin:$PATH ~/.vim/bundle/vim-vspec/bin/vspec ~/.vim/bundle/vim-vspec'
fi
# }}}

############
#   関数   #
############
# {{{
function separate(){
    echo -n $fg_bold[yellow]
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

function source-file(){
    [[ -s "$1" ]] && source "$1"
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
PROMPT_2='$(vcs_info_precmd)'
PROMPT_NEWLINE=$'\n'
GREEN_PROMPT="%{$fg_bold[green]%}%~%{$reset_color%}${PROMPT_NEWLINE}%{$terminfo_down_sc$PROMPT_2$terminfo[rc]%}%{$fg_bold[green]%}U%(?,'w',;w;))%{$reset_color%} { "
YELLOW_PROMPT="%{$fg_bold[yellow]%}%~%{$reset_color%}${PROMPT_NEWLINE}%{$terminfo_down_sc$PROMPT_2$terminfo[rc]%}%{$fg_bold[yellow]%}U%(?,'w',;w;))%{$reset_color%} { "
PROMPT="$GREEN_PROMPT"

# 右プロンプト
RPROMPT='[%{$fg_bold[red]%}${HOST}%{$reset_color%}][%{$fg_bold[red]%}%D{%m/%d %H:%M}%{$reset_color%}]'

# モードでプロンプトの色を変える
# XXX: vicmd で ^M や ^C 押下時に insert モードに入っても色が戻らない
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) PROMPT="$YELLOW_PROMPT";;
        main) PROMPT="$GREEN_PROMPT";;
        viins) PROMPT="$GREEN_PROMPT";;
    esac
    zle reset-prompt
}
zle -N zle-keymap-select
# }}}

#######################
#   Histroy setting   #
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
bindkey -M viins '^F'  forward-char
bindkey -M viins '^B'  backward-char
bindkey -M viins '^A'  beginning-of-line
bindkey -M viins '^E'  end-of-line
bindkey -M viins '^K'  kill-line
bindkey -M viins '^R'  history-incremental-pattern-search-backward
bindkey -M viins '\er' history-incremental-pattern-search-forward
bindkey -M viins '^Y'  yank
bindkey -M viins '^W'  backward-kill-word
bindkey -M viins '^U'  backward-kill-line
bindkey -M viins '^H'  backward-delete-char
bindkey -M viins '^?'  backward-delete-char
bindkey -M viins '^G'  send-break
bindkey -M viins '^D'  delete-char-or-list
bindkey -M viins '^P'  up-line-or-history
bindkey -M viins '^N'  down-line-or-history

# Emacsバインディング（コマンドラインモード）
bindkey -M vicmd '/'   vi-history-search-forward
bindkey -M vicmd '?'   vi-history-search-backward
bindkey -M vicmd 'H'   beginning-of-line
bindkey -M vicmd 'L'   end-of-line

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

# ^O で popd する
function _pop_hist(){
    popd > /dev/null
    zle reset-prompt
}
zle -N _pop_hist
bindkey -M viins "^O" _pop_hist

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
function _ls_files() {
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
zle -N _ls_files
# }}}

####################
#  外部プラグイン  #
####################
# {{{
export ZSHPLUGIN=$DOTZSH/plugins
if [ ! -d $ZSHPLUGIN ]; then
    mkdir -p $ZSHPLUGIN
fi

ZSH_PLUGINS=(
    https://github.com/zsh-users/zsh-syntax-highlighting.git
    https://github.com/zsh-users/zsh-autosuggestions.git
    https://github.com/Tarrasch/zsh-bd.git
)

# プラグインを更新するコマンド
function zsh-plugin-update(){
    local cwd=$PWD

    for plugin_url in $ZSH_PLUGINS; do
        local plugin="${${plugin_url%.git}##*/}"
        local plugin_dir="${ZSHPLUGIN}/${plugin}"

        if [ -d "$plugin_dir" ]; then
            # Update
            echo "Updating ${plugin}..."
            builtin cd "$plugin_dir"
            git pull
        else
            echo "Installing ${plugin}..."
            builtin cd "$ZSHPLUGIN"
            git clone "$plugin_url"
        fi
        echo
    done

    cd "$cwd"
}

# プラグイン読み込み
local plugin_url
for plugin_url in $ZSH_PLUGINS; do
    local plugin="${${plugin_url%.git}##*/}"
    local plugin_file="${ZSHPLUGIN}/${plugin}/${plugin}.zsh"
    local plugin_file2="${ZSHPLUGIN}/${plugin}/${${plugin}##zsh-}.zsh"
    if [ -f "$plugin_file" ]; then
        source "$plugin_file"
    elif [ -f "$plugin_file2" ]; then
        source "$plugin_file2"
    else
        echo "Plugin source not found: ${plugin_file}.  Please install plugin with 'zsh-plugin-update'."
    fi
done

# zsh-autosuggestions {{{
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=241"
# }}}

# }}}

#######################
# Tmux プラグイン管理 #
#######################
# {{{
export DOTTMUX="$HOME/.tmux"
if [ ! -d "$DOTTMUX/plugins/tpm" ]; then
    echo "Tmux plugin manager is not installed.  Please install it with 'install-tpm' command\n"
    function install-tpm() {
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    }
fi
# }}}

##############
#   その他   #
##############
# {{{

# フロー制御の無効化
stty -ixon

# rbenv
if hash rbenv 2> /dev/null; then
    # initialize rbenv
    eval "$(rbenv init -)"
    # rehash rbenv executable file database at [un]installation
    function gem(){
        "$HOME/.rbenv/shims/gem" $*
        if [ "$1" = "install" ] || [ "$1" = "i" ] || [ "$1" = "uninstall" ] || [ "$1" = "uni" ]
        then
            rbenv rehash
            rehash
        fi
    }
fi

# PWD を移動するごとにディレクトリ内のファイルを表示
# ただし，ファイルが多すぎるときは省略する
_ls_abbrev() {
    if [[ $- != *i* ]]; then
        # インタラクティブシェル以外ではスキップする
        return
    fi

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

# Go
if hash go 2> /dev/null; then
    if [ ! -d "$HOME/.go" ]; then
        mkdir -p $HOME/.go
    fi
    export GOPATH=$HOME/.go
    export PATH=$GOPATH/bin:$PATH
fi

# }}}

############
#   Peco   #
############
if hash peco 2> /dev/null; then
# {{{
alias -g P='| peco'
alias -g PX='| peco | xargs'

function peco-pgrep() {
    if [[ $1 == "" ]]; then
        peco=peco
    else
        peco="peco --query \"$1\""
    fi
    ps aux | eval $peco --prompt "\"pgrep >\"" | awk '{ print $2 }'
}
zle -N peco-pgrep

function peco-pkill() {
    if [[ $1 =~ "^-" ]]; then
        QUERY=""            # options only
    else
        QUERY=$1            # with a query
        [[ $# > 0 ]] && shift
    fi
    peco-pgrep $QUERY | xargs kill $*
}
zle -N peco-pkill

function peco-history-insert() {
    local tac
    hash gtac 2> /dev/null && tac="gtac" || { hash tac 2> /dev/null && tac="tac" || { tac="tail -r" } }
    BUFFER=$(fc -l -n 1 | eval $tac | peco  --prompt 'history-insert >' --query "$LBUFFER")
    CURSOR=$#BUFFER         # move cursor
    zle -R -c               # refresh
}
zle -N peco-history-insert

function peco-history() {
    local tac
    hash gtac 2> /dev/null && tac="gtac" || { hash tac 2> /dev/null && tac="tac" || { tac="tail -r" } }
    BUFFER=$(fc -l -n 1 | eval $tac | peco --prompt 'history >' --query "$LBUFFER")
    zle clear-screen
    zle accept-line
}
zle -N peco-history
bindkey -M viins '^ h' peco-history

function peco-cdr-impl() {
    cdr -l | \
        sed -e 's/^[[:digit:]]*[[:blank:]]*//' | \
        peco --prompt 'cdr >' --query "$LBUFFER"
}
function peco-cdr-insert() {
    local selected
    selected=$(cdr -l | sed -e 's/^[[:digit:]]*[[:blank:]]*//' | peco --prompt 'cdr-insert >')
    BUFFER=${BUFFER}${selected}
    CURSOR=$#BUFFER
    zle redisplay
}
zle -N peco-cdr-insert

function peco-cdr() {
    local destination="$(peco-cdr-impl)"
    if [ -n "$destination" ]; then
        BUFFER="cd $destination"
        zle accept-line
    else
        zle reset-prompt
    fi
}
zle -N peco-cdr

function _advanced_tab(){
if [[ $#BUFFER == 0 ]]; then
    peco-cdr
    zle redisplay
else
    zle expand-or-complete
fi
}
zle -N _advanced_tab

bindkey -M viins '^I' _advanced_tab
bindkey -M viins '^ r' peco-cdr

if hash ghq 2> /dev/null; then
    function peco-ghq() {
        local selected_dir=$(ghq list | peco --prompt 'ghq >' --query "$LBUFFER")
        if [ -n "$selected_dir" ]; then
            BUFFER="cd $(ghq root)/${selected_dir}"
            zle accept-line
        fi
        zle clear-screen
    }
    zle -N peco-ghq
    bindkey -M viins '^ ^ ' peco-ghq
fi

if [[ "$GOPATH" != "" ]]; then
    function peco-gopath() {
        local selected=$(find "$GOPATH/src" -maxdepth 3 -mindepth 3 -name "*" -type d | peco --prompt 'GOPATH >' --query "$LBUFFER")
        if [ -n "$selected" ]; then
            BUFFER="cd $selected"
            zle accept-line
        else
            zle reset-prompt
        fi
    }
    zle -N peco-gopath
    bindkey -M viins '^ p' peco-gopath
fi

function peco-repos() {
    local input

    input="$(find "$GOPATH/src" -maxdepth 3 -mindepth 3 -name "*" -type d)"
    input="${input}\n$(ghq list | sed "s#^#$(ghq root)/#")"
    input="${input}\n$(ls -1 -d "$HOME/.vim/bundle/"*)"
    input="${input}\n$(ls -1 -d "$HOME/.cache/dein/repos/"*)"
    input="$(echo "$input" | sed "s#^$HOME#~#g")"

    local selected_dir=$(echo "${input}" | peco --prompt 'repos >' --query "$LBUFFER")
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-repos
bindkey -M viins '^ ^r' peco-repos

function peco-git-log() {
    local sed
    case $OSTYPE in
    darwin*)
        sed="gsed"
        ;;
    linux*)
        sed="sed"
        ;;
    esac

    local commit
    commit=$(git log --no-color --oneline --graph --all --decorate | peco --prompt 'git-log >' | $sed -e "s/^\W\+\([0-9A-Fa-f]\+\).*$/\1/")
    BUFFER="${BUFFER}${commit}"
    CURSOR=$#BUFFER
    zle redisplay
}
zle -N peco-git-log
bindkey -M viins '^ o' peco-git-log

function peco-ls-l-insert(){
    local selected
    selected=$(ls -l | grep -v ^total | peco --prompt 'ls-l-insert >' | awk '{print $(NF)}')
    BUFFER="${BUFFER}$selected"
    CURSOR=$#BUFFER
    zle redisplay
}
zle -N peco-ls-l-insert
bindkey -M viins '^ l' peco-ls-l-insert

function peco-find-insert(){
    local selected
    selected=$(find ./* | peco --prompt 'find-insert >')
    BUFFER="${BUFFER}${selected}"
    CURSOR=$#BUFFER
    zle redisplay
}
zle -N peco-find-insert
bindkey -M viins '^ f' peco-find-insert

function peco-insert(){
    local selected
    selected=$(eval ${BUFFER} | peco --prompt 'insert >')
    BUFFER="${selected}"
    CURSOR=$#BUFFER
    zle redisplay
}
zle -N peco-insert
bindkey -M viins '^ ^M' peco-insert

function peco-neomru-insert() {
    if ! [ -f "$HOME/.cache/neomru/file" ]; then
        return
    fi

    local selected
    selected=$(cat ~/.cache/neomru/{file,directory} | sed "1 d" | peco --prompt 'neomru-insert >')
    BUFFER="$BUFFER$selected"
    CURSOR=$#BUFFER
    zle redisplay
}
zle -N peco-neomru-insert
bindkey -M viins '^ n' peco-neomru-insert

function peco-neomru(){
    if ! [ -f "$HOME/.cache/neomru/file" ]; then
        return
    fi

    local editor
    if [[ "$1" != "" ]]; then
        editor=$1
    elif [[ "$EDITOR" != "" ]]; then
        editor=$EDITOR
    else
        editor="vim"
    fi

    local selected
    selected=$(cat ~/.cache/neomru/{file,directory} | sed "1 d" | peco --prompt 'neomru >')
    if [[ "$selected" != "" ]]; then
        BUFFER="$editor $selected"
        zle accept-line
    fi
}
zle -N peco-neomru
bindkey -M viins '^ n' peco-neomru

function peco-directory-entries() {
    if ! [ -d "$1" ]; then
        return
    fi

    local selected
    selected=$(ls -1 "$1" | peco --prompt "$(basename "$1") >")
    if [[ "$selected" != "" ]]; then
        echo "$1/$selected"
    fi
}

function peco-neobundle(){
    BUFFER="cd $(peco-directory-entries "$HOME/.vim/bundle")"
    zle accept-line
}
zle -N peco-neobundle
bindkey -M viins '^ b' peco-neobundle

function peco-memolist(){
    BUFFER="vim $(peco-directory-entries "$HOME/Dropbox/memo")"
    zle accept-line
}
zle -N peco-memolist
bindkey -M viins '^ ^m' peco-memolist

function peco-man-list-all() {
    local parent dir file
    local paths=("${(s/:/)$(man -aw)}")
    for parent in $paths; do
        for dir in $(/bin/ls -1 $parent); do
            local p="${parent}/${dir}"
            if [ -d "$p" ]; then
                IFS=$'\n' local lines=($(/bin/ls -1 "$p"))
                for file in $lines; do
                    echo "${p}/${file}"
                done
            fi
        done
    done
}

function peco-man() {
    local selected=$(peco-man-list-all | peco --prompt 'man >')
    if [[ "$selected" != "" ]]; then
        man "$selected"
    fi
}
zle -N peco-man
bindkey -M viins '^ m' peco-man

function peco-git-cd() {
    local cdup
    cdup="$(git rev-parse --show-cdup 2>/dev/null)"
    if [[ $? != 0 ]]; then
        zle accept-line
        return
    fi

    local selected="$(git ls-files "$cdup" | grep '/' | sed 's/\/[^\/]*$//g' | sort | uniq | peco --prompt 'git-cd >')"
    if [[ "$selected" != "" ]]; then
        BUFFER="cd $selected"
        zle accept-line
    fi
}
zle -N peco-git-cd
bindkey -M viins '^ g' peco-git-cd

function peco-source(){
    local sources
    local selected_source
    sources=( \
        pgrep \
        pkill \
        history \
        history-insert \
        cdr \
        cdr-insert \
        ghq \
        git-log \
        git-cd \
        gopath \
        ls-l-insert \
        find-insert \
        locate \
        man \
        neomru \
        neomru-insert \
        neobundle \
        repos \
    )
    selected_source=$(echo ${(j/\n/)sources} | peco --prompt 'source >')
    zle clear-screen
    if [[ "$selected_source" != "" ]]; then
        zle peco-${selected_source}
    fi
}
zle -N peco-source
bindkey -M viins '^ ' peco-source

function ag-peco-vim() {
    local grepped
    grepped="$(ag --vimgrep $*)"
    if [[ "$grepped" == "" || "$?" != "0" ]]; then
        echo "Error on ag --vimgrep $*" > 2
        return
    fi

    local selected="$(echo "$grepped" | peco --prompt 'git-grep >')"
    if [[ "$selected" == "" ]]; then
        return
    fi

    # Consider multiline support
    local buf="" line
    while read line; do
        buf="$buf ${line%%:*}"
    done <<< $selected

    # Expose a string variable into arguments
    #   vim 'foo bar' -> vim foo bar
    "$EDITOR" ${=buf}
}
# }}}
fi

##########################################
#   source platform-dependant settings   #
##########################################

case $OSTYPE in
    darwin*)
        # Mac OS {{{
        unalias ls
        alias ls='ls -G'
        alias top='sudo htop'

        if hash grm 2> /dev/null; then
            alias rm=grm
            alias tar=gtar
        fi

        # suffix aliases
        alias -s pdf='open -a Preview'
        alias -s html='open -a Google\ Chrome'

        # global aliases
        alias -g C='| pbcopy'

        #Homebrew
        export HOMEBREW_VERBOSE=true
        export HOMEBREW_EDITOR=vim
        export HOMEBREW_NO_ANALYTICS=1

        # Git
        export PATH=$PATH:/usr/local/opt/git/share/git-core/contrib/diff-highlight
        # }}}
        ;;
    linux*)
        # Linux {{{
        export PACMAN=pacman-color
        export BROWSER=google-chrome:firefox:$BROWSER

        # for Tmux 256 bit color
        if [[ $TERM == "xterm" ]]; then
            export TERM=xterm-256color
        fi

        if hash awesome 2> /dev/null; then
            alias configawesome='vim $HOME/.config/awesome/rc.lua'
        fi

        alias xo=xdg-open

        # suffix alias
        alias -s html=xdg-open

        # global alias
        if hash notify-send 2> /dev/null; then
            alias -g BG=' 2>&1 | notify-send &'
        fi

        if hash xsel 2> /dev/null; then
            alias -g C='| xsel --input --clipboard'
        fi

        # cleverer umount command
        if ! hash um 2> /dev/null; then
            function um(){
                local dirs_in_media
                dirs_in_media=$(ls -l /media/ | grep -e ^d)
                if [[ "$(echo "$dirs_in_media" | wc -l)" == 1 ]]; then
                    local media_dir
                    media_dir=${"$(echo "$dirs_in_media" | head -n 1)"##* }
                    echo -n "unmounting ${media_dir}... "
                    umount $@ /media/"$media_dir"
                    $? && echo "done."
                else
                    umount $@
                fi
            }
        fi
        # }}}
        ;;
esac

source-file $HOME/.local.zshrc
