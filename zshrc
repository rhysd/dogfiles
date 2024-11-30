###############
#   Exports   #
###############
# {{{
export LANG=ja_JP.UTF-8
export EDITOR=vim

export PATH=/usr/local/bin:$PATH

# ワード単位移動の挙動
export WORDCHARS=

if [ -d $HOME/.cargo/bin ]; then
    export PATH=$HOME/.cargo/bin:$PATH
fi

if [ -d $HOME/.opam ]; then
    export PATH=$HOME/.opam/system/bin:$PATH
    # OPAM configuration
    source ~/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
fi

# Note: pipx installs packages in ~/.local
if [ -d $HOME/.local/bin ]; then
    export PATH=$PATH:$HOME/.local/bin
fi

export DOTZSH=$HOME/.zsh
if [ ! -d $DOTZSH ]; then
    mkdir -p $DOTZSH
fi

# デフォルトで venv 以外で pip install できないようにする
# グローバルでインストールしたい時は PIP_REQUIRE_VENV= pip install を使う
export PIP_REQUIRE_VENV=true

# Rust 製プログラムのクラッシュ時バックトレースを常に表示
export RUST_BACKTRACE=1

# `bat` コマンドのカラーテーマ（macOS ではシステムのカラーテーマに合わせられてしまうため）
export BAT_THEME=OneHalfDark

# `hgrep` のデフォルトオプション
export HGREP_DEFAULT_OPTS='--theme ayu-mirage'
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

alias l=ls
alias v=vim
alias gv=gvim
alias n=nvim
alias t=time
alias ng=noglob
alias g=git
alias m=make
alias d=docker
alias nr='npm run'
alias cr='cargo run --'

# global alias
alias -g G='| grep'
alias -g GI='| grep -i'
alias -g L='| less -R'
alias -g V='| vim --not-a-term -R -'
alias -g D='> /dev/null 2>&1'
alias -g X='| xargs'
alias -g XV='| xargs -o | vim --not-a-term'
alias -g SPONGE='> /tmp/zsh-sponge-tmp; cat /tmp/zsh-sponge-tmp >'
alias -g Q='&& exit'

if [[ $TMUX != "" ]]; then
    alias -g BG=' 2>&1 | xargs tmux display-message &'
fi
# }}}

############
#   関数   #
############
# {{{
function kiritori(){
    echo -n $fg_bold[yellow]
    printf '- %.0s' {1..$(($COLUMNS/4-2))}
    echo -n ' ｷﾘﾄﾘｾﾝ '
    printf '- %.0s' {1..$(($COLUMNS/4-2))}
    echo -n $reset_color
    echo
}

function source-file(){
    [[ -s "$1" ]] && source "$1"
}

function pg(){
    ps aux | grep "$1" | grep -v grep
}

function rgfv() {
    # Open selected line in the file with `vim +$LINE $FILE`
    vim $( \
        rg --line-number "$*" | \
        fzf --multi --preview='bat --pager never --color always --highlight-line {2} --line-range {2}: --style=plain {1}' --delimiter=: | \
        awk -F : '{print "+"$2" "$1}' \
    )
}
# }}}

####################
#  補完定義の管理  #
####################
# {{{
function zsh-update-comp-defs() {
    local links urls comps file fname

    comps="$DOTZSH/site-functions"
    urls=(
        https://raw.githubusercontent.com/zsh-users/zsh-completions/master/src/_golang
        https://raw.githubusercontent.com/zsh-users/zsh-completions/master/src/_node
        https://raw.githubusercontent.com/zsh-users/zsh-completions/master/src/_cmake
        https://raw.githubusercontent.com/zsh-users/zsh-completions/master/src/_bundle
        https://raw.githubusercontent.com/zsh-users/zsh-completions/master/src/_ghc
        https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker
        https://raw.githubusercontent.com/docker/compose/master/contrib/completion/zsh/_docker-compose
        https://raw.githubusercontent.com/x-motemen/ghq/master/misc/zsh/_ghq
        https://raw.githubusercontent.com/alacritty/alacritty/master/extra/completions/_alacritty
        https://raw.githubusercontent.com/rhysd/notes-cli/master/completions/zsh/_notes
    )

    for url in $urls; do
        fname="${url:t}"
        if [[ "$fname" == "alacritty-completions.zsh" ]]; then
            fname="_alacritty"
        fi
        file="$comps/$fname"
        echo "Downloading complation definition '${file}'"
        if curl -f -L "$url" > "$file"; then
            chmod +x "$file"
        else
            echo "Failed to download ${url}"
            rm -rf $file
        fi
        echo
    done

    if which rustup > /dev/null; then
        echo "Setting up completion definitions for rust toolchain"
        rustup completions zsh > "$comps/_rustup" && chmod +x "$comps/_rustup"

        local toolchain
        toolchain="$(rustup toolchain list | grep ' (default)')"
        toolchain="${toolchain%% \(default\)}"
        if [[ "$toolchain" != "" ]]; then
            rm -rf "$comps/_cargo"
            ln -s "$HOME/.rustup/toolchains/$toolchain/share/zsh/site-functions/_cargo" "$comps/_cargo"
        fi
    fi

    if which hgrep > /dev/null; then
        echo "Setting up completion definitions for hgrep"
        hgrep --generate-completion-script zsh > "$comps/_hgrep"
        chmod +x "$comps/_hgrep"
    fi
}

if [ ! -d "$DOTZSH/site-functions" ]; then
    mkdir "$DOTZSH/site-functions"
    zsh-update-comp-defs
fi

# ユーザ定義補完のパス追加 (compinit より前に必要)
fpath=("$DOTZSH/site-functions" ${fpath})
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

# エイリアス時にも補完できるようにする
compdef _git g=git
compdef _docker d=docker
compdef _hgrep h=hgrep
compdef _vim v=vim
compdef _make m=make
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
MY_PROMPT_VCS='$(vcs_info_precmd)'
MY_NEWLINE=$'\n'
MY_INS_PROMPT="%{$fg_bold[green]%}%~%{$reset_color%}${MY_NEWLINE}%{$terminfo_down_sc$MY_PROMPT_VCS$terminfo[rc]%}%{$fg_bold[green]%}U%(?,'w',;w;))%{$reset_color%} { "
MY_NORM_PROMPT="%{$fg_bold[yellow]%}%~%{$reset_color%}${MY_NEWLINE}%{$terminfo_down_sc$MY_PROMPT_VCS$terminfo[rc]%}%{$fg_bold[yellow]%}U%(?,'w',;w;))%{$reset_color%} { "
PROMPT="$MY_INS_PROMPT"

# 右プロンプト
RPROMPT="[%{$fg[yellow]%}${HOST}%{$reset_color%}][%{$fg[yellow]%}%D{%m/%d %H:%M}%{$reset_color%}]"

# モードでプロンプトの色を変える
# XXX: vicmd で ^M や ^C 押下時に insert モードに入っても色が戻らない
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) PROMPT="$MY_NORM_PROMPT";;
        main) PROMPT="$MY_INS_PROMPT";;
        viins) PROMPT="$MY_INS_PROMPT";;
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
export ZSH_PLUGIN_DIR=$DOTZSH/plugins
if [ ! -d $ZSH_PLUGIN_DIR ]; then
    mkdir -p $ZSH_PLUGIN_DIR
fi

# Note: zsh-syntax-highlighting must be at the last.
# https://github.com/zsh-users/zsh-syntax-highlighting#why-must-zsh-syntax-highlightingzsh-be-sourced-at-the-end-of-the-zshrc-file
ZSH_PLUGINS=(
    https://github.com/zsh-users/zsh-autosuggestions.git
    https://github.com/Tarrasch/zsh-bd.git
    https://github.com/zsh-users/zsh-syntax-highlighting.git
)

# プラグインを更新するコマンド
function zsh-plugin-update() {
    local cwd=$PWD

    local plugin_url
    for plugin_url in $ZSH_PLUGINS; do
        local plugin="${${plugin_url%.git}##*/}"
        local plugin_dir="${ZSH_PLUGIN_DIR}/${plugin}"

        if [ -d "$plugin_dir" ]; then
            # Update
            echo "Updating ${plugin}..."
            chpwd_functions= builtin cd "$plugin_dir"
            git pull
        else
            echo "Installing ${plugin}..."
            chpwd_functions= builtin cd "$ZSH_PLUGIN_DIR"
            git clone "$plugin_url"
        fi
        echo
    done

    chpwd_functions= builtin cd "$cwd"
}

# プラグイン読み込み
function zsh-plugin-load() {
    local plugin_url
    for plugin_url in $ZSH_PLUGINS; do
        local plugin="${${plugin_url%.git}##*/}"
        local plugin_file="${ZSH_PLUGIN_DIR}/${plugin}/${plugin}.zsh"  # zsh-foo/zsh-foo.zsh
        local plugin_file2="${ZSH_PLUGIN_DIR}/${plugin}/${${plugin}##zsh-}.zsh"  # zsh-foo/foo.zsh
        local plugin_file3="${ZSH_PLUGIN_DIR}/${plugin}/${plugin}"  # foo.zsh/foo.zsh
        if [ -f "$plugin_file" ]; then
            source "$plugin_file"
        elif [ -f "$plugin_file2" ]; then
            source "$plugin_file2"
        elif [ -f "$plugin_file3" ]; then
            source "$plugin_file3"
        else
            echo "Plugin source not found: ${plugin_file}.  Please install plugin with 'zsh-plugin-update'."
        fi
    done
}
zsh-plugin-load

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

# notes-cli
if [ -d "$HOME/Dropbox/notes" ]; then
    export NOTES_CLI_HOME="$HOME/Dropbox/notes"
else
    export NOTES_CLI_HOME="$HOME/.vim/notes"
fi
export NOTES_CLI_EDITOR="vim"
# }}}

###############
#   FILTER    #
###############
export FZF_DEFAULT_OPTS="--layout=reverse --bind=ctrl-t:toggle-preview"
if hash fzf 2> /dev/null; then
# {{{
alias -g F="| fzf"
alias -g FX="| fzf | xargs"

function filter-pgrep() {
    if [[ $1 == "" ]]; then
        filter="fzf"
    else
        filter="fzf --query \"$1\""
    fi
    ps aux | eval fzf --prompt "\"pgrep> \"" | awk '{ print $2 }'
}
zle -N filter-pgrep

function filter-pkill() {
    if [[ $1 =~ "^-" ]]; then
        QUERY=""            # options only
    else
        QUERY=$1            # with a query
        [[ $# > 0 ]] && shift
    fi
    filter-pgrep $QUERY | xargs kill $*
}
zle -N filter-pkill

function filter-history-insert() {
    local tac
    hash gtac 2> /dev/null && tac="gtac" || { hash tac 2> /dev/null && tac="tac" || { tac="tail -r" } }
    BUFFER=$(fc -l -n 1 | eval $tac | fzf  --prompt 'history-insert> ' --query "$LBUFFER")
    CURSOR=$#BUFFER         # move cursor
    zle -R -c               # refresh
}
zle -N filter-history-insert

function filter-history() {
    local tac
    hash gtac 2> /dev/null && tac="gtac" || { hash tac 2> /dev/null && tac="tac" || { tac="tail -r" } }
    BUFFER=$(fc -l -n 1 | eval $tac | fzf --prompt 'history> ' --query "$LBUFFER")
    zle clear-screen
    zle accept-line
}
zle -N filter-history
bindkey -M viins '^ h' filter-history

function filter-cdr-impl() {
    cdr -l | \
        sed -e 's/^[[:digit:]]*[[:blank:]]*//' | \
        fzf --prompt 'cdr> ' --query "$LBUFFER"
}
function filter-cdr-insert() {
    local selected
    selected=$(cdr -l | sed -e 's/^[[:digit:]]*[[:blank:]]*//' | fzf --prompt 'cdr-insert> ')
    BUFFER=${BUFFER}${selected}
    CURSOR=$#BUFFER
    zle redisplay
}
zle -N filter-cdr-insert

function filter-cdr() {
    local destination="$(filter-cdr-impl)"
    if [ -n "$destination" ]; then
        BUFFER="cd $destination"
        zle accept-line
    else
        zle reset-prompt
    fi
}
zle -N filter-cdr

function _advanced_tab(){
if [[ $#BUFFER == 0 ]]; then
    filter-cdr
    zle redisplay
else
    zle expand-or-complete
fi
}
zle -N _advanced_tab

bindkey -M viins '^I' _advanced_tab
bindkey -M viins '^ r' filter-cdr

if hash ghq 2> /dev/null; then
    function filter-ghq() {
        local selected_dir=$(ghq list | fzf --prompt 'ghq> ' --query "$LBUFFER")
        if [ -n "$selected_dir" ]; then
            BUFFER="cd $(ghq root)/${selected_dir}"
            zle accept-line
        fi
        zle clear-screen
    }
    zle -N filter-ghq
    bindkey -M viins '^ ^g' filter-ghq
fi

if [[ "$GOPATH" != "" ]]; then
    function filter-gopath() {
        local selected=$(find "$GOPATH/src" -maxdepth 3 -mindepth 3 -name "*" -type d | fzf --prompt 'GOPATH> ' --query "$LBUFFER")
        if [ -n "$selected" ]; then
            BUFFER="cd $selected"
            zle accept-line
        else
            zle reset-prompt
        fi
    }
    zle -N filter-gopath
    bindkey -M viins '^ p' filter-gopath
fi

function filter-repos() {
    local input go vim

    input="$(ghq list | sed "s#^#$(ghq root)/#")"
    go="$(find "$GOPATH/src" -maxdepth 3 -mindepth 3 -name "*" -type d)"
    if [ -n "$go" ]; then
        input="${input}\n${go}"
    fi
    vim="$(ls -1 -d "$HOME/.vim/bundle/"*)"
    if [ -n "$vim" ]; then
        input="${input}\n${vim}"
    fi
    input="$(echo "$input" | sed "s#^$HOME#~#g")"

    local selected_dir=$(echo "${input}" | fzf --prompt 'repos> ' --query "$LBUFFER")
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N filter-repos
bindkey -M viins '^ ^ ' filter-repos

function filter-git-log() {
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
    commit=$(git log --no-color --oneline --graph --all --decorate | fzf --prompt 'git-log> ' | $sed -e "s/^\W\+\([0-9A-Fa-f]\+\).*$/\1/")
    BUFFER="${BUFFER}${commit}"
    CURSOR=$#BUFFER
    zle redisplay
}
zle -N filter-git-log
bindkey -M viins '^ o' filter-git-log

function filter-ls-l-insert(){
    local selected
    selected=$(ls -l | grep -v ^total | fzf --prompt 'ls-l-insert> ' | awk '{print $(NF)}')
    BUFFER="${BUFFER}$selected"
    CURSOR=$#BUFFER
    zle redisplay
}
zle -N filter-ls-l-insert
bindkey -M viins '^ l' filter-ls-l-insert

function filter-find-insert(){
    local selected
    selected=$(find ./* | fzf --prompt 'find-insert> ')
    BUFFER="${BUFFER}${selected}"
    CURSOR=$#BUFFER
    zle redisplay
}
zle -N filter-find-insert
bindkey -M viins '^ f' filter-find-insert

function filter-directory-entries() {
    if ! [ -d "$1" ]; then
        return
    fi

    local selected
    selected=$(ls -1 "$1" | fzf --prompt "$(basename "$1")> ")
    if [[ "$selected" != "" ]]; then
        echo "$1/$selected"
    fi
}

function filter-neobundle(){
    BUFFER="cd $(filter-directory-entries "$HOME/.vim/bundle")"
    zle accept-line
}
zle -N filter-neobundle
bindkey -M viins '^ b' filter-neobundle

function filter-man-list-all() {
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

function filter-man() {
    local selected=$(filter-man-list-all | fzf --prompt 'man> ')
    if [[ "$selected" != "" ]]; then
        man "$selected"
    fi
}
zle -N filter-man
bindkey -M viins '^ m' filter-man

function filter-git-cd() {
    local cdup
    cdup="$(git rev-parse --show-cdup 2>/dev/null)"
    if [[ $? != 0 ]]; then
        zle accept-line
        return
    fi

    local selected="$(git ls-files "$cdup" | grep '/' | sed 's/\/[^\/]*$//g' | sort | uniq | fzf --prompt 'git-cd> ')"
    if [[ "$selected" != "" ]]; then
        BUFFER="cd $selected"
        zle accept-line
    fi
}
zle -N filter-git-cd
bindkey -M viins '^ g' filter-git-cd

function filter-source(){
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
        neobundle \
        repos \
    )
    selected_source=$(echo ${(j/\n/)sources} | fzf --prompt 'source> ')
    zle clear-screen
    if [[ "$selected_source" != "" ]]; then
        zle filter-${selected_source}
    fi
}
zle -N filter-source
bindkey -M viins '^ ' filter-source
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
        alias safari='open -a Safari'

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
        export HOMEBREW_NO_AUTO_UPDATE=1

        # Git
        export PATH=$PATH:/usr/local/opt/git/share/git-core/contrib/diff-highlight

        # pipx home is set to `~/Library/Application Support` by default but containing spaces in path is problematic.
        # To avoid troubles, install venvs for packages under `~/.local/pipx` instead.
        export PIPX_HOME=$HOME/.local/pipx
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

# Prevent a dog from crying at start up!
true
