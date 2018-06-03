" 必須な基本設定 {{{
" tiny と small では vimrc を読み込まない
if !1 | finish | endif

"エンコーディング
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,cp932,euc-jp

scriptencoding utf-8

" This is vim, not vi.
if &compatible
    set nocompatible
endif

function! s:get_SID() abort
    return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeget_SID$')
endfunction
let s:SID = s:get_SID()
delfunction s:get_SID

" Vimrc augroup
augroup MyVimrc
    autocmd!
augroup END
command! -nargs=+ Autocmd autocmd MyVimrc <args>
command! -nargs=+ AutocmdFT autocmd MyVimrc FileType <args>
Autocmd VimEnter,WinEnter .vimrc,.gvimrc,vimrc,gvimrc syn keyword myVimAutocmd Autocmd AutocmdFT contained containedin=vimIsCommand
Autocmd ColorScheme * highlight def link myVimAutocmd vimAutoCmd

" user-defined prefix
let g:mapleader = ','
"バックアップファイルいらない
set nobackup
" 言語設定
language message C
language time C
"自動インデント
set autoindent
"タブが対応する空白の数
set tabstop=4 shiftwidth=4 softtabstop=4
" インデントを shiftwidth の倍数に丸める
set shiftround
"タブの代わりにスペースを使う
set expandtab
AutocmdFT neosnippet,gitconfig setlocal noexpandtab
"長い行で折り返す
set wrap
"ウィンドウの横幅をなるべく30文字以上に
set winwidth=30
"検索が末尾まで進んだら，ファイル先頭につなげる
set wrapscan
"対応する括弧にわずかの間ジャンプする
set showmatch
"カーソルが何行何列目にあるか表示する
set ruler
"最下ウィンドウにステータス行が表示される時
"1: ウィンドウの数が2以上 2:常
set laststatus=2
"スクロール時の余白確保
set scrolloff=5
"いろいろスマート
set smarttab
set cindent
"大文字が入っている時のみ大文字小文字を区別
set ignorecase
set smartcase
"ビープ音OFF
set vb t_vb=
"ホワイトスペース類を表示する
set list
"起動時のメッセージを消す
set shortmess& shortmess+=I
"IMを使う
set noimdisable
"起動時IMEをOFFにする
set iminsert=0 imsearch=0
" 検索結果をハイライト
set hlsearch
" インクリメンタルなマッチング
set incsearch
"コマンドラインでのIM無効化
set noimcmdline
" コマンドラインで cmd window を出すキー
set cedit=<C-c>
"バックスペースでなんでも消せるように
set backspace=indent,eol,start
" 改行時にコメントしない
set formatoptions-=r
set formatoptions-=o
" 行継続で勝手にインデントしない
" let g:vim_indent_cont = 0
" 8進数インクリメントをオフにする
set nrformats-=octal
"ファイル切替時にファイルを隠す
set hidden
"日本語ヘルプを優先的に検索
set helplang=ja,en
" カーソル下の単語を help で調べる
set keywordprg=:help
"OSのクリップボードを使う
set clipboard=unnamed
"矩形選択で自由に移動する
set virtualedit& virtualedit+=block
"改行コードの自動認識
set fileformats=unix,dos,mac
"行を折り返さない
set textwidth=0
"コマンド表示いらない
set noshowcmd
"コマンド実行中は再描画しない
set lazyredraw
" 自前で用意したものへの path
set path=.,/usr/include,/usr/local/include
" 補完でプレビューウィンドウを開かない
set completeopt=menuone,menu
" メニューの言語
set langmenu=none
" foldingの設定
set foldenable
set foldmethod=marker
" マルチバイト文字があってもカーソルがずれないようにする
set ambiwidth=double
" 読み込んでいるファイルが変更された時自動で読み直す
set autoread
" h と l で行を跨げるようにする
set whichwrap +=h
set whichwrap +=l
" コマンド履歴サイズ
set history=100
" コマンドラインモードの補完を拡張
set wildmenu
" swap ファイル
if ! isdirectory($HOME.'/.vim/swap')
    call mkdir($HOME.'/.vim/swap', 'p')
endif
set directory=~/.vim/swap
" 編集履歴を保存して終了する
if has('persistent_undo')
    if ! isdirectory($HOME.'/.vim/undo')
        call mkdir($HOME.'/.vim/undo', 'p')
    endif
    set undodir=~/.vim/undo
    set undofile
endif
" command-line-window の縦幅
set cmdwinheight=3
" ステータスライン
set rulerformat=%45(%12f%=\ %m%{'['.(&fenc!=''?&fenc:&enc).']'}\ %l-%v\ %p%%\ [%02B]%)
set statusline=%f:\ %{substitute(getcwd(),'.*/','','')}\ %m%=%{(&fenc!=''?&fenc:&enc).':'.strpart(&ff,0,1)}\ %l-%v\ %p%%\ %02B
" リストヘッダ
set formatlistpat&
let &formatlistpat .= '\|^\s*[*+-]\s*'
" spell チェックで日本語をチェックしない
set spelllang=en,cjk
" 折り返しでインデントを保持
if exists('+breakindent')
    set breakindent
    set breakindentopt=shift:-4
    let &showbreak = '>>> '
endif
" 一時ディレクトリではバックアップを取らない
set backupskip=/tmp/*,/private/tmp/*

if has('vim_starting')
    " インサートモード時に非点滅の縦棒タイプのカーソル
    let &t_SI .= "\e[6 q"
    " ノーマルモード時に非点滅のブロックタイプのカーソル
    let &t_EI .= "\e[2 q"
    " 置換モード時に非点滅の下線タイプのカーソル
    let &t_SR .= "\e[4 q"
endif

" 一定時間カーソルを移動しないとカーソルラインを表示（ただし，ウィンドウ移動時
" はなぜか切り替わらない
" http://d.hatena.ne.jp/thinca/20090530/1243615055
Autocmd CursorMoved,CursorMovedI,WinLeave * setlocal nocursorline
Autocmd CursorHold,CursorHoldI,WinEnter * setlocal cursorline

" git config file
Autocmd BufRead,BufNew,BufNewFile gitconfig setlocal ft=gitconfig
" Gnuplot のファイルタイプを設定
Autocmd BufRead,BufNew,BufNewFile *.plt,*.plot,*.gnuplot setlocal ft=gnuplot
" Ruby の guard 用ファイル
Autocmd BufRead,BufNew,BufNewFile Guardfile setlocal ft=ruby
" Go
Autocmd BufRead,BufNew,BufNewFile *_test.go setlocal ft=go.test
" Swift
Autocmd BufRead,BufNew,BufNewFile *.swift setlocal ft=swift
" Mal,Crisp
Autocmd BufRead,BufNew,BufNewFile *.mal,*.crisp setlocal ft=lisp
" JavaScript JSX
Autocmd BufRead,BufNew,BufNewFile *.jsx setlocal ft=javascript.jsx
" TypeScript JSX
Autocmd BufRead,BufNew,BufNewFile *.tsx setlocal ft=typescript.jsx
" JavaScript tests
Autocmd BufRead,BufNew,BufNewFile *_test.js,*_test.jsx setlocal ft=javascript.test
" Vader
Autocmd BufRead,BufNew,BufNewFile *.vader setlocal ft=vader

" カーソル位置の復元
Autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
" Hack #202: 自動的にディレクトリを作成する
" http://vim-users.jp/2011/02/hack202/
Autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
function! s:auto_mkdir(dir, force) abort
    if !isdirectory(a:dir) && (a:force ||
                \    input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
        " call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
        call mkdir(a:dir, 'p')
    endif
endfunction
" git commit message のときは折りたたまない(diff で中途半端な折りたたみになりがち)
" git commit message のときはスペルをチェックする
AutocmdFT gitcommit setlocal nofoldenable spell
AutocmdFT diff setlocal nofoldenable

" tmux 用の設定
"256 bitカラーモード(for tmux)
if !has('gui_running') && $TMUX !=# ''
    set t_Co=256
endif

" カーソル下のハイライトグループを取得
command! -nargs=0 GetHighlightingGroup
            \ echo 'hi<' . synIDattr(synID(line('.'),col('.'),1),'name') . '>trans<'
            \ . synIDattr(synID(line('.'),col('.'),0),'name') . '>lo<'
            \ . synIDattr(synIDtrans(synID(line('.'),col('.'),1)),'name') . '>'


" スクリプトに実行可能属性を自動で付ける
if executable('chmod')
    Autocmd BufWritePost * call s:add_permission_x()

    function! s:add_permission_x() abort
        let file = expand('%:p')
        if getline(1) =~# '^#![^[]' && !executable(file)
            silent! call vimproc#system('chmod a+x ' . shellescape(file))
        endif
    endfunction
endif

augroup InitialMessage
    autocmd!
    " 起動時メッセージ．ｲﾇｩ…
    autocmd VimEnter * echo "(U'w') enjoy vimming!"
augroup END

" 一時ウィンドウを閉じる "{{{
function! s:close_temp_windows() abort
    let target_filetype = ['unite']
    let target_buftype  = ['help', 'quickfix', 'nofile', 'terminal']

    let wins = []
    let winnr = winnr('$')
    while winnr > 0
        let bufnr = winbufnr(winnr)
        if index(target_filetype, getbufvar(bufnr, '&filetype')) >= 0 ||
                \ index(target_buftype, getbufvar(bufnr, '&buftype')) >= 0
            call add(wins, winnr)
        endif
        let winnr -= 1
    endwhile

    if empty(wins)
        return
    endif

    let prev_winnr = winnr()

    try
        for winnr in wins
            if winbufnr(winnr) != -1
                " Note:
                " This 'if' statement is necessary because command-line window
                " does not allow to use :execute in its window. When current
                " window is command-line window, it can be closed properly by
                " skipping the :execute.
                if winnr() != winnr
                    execute winnr . 'wincmd w'
                endif
                wincmd c
            endif
        endfor
    finally
        " Back to previous window.
        if winnr() !=# prev_winnr && winbufnr(prev_winnr) !=# -1
            execute prev_winnr . 'wincmd w'
        endif
    endtry
endfunction

nnoremap <silent><C-q> :<C-u>call <SID>close_temp_windows()<CR>
"}}}

" vimrc を開く
command! Vimrc call s:edit_myvimrc()
function! s:edit_myvimrc() abort
    let ghq_root = expand(substitute(system('git config ghq.root'), '\n$', '', ''))
    let dotfiles = ghq_root . '/github.com/rhysd/dogfiles/'
    if isdirectory(dotfiles)
        let vimrc = dotfiles . 'vimrc*'
        let gvimrc = dotfiles .'gvimrc*'
    else
        let vimrc = $MYVIMRC
        let gvimrc = $MYGVIMRC
    endif

    let files = ''
    if vimrc !=# ''
        let files .= substitute(expand(vimrc), '\n', ' ', 'g')
    endif
    if gvimrc !=# ''
        let files .= substitute(expand(gvimrc), '\n', ' ', 'g')
    endif

    execute 'args ' . files
endfunction

" カレントパスをクリプボゥにコピー
command! CopyCurrentPath :call s:copy_current_path()
function! s:copy_current_path() abort
    if has('win32') || has('win64')
        let c = substitute(expand('%:p'), '\\/', '\\', 'g')
    elseif has('unix')
        let c = expand('%:p')
    endif

    if &clipboard =~# 'plus$'
        let @+ = c
    else
        let @* = c
    endif
endfunction

" エンコーディング指定オープン
command! -bang -complete=file -nargs=? Utf8 edit<bang> ++enc=utf-8 <args>
command! -bang -complete=file -nargs=? Sjis edit<bang> ++enc=cp932 <args>
command! -bang -complete=file -nargs=? Euc edit<bang> ++enc=eucjp <args>

" 縦幅と横幅を見て help の開き方を決める
command! -nargs=* -complete=help SmartHelp call <SID>smart_help(<q-args>)
nnoremap <silent><Leader>h :<C-u>SmartHelp<Space><C-l>
function! s:smart_help(args) abort
    try
        if winwidth(0) > winheight(0) * 2
            " 縦分割
            execute 'vertical topleft help ' . a:args
        else
            execute 'aboveleft help ' . a:args
        endif
    catch /^Vim\%((\a\+)\)\=:E149/
        echohl ErrorMsg
        echomsg 'E149: Sorry, no help for ' . a:args
        echohl None
        return
    endtry
    " 横幅を確保できないときはタブで開く
    if winwidth(0) < 80
        quit
        execute 'tab help ' . a:args
    endif
    silent! AdjustWindowWidth --direction=shrink
endfunction

" インデント
command! -bang -nargs=1 SetIndent
            \ execute <bang>0 ? 'set' : 'setlocal'
            \         'tabstop=' . <q-args>
            \         'shiftwidth=' . <q-args>
            \         'softtabstop=' . <q-args>

" 文字数カウント
command! -nargs=0 Wc %s/.//nge

" コンマピリオド置き換え
command! -nargs=0 ReplaceCommaPeriod %s/，/、/g | %s/．/。/g

" 基本マッピング {{{
" ; と : をスワップ
noremap ; :
if has('cmdline_hist')
    " コマンドラインウィンドウを使う
    " Note:
    "   noremap <Leader>; q:i は使えない
    "   マクロ記録中に q を記録終了に食われてしまう
    "   eval() にそのまま通すのは怖いので事前に &cedit をチェック
    noremap <silent><expr><Leader>; &cedit =~# '^<C-\a>$' ? ':'.eval('"\'.&cedit.'"').'i' : ':'
else
    noremap <Leader>; q:i
endif
noremap @; @:
noremap @: @;
"モードから抜ける
inoremap <expr> j getline('.')[col('.') - 2] ==# 'j' ? "\<BS>\<ESC>" : 'j'
cnoremap <expr> j getcmdline()[getcmdpos() - 2] ==# 'j' ? "\<BS>\<ESC>" : 'j'
" <C-c> も Esc と同じ抜け方にする
inoremap <C-c> <Esc>
" Yの挙動はy$のほうが自然
nnoremap Y y$
" 縦方向は論理移動する
noremap j gj
noremap k gk
" 空行単位移動
nnoremap <silent><C-j> :<C-u>keepjumps normal! }<CR>
nnoremap <silent><C-k> :<C-u>keepjumps normal! {<CR>
vnoremap <C-j> }
vnoremap <C-k> {
" インサートモードに入らずに1文字追加
nnoremap <silent><expr>m 'i'.nr2char(getchar())."\<Esc>"
" gm にマーク機能を退避
noremap gm m
"Esc->Escで検索結果とエラーハイライトをクリア
nnoremap <silent><Esc><Esc> :<C-u>nohlsearch<CR>
"{数値}<Tab>でその行へ移動．それ以外だと通常の<Tab>の動きに
function! s:go_to_line() abort
    set number
    augroup vimrc-go-to-line
        autocmd!
        autocmd InsertEnter,CursorHold * set nonumber | autocmd! vimrc-go-to-line
    augroup END
    return 'G'
endfunction
noremap <expr><Tab> v:count != 0 ? <SID>go_to_line() : "\<Tab>zvzz"
" コマンドラインウィンドウ
" 検索後画面の中心に。
nnoremap n nzvzz
nnoremap N Nzvzz
nnoremap * *zvzz
nnoremap # *zvzz
" 空行挿入
function! s:cmd_cr_n(count) abort
    for _ in range(a:count)
        call append('.', '')
    endfor
    execute 'normal!' a:count.'j'
endfunction
nnoremap <silent><CR> :<C-u>call <SID>cmd_cr_n(v:count1)<CR>
" スペースを挿入
nnoremap <C-Space> i<Space><Esc><Right>
"Emacsライクなバインディング．ポップアップが出ないように移動．
inoremap <C-e> <END>
vnoremap <C-e> <END>
cnoremap <C-e> <END>
inoremap <C-a> <HOME>
vnoremap <C-a> <HOME>
cnoremap <C-a> <HOME>
inoremap <silent><expr><C-n> pumvisible() ? "\<C-y>\<Down>" : "\<Down>"
inoremap <silent><expr><C-p> pumvisible() ? "\<C-y>\<Up>" : "\<Up>"
inoremap <silent><expr><C-b> pumvisible() ? "\<C-y>\<Left>" : "\<Left>"
inoremap <silent><expr><C-f> pumvisible() ? "\<C-y>\<Right>" : "\<Right>"
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
inoremap <C-d> <Del>
cnoremap <expr><C-d> len(getcmdline()) == getcmdpos()-1 ? "\<C-d>" : "\<Del>"
" Emacsライク<C-k> http//vim.g.hatena.ne.jp/tyru/20100116
inoremap <silent><expr><C-k> "\<C-g>u".(col('.') == col('$') ? '<C-o>gJ' : '<C-o>D')
cnoremap <C-k> <C-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos()-2]<CR>
" クリップボードから貼り付け
cnoremap <C-y> <C-r>+
" キャンセル
cnoremap <C-g> <C-u><BS>
"バッファ切り替え
nnoremap <silent><C-n>   :<C-u>bnext<CR>
nnoremap <silent><C-p>   :<C-u>bprevious<CR>
" <C-w> -> s
nmap s <C-w>
" 現在のウィンドウのみを残す
nnoremap <C-w>O <C-w>o
" バッファを削除
function! s:delete_current_buf() abort
    let bufnr = bufnr('%')
    bnext
    if bufnr == bufnr('%') | enew | endif
    silent! bdelete! #
endfunction
nnoremap <C-w>d :<C-u>call <SID>delete_current_buf()<CR>
nnoremap <C-w>D :<C-u>bdelete<CR>
"インサートモードで次の行に直接改行
inoremap <C-j> <Esc>o
"<BS>の挙動
nnoremap <BS> diw
" x でレジスタを使わない
nnoremap x "_x
" カーソルキーでのウィンドウサイズ変更
nnoremap <silent><Down>  <C-w>-
nnoremap <silent><Up>    <C-w>+
nnoremap <silent><Left>  <C-w><
nnoremap <silent><Right> <C-w>>
" ペーストした文字列をビジュアルモードで選択
nnoremap <expr>gp '`['.strpart(getregtype(),0,1).'`]'
" 最後にヤンクしたテキストを貼り付け．
nnoremap P "0P
" indent を下げる
inoremap <C-q> <C-d>
" タブの設定
nnoremap ge :<C-u>tabedit<Space>
nnoremap gn :<C-u>tabnew<CR>
nnoremap <silent>gx :<C-u>tabclose<CR>
nnoremap <silent><A-h> gT
nnoremap <silent><A-l> gt
" クリップボードから貼り付け
inoremap <C-r>+ <C-o>:set paste<CR><C-r>+<C-o>:set nopaste<CR>
" コンマ後には空白を入れる
inoremap , ,<Space>
" 賢く行頭・非空白行頭・行末の移動
nnoremap M g^
nnoremap <silent>H :<C-u>call <SID>move_backward_by_step()<CR>
nnoremap <silent>L :<C-u>call <SID>move_forward_by_step()<CR>
vnoremap M g^
vnoremap M g^
vnoremap H g0
vnoremap L g$
nnoremap gM ^
nnoremap gH 0
nnoremap gL $
vnoremap gM ^
vnoremap gH 0
vnoremap gL $
" スクリーン内移動
nnoremap gh H
nnoremap gl L
nnoremap gm M
vnoremap gh H
vnoremap gl L
vnoremap gm M
" スペルチェック
nnoremap <Leader>s :<C-u>setl spell! spell?<CR>
" 行番号
nnoremap <Leader>nn :<C-u>setl number! number?<CR>
" カーソル付近の文字列で検索（新規ウィンドウ）
nnoremap <C-w>* <C-w>s*
nnoremap <C-w># <C-w>s#
nnoremap <silent><C-w>h :<C-u>call <SID>jump_window_wrapper('h', 'l')<CR>
nnoremap <silent><C-w>j :<C-u>call <SID>jump_window_wrapper('j', 'k')<CR>
nnoremap <silent><C-w>k :<C-u>call <SID>jump_window_wrapper('k', 'j')<CR>
nnoremap <silent><C-w>l :<C-u>call <SID>jump_window_wrapper('l', 'h')<CR>

function! s:jump_window_wrapper(cmd, fallback) abort
    let old = winnr()
    execute 'normal!' "\<C-w>" . a:cmd

    if old == winnr()
        execute 'normal!' "999\<C-w>" . a:fallback
    endif
endfunction

" 連結時にスペースを入れない
function! s:cmd_gJ() abort
    normal! J
    if getline('.')[col('.')-1] ==# ' '
        normal! "_x
    endif
endfunction
nnoremap gJ :<C-u>call <SID>cmd_gJ()<CR>
" コマンドラインウィンドウ設定
function! s:cmdline_window_settings() abort
    " コマンドラインウィンドウを閉じられるようにする
    nnoremap <silent><buffer>q          :<C-u>q<CR>
    nnoremap <silent><buffer><Esc>      :<C-u>q<CR>
    nnoremap <silent><buffer><Esc><Esc> :<C-u>q<CR>
    inoremap <silent><buffer><C-g>      <Esc>:q<CR>
    nnoremap <silent><buffer><CR>       A<CR>
endfunction
Autocmd CmdwinEnter * call s:cmdline_window_settings()
" 対応する括弧間の移動
nmap 0 %
" タブ文字を入力
inoremap <C-Tab> <C-v><Tab>
" 畳み込みを開く
nnoremap <expr>h col('.') == 1 && foldlevel(line('.')) > 0 ? 'zc' : 'h'
nnoremap <expr>l foldclosed(line('.')) != -1 ? 'zo' : 'l'
" colorcolumn
nnoremap <expr><Leader>cl ":\<C-u>set colorcolumn=".(&cc == 0 ? v:count == 0 ? col('.') : v:count : 0)."\<CR>"

" help のマッピング
function! s:on_FileType_help_define_mappings() abort
    if &l:readonly
        " カーソル下のタグへ飛ぶ
        nnoremap <buffer>J <C-]>
        " 戻る
        nnoremap <buffer>K <C-t>
        " リンクしている単語を選択する
        nnoremap <buffer><silent><Tab> /\%(\_.\zs<Bar>[^ ]\+<Bar>\ze\_.\<Bar>CTRL-.\<Bar><[^ >]\+>\)<CR>
        " そのた
        nnoremap <buffer>u <C-u>
        nnoremap <buffer>d <C-d>
        nnoremap <buffer>q :<C-u>q<CR>
    endif
endfunction
AutocmdFT help call s:on_FileType_help_define_mappings()

" quickfix のマッピング
function! s:on_FileType_qf_define_mappings() abort
    nnoremap <buffer><silent> q :<C-u>cclose<CR>
    nnoremap <buffer><silent> j :<C-u>cnext<CR>:copen<CR>
    nnoremap <buffer><silent> k :<C-u>cprevious<CR>:copen<CR>
    nnoremap <buffer><silent> J :<C-u>cnfile<CR>:copen<CR>
    nnoremap <buffer><silent> K :<C-u>cpfile<CR>:copen<CR>
    nnoremap <buffer><silent> l :<C-u>clist<CR>
    " Clear <CR>
    nnoremap <buffer><CR> <CR>
endfunction
AutocmdFT qf call s:on_FileType_qf_define_mappings()

function! s:move_backward_by_step() abort
    let col = col('.')
    normal! g^
    let c = col('.')
    if col <= c
        normal! g0
    endif

    if col == col('.')
        normal! 0
    endif
endfunction

function! s:move_forward_by_step() abort
    let col = col('.')
    normal! g^
    let c = col('.')
    if col >= c
        normal! g$
    endif

    if col == col('.')
        normal! $
    endif
endfunction
" }}}

if exists(':terminal')
    if exists('+termwinkey')
        set termwinkey=<Esc>
    else
        set termkey=<Esc>
    endif
    function! s:open_terminal() abort
        if winwidth(0) >= 160
            let split = 'vsplit'
        else
            let split = 'split'
        endif
        execute 'topleft' split ' | terminal ++curwin ++close'
    endfunction
    nnoremap <silent><Space><Space> :<C-u>call <SID>open_terminal()<CR>
    " XXX: This kills original <Esc><Esc>, which sends raw '<Esc>' to
    " shell
    tmap <Esc><Esc> <Esc>N
endif
"}}}

" 最小限の設定と最小限のプラグインだけ読み込む {{{
" % vim --cmd "g:linda_pp_startup_with_tiny = 1" で起動した時
" または vi という名前の シンボリックリンク越しに vim を起動した時
if get(g:, 'linda_pp_startup_with_tiny', 0)
            \ || v:progname ==# 'vi'
            \ || ! exists('v:version') || v:version < 702
            \ || ! executable('git')
    syntax enable
    finish
endif
"}}}

" neobundle.vim の設定 {{{
" neobundle.vim が無ければインストールする
if ! isdirectory(expand('~/.vim/bundle'))
    echon 'Installing neobundle.vim...'
    silent call mkdir(expand('~/.vim/bundle'), 'p')
    silent !git clone https://github.com/Shougo/neobundle.vim $HOME/.vim/bundle/neobundle.vim
    echo 'done.'
    if v:shell_error
        echoerr 'neobundle.vim installation has failed!'
        finish
    endif
endif

if has('vim_starting')
    set rtp+=~/.vim/bundle/neobundle.vim/
endif

let s:meet_neocomplete_requirements = has('lua') && (v:version > 703 || (v:version == 703 && has('patch885')))
let s:enable_tern_for_vim = (has('python') || has('python3')) && executable('npm')
if has('mac')
    let s:xcode_usr_path = '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/'
    let g:clang_library_path = s:xcode_usr_path . 'lib/'
    let g:clang_user_options = '-std=c++1y -I ' . s:xcode_usr_path . 'include/c++/v1 -I /usr/local/include'
else
    let g:clang_library_path = '/usr/lib/llvm/lib'
endif
let s:clang_complete_available = has('python') && isdirectory(g:clang_library_path)

call neobundle#begin(expand('~/.vim/bundle'))

if neobundle#load_cache()

    " GitHub上のリポジトリ
    call neobundle#add('Shougo/neobundle.vim', { 'fetch': 1 })
    call neobundle#add('Shougo/vimproc.vim', {
                \ 'build' : {
                \       'windows' : 'echo "Please build vimproc manually."',
                \       'cygwin'  : 'make -f make_cygwin.mak',
                \       'mac'     : 'make -f make_mac.mak',
                \       'unix'    : 'make -f make_unix.mak',
                \   }
                \ })
    call neobundle#add('Shougo/neosnippet.vim')
    call neobundle#add('rhysd/inu-snippets')
    call neobundle#add('thinca/vim-quickrun')
    call neobundle#add('vim-jp/vimdoc-ja')
    call neobundle#add('kana/vim-textobj-user')
    call neobundle#add('thinca/vim-prettyprint')
    call neobundle#add('kana/vim-operator-user')
    call neobundle#add('kana/vim-smartinput')
    call neobundle#add('kana/vim-niceblock')
    call neobundle#add('h1mesuke/vim-alignta')
    call neobundle#add('rhysd/clever-f.vim')
    call neobundle#add('airblade/vim-gitgutter')
    call neobundle#add('kana/vim-submode')
    call neobundle#add('vim-airline/vim-airline')
    call neobundle#add('vim-airline/vim-airline-themes')
    call neobundle#add('rhysd/migemo-search.vim')
    call neobundle#add('rhysd/conflict-marker.vim')
    call neobundle#add('rhysd/vim-window-adjuster')
    call neobundle#add('Shougo/neomru.vim')
    call neobundle#add('rhysd/committia.vim')
    call neobundle#add('rhysd/vim-dachs')
    call neobundle#add('rust-lang/rust.vim')
    call neobundle#add('rhysd/rust-doc.vim')
    call neobundle#add('rhysd/vim-rustpeg')
    call neobundle#add('cespare/vim-toml')
    call neobundle#add('slim-template/vim-slim')
    call neobundle#add('leafgarland/typescript-vim')
    call neobundle#add('keith/tmux.vim')
    call neobundle#add('rhysd/npm-filetypes.vim')
    call neobundle#add('rhysd/github-complete.vim')
    call neobundle#add('rhysd/vim-crystal')
    call neobundle#add('thinca/vim-themis')
    call neobundle#add('othree/yajs.vim')
    call neobundle#add('rhysd/vim-wasm')
    call neobundle#add('rhysd/vim-gfm-syntax')
    call neobundle#add('ekalinin/Dockerfile.vim')
    call neobundle#add('rhysd/y-output.vim')
    call neobundle#add('rhysd/vim-goyacc')
    call neobundle#add('vim-jp/vim-cpp')
    call neobundle#add('rhysd/vim-filetype-haskell')
    call neobundle#add('othree/html5.vim')
    call neobundle#add('hail2u/vim-css3-syntax')
    call neobundle#add('w0rp/ale')
    call neobundle#add('justinmk/vim-dirvish')
    call neobundle#add('tpope/vim-markdown')
    call neobundle#add('aklt/plantuml-syntax')
    call neobundle#add('nelstrom/vim-markdown-folding')
    call neobundle#add('machakann/vim-highlightedyank')

    " unite.vim sources
    call neobundle#add('Shougo/unite-outline')
    call neobundle#add('Shougo/unite-help')
    call neobundle#add('thinca/vim-unite-history')
    call neobundle#add('rhysd/unite-zsh-cdr.vim')
    call neobundle#add('rhysd/unite-ruby-require.vim')
    call neobundle#add('ujihisa/unite-colorscheme')
    call neobundle#add('rhysd/unite-locate')
    call neobundle#add('sorah/unite-ghq')
    call neobundle#add('rhysd/unite-n3337')
    call neobundle#add('rhysd/unite-go-import.vim')
    call neobundle#add('rhysd/unite-oldfiles.vim')
    call neobundle#add('rhysd/unite-dirvish.vim')

    " カラースキーム
    call neobundle#add('rhysd/wallaby.vim')
    call neobundle#add('rhysd/vim-color-spring-night')
    call neobundle#add('chriskempson/tomorrow-theme', {'rtp' : 'vim'})
    call neobundle#add('junegunn/seoul256.vim')
    call neobundle#add('tomasr/molokai')
    call neobundle#add('altercation/vim-colors-solarized')
    call neobundle#add('jonathanfilip/vim-lucius')
    call neobundle#add('tyrannicaltoucan/vim-quantum')

    " For testing
    command! -nargs=1 NeoBundleMyPlugin
                \ NeoBundle <args>, {
                \   'base' : '~/Develop/github.com/rhysd',
                \   'type' : 'nosync',
                \ }

    " 読み込みを遅延する
    call neobundle#add('Shougo/unite.vim', {
                \ 'lazy' : 1,
                \ 'autoload' : {
                \     'commands' : [{'name': 'Unite', 'complete' : 'customlist,unite#complete_source'},
                \                   {'name': 'UniteWithBufferDir', 'complete' : 'customlist,unite#complete_source'},
                \                   {'name': 'UniteWithCursorWord', 'complete' : 'customlist,unite#complete_source'},
                \                   {'name': 'UniteWithWithInput', 'complete' : 'customlist,unite#complete_source'}]
                \   }
                \ })

    call neobundle#add('kana/vim-operator-replace', {
                \ 'lazy' : 1,
                \ 'autoload' : {
                \     'mappings' : '<Plug>(operator-replace)'
                \   }
                \ })

    call neobundle#add('rhysd/vim-operator-trailingspace-killer', {
                \ 'lazy' : 1,
                \ 'autoload' : {
                \     'mappings' : '<Plug>(operator-trailingspace-killer)'
                \   }
                \ })

    call neobundle#add('rhysd/vim-operator-surround', {
                \ 'lazy' : 1,
                \ 'depends' : 'tpope/vim-repeat',
                \ 'autoload' : {
                \     'mappings' : '<Plug>(operator-surround-'
                \   }
                \ })

    call neobundle#add('tyru/caw.vim', {
                \ 'lazy' : 1,
                \ 'autoload' : {
                \     'mappings' : ['<Plug>(caw', '<Plug>(operator-caw)']
                \   }
                \ })

    call neobundle#add('vim-scripts/ZoomWin', {
                \ 'lazy' : 1,
                \ 'autoload' : {
                \     'commands' : 'ZoomWin'
                \   }
                \ })

    call neobundle#add('kana/vim-altr', { 'lazy' : 1 })

    call neobundle#add('vim-jp/vital.vim', {
                \ 'lazy' : 1,
                \ 'autoload' : {
                \     'commands' : ['Vitalize'],
                \   },
                \ })

    call neobundle#add('tyru/open-browser.vim', {
                \ 'lazy' : 1,
                \ 'autoload' : {
                \     'commands' : ['OpenBrowser', 'OpenBrowserSearch', 'OpenBrowserSmartSearch'],
                \     'mappings' : '<Plug>(openbrowser-',
                \   }
                \ })

    call neobundle#add('tyru/open-browser-github.vim', {
                \ 'lazy' : 1,
                \ 'depends' : 'tyru/open-browser.vim',
                \ 'autoload' : {
                \     'commands' : ['OpenGithubFile', 'OpenGithubIssue', 'OpenGithubPullReq']
                \   }
                \ })

    call neobundle#add('glidenote/memolist.vim', {
                \ 'lazy' : 1,
                \ 'depends' : 'Shougo/unite.vim',
                \ 'autoload' : {
                \     'commands' : ['MemoNew', 'MemoList', 'MemoGrep']
                \   }
                \ })

    call neobundle#add('easymotion/vim-easymotion', {
                \ 'lazy' : 1,
                \ 'autoload' : {
                \     'mappings' : '<Plug>(easymotion-',
                \   }
                \ })

    call neobundle#add('kana/vim-textobj-indent', {
                \ 'lazy' : 1,
                \ 'depends' : 'kana/vim-textobj-user',
                \ 'autoload' : {
                \     'mappings' : [['xo', 'ai'], ['xo', 'aI'], ['xo', 'ii'], ['xo', 'iI']]
                \   }
                \ })

    call neobundle#add('kana/vim-textobj-line', {
                \ 'lazy' : 1,
                \ 'depends' : 'kana/vim-textobj-user',
                \ 'autoload' : {
                \     'mappings' : [['xo', 'al'], ['xo', 'il']]
                \   }
                \ })

    call neobundle#add('rhysd/vim-textobj-wiw', {
                \ 'lazy' : 1,
                \ 'depends' : 'kana/vim-textobj-user',
                \ 'autoload' : {
                \     'mappings' : [['xo', 'am'], ['xo', 'im']]
                \   }
                \ })

    call neobundle#add('sgur/vim-textobj-parameter', {
                \ 'lazy' : 1,
                \ 'depends' : 'kana/vim-textobj-user',
                \ 'autoload' : {
                \     'mappings' : [['xo', 'a,'], ['xo', 'i,']]
                \   }
                \ })

    call neobundle#add('thinca/vim-textobj-between', {
                \ 'lazy' : 1,
                \ 'depends' : 'kana/vim-textobj-user',
                \ 'autoload' : {
                \     'mappings' : [['xo', 'af'], ['xo', 'if'], ['xo', '<Plug>(textobj-between-']]
                \   }
                \ })

    call neobundle#add('rhysd/vim-textobj-word-column', {
                \ 'lazy' : 1,
                \ 'depends' : 'kana/vim-textobj-user',
                \ 'autoload' : {
                \     'mappings' : [['xo', 'av'], ['xo', 'aV'], ['xo', 'iv'], ['xo', 'iV']]
                \   }
                \ })

    call neobundle#add('kana/vim-textobj-entire', {
                \ 'lazy' : 1,
                \ 'depends' : 'kana/vim-textobj-user',
                \ 'autoload' : {
                \     'mappings' : [['xo', 'ae'], ['xo', 'ie']]
                \   }
                \ })

    call neobundle#add('kana/vim-textobj-fold', {
                \ 'lazy' : 1,
                \ 'depends' : 'kana/vim-textobj-user',
                \ 'autoload' : {
                \     'mappings' : [['xo', 'az'], ['xo', 'iz']]
                \   }
                \ })

    call neobundle#add('rhysd/vim-textobj-anyblock', {
                \ 'lazy' : 1,
                \ 'depends' : 'kana/vim-textobj-user',
                \ 'autoload' : {
                \       'mappings' : [['xo', 'ab'], ['xo', 'ib']]
                \   }
                \ })

    call neobundle#add('tpope/vim-fugitive', {
                \ 'lazy' : 1,
                \ 'autoload' : {
                \       'commands' : ['Gstatus', 'Gcommit', 'Gwrite', 'Gdiff', 'Gblame', 'Git', 'Ggrep']
                \   }
                \ })

    call neobundle#add('rhysd/wandbox-vim', {
                \ 'lazy' : 1,
                \ 'autoload' : {
                \       'commands' : [{'name' : 'Wandbox', 'complete' : 'customlist,wandbox#complete_command'}, 'WandboxOptionList']
                \   }
                \ })

    call neobundle#add('thinca/vim-visualstar', {
                \ 'lazy' : 1,
                \ 'autoload' : {
                \     'mappings' : [['x', '*'], ['x' , '#'], ['x', 'g*'], ['x', 'g#']],
                \   }
                \ })

    call neobundle#add('mattn/gist-vim', {
                \ 'lazy' : 1,
                \ 'depends' : 'mattn/webapi-vim',
                \ 'autoload' : {
                \     'commands' : 'Gist',
                \   }
                \ })

    call neobundle#add('dhruvasagar/vim-table-mode', {
                \ 'lazy' : 1,
                \ 'autoload' : {
                \     'commands' : ['TableModeToggle', 'TableModeEnable'],
                \   }
                \ })

    call neobundle#add('rhysd/vim-grammarous', {
                \ 'lazy' : 1,
                \ 'autoload' : {
                \     'commands' : 'GrammarousCheck'
                \   }
                \ })

    call neobundle#add('Shougo/neocomplete.vim', {
                \ 'fetch' : !s:meet_neocomplete_requirements,
                \ })

    call neobundle#add('junegunn/vader.vim', {
                \ 'lazy' : 1,
                \ 'autoload' : {
                \     'commands' : 'Vader',
                \     'filetypes' : 'vader',
                \   }
                \ })

    " GUI オンリーなプラグイン
    call neobundle#add('nathanaelkane/vim-indent-guides', {
                \   'lazy' : 1,
                \   'gui' : 1,
                \   'autoload' : {
                \     'filetypes' : ['haskell', 'python']
                \   }
                \ })
    call neobundle#add('tyru/restart.vim', {
                \   'lazy' : 1,
                \   'gui' : 1,
                \   'autoload' : {
                \     'commands' : 'Restart'
                \   }
                \ })

    " 特定のファイルタイプで読み込む
    call neobundle#add('rhysd/endwize.vim', {
                \   'lazy' : 1,
                \   'autoload' : {
                \     'filetypes' : ['ruby', 'vim', 'sh', 'zsh', 'c', 'cpp', 'lua', 'dachs', 'vimspec']
                \   }
                \ })
    call neobundle#add('hotwatermorning/auto-git-diff', {
                \   'lazy' : 1,
                \   'autoload' : {
                \     'filetypes' : 'gitrebase',
                \   }
                \ })

    " C++用のプラグイン
    call neobundle#add('Rip-Rip/clang_complete', {
                \ 'lazy' : 1,
                \ 'autoload' : {'filetypes' : ['c', 'cpp']},
                \ 'fetch' : !s:clang_complete_available,
                \ })

    " Haskell 用プラグイン
    call neobundle#add('ujihisa/unite-haskellimport', {
                \ 'lazy' : 1,
                \ 'autoload' : {'filetypes' : 'haskell'}
                \ })
    call neobundle#add('eagletmt/unite-haddock', {
                \ 'lazy' : 1,
                \ 'autoload' : {'filetypes' : 'haskell'}
                \ })
    call neobundle#add('ujihisa/neco-ghc', {
                \ 'lazy' : 1,
                \ 'autoload' : {'filetypes' : 'haskell'}
                \ })
    call neobundle#add('eagletmt/ghcmod-vim', {
                \ 'lazy' : 1,
                \ 'autoload' : {'filetypes' : 'haskell'}
                \ })

    " JavaScript 用プラグイン
    call neobundle#add('marijnh/tern_for_vim', {
                \ 'lazy' : 1,
                \ 'fetch' : !s:enable_tern_for_vim,
                \ 'build' : {
                \     'windows' : 'echo "Please build tern manually."',
                \     'cygwin'  : 'echo "Please build tern manually."',
                \     'mac'     : 'npm install',
                \     'unix'    : 'npm install',
                \   },
                \ 'autoload' : {
                \     'functions' : ['tern#Complete', 'tern#Enable'],
                \     'filetypes' : 'javascript'
                \   },
                \ 'commands' : ['TernDef', 'TernDoc', 'TernType', 'TernRefs', 'TernRename']
                \ })

    " Python
    call neobundle#add('davidhalter/jedi-vim', {
                \ 'lazy' : 1,
                \ 'autoload' : {
                \     'filetypes' : 'python',
                \   }
                \ })
    call neobundle#add('hynek/vim-python-pep8-indent', {
                \ 'lazy' : 1,
                \ 'autoload' : {
                \     'filetypes' : 'python',
                \   }
                \ })

    " Go
    call neobundle#add('fatih/vim-go', {
                \ 'lazy' : 1,
                \ 'autoload' : {
                \     'filetypes' : 'go',
                \     'commands' : ['GoImport', 'GoDrop', 'GoDef', 'GoVet', 'GoDoc', 'GoLint', 'GoRename', 'GoImports']
                \   }
                \ })

    " LLVM IR
    call neobundle#add('rhysd/vim-llvm')

    " Swift
    " Delay loading because it contains plugin/ directory
    call neobundle#add('Keithbsmiley/swift.vim', {
                \ 'lazy' : 1,
                \ 'autoload' : {
                \     'filetypes' : 'swift'
                \   }
                \ })

    " TypeScript
    call neobundle#add('Quramy/tsuquyomi', {
                \ 'lazy' : 1,
                \ 'autoload' : {
                \     'commands' : 'TsuOpen',
                \     'function_prefix': 'tsuquyomi',
                \   }
                \ })

    " Rust
    call neobundle#add('racer-rust/vim-racer', {
                \ 'lazy' : 1,
                \ 'autoload' : {
                \     'filetypes' : 'rust'
                \   }
                \ })

    " markdown
    call neobundle#add('tyru/markdown-codehl-onthefly.vim', {
                \ 'lazy' : 1,
                \ 'autoload' : {
                \     'filetypes' : 'markdown'
                \   }
                \ })

    " 書き込み権限の無いファイルを編集しようとした時
    call neobundle#add('sudo.vim', {'lazy' : 1})

    NeoBundleCheck
    NeoBundleSaveCache
endif

" ReadOnly のファイルを編集しようとしたときに sudo.vim を遅延読み込み
Autocmd FileChangedRO * NeoBundleSource sudo.vim
Autocmd FileChangedRO * execute "command! W SudoWrite" expand('%')

call neobundle#end()
filetype plugin indent on     " required!

Autocmd BufWritePost *vimrc,*gvimrc NeoBundleClearCache
" }}}

" Git helpers {{{

" git のルートディレクトリを返す
function! s:git_root_dir() abort
    let out = system('git rev-parse --is-inside-work-tree')
    if v:shell_error
        echohl ErrorMSg | echom out | echohl None
        return ''
    endif
    let out = system('git rev-parse --show-cdup')
    if v:shell_error
        echohl ErrorMSg | echom out | echohl None
        return ''
    endif
    return out
endfunction

" git commit ではインサートモードに入る
Autocmd VimEnter COMMIT_EDITMSG if getline(1) == '' | execute 1 | startinsert | endif
"}}}

" 他の helper {{{
" 本体に同梱されている matchit.vim のロードと matchpair の追加
function! s:matchit(...) abort
    if exists('s:matchit_loaded')
        return
    endif
    if v:version >= 800
        packadd! matchit
    else
        runtime macros/matchit.vim
    endif
    let s:matchit_loaded = 1
endfunction
AutocmdFT vim,zsh,sh,ruby,ocaml,make,html,xml call <SID>matchit()

" Shiba
function! s:shiba(args) abort
    if !executable('shiba')
        echohl ErrorMsg | echom "'shiba' command not found.  Please install it with npm" | echohl None
        return
    endif

    if a:args == []
        call vimproc#system('shiba --detach ' . expand('%:p'))
        return
    endif

    let path = a:args[0]
    if !isdirectory(path) && (!filereadable(path) || path !~# '\.\%(md\|markdown\)$')
        echohl ErrorMsg | echom path . ' is not a directory or markdown document' | echohl None
        return
    endif

    call vimproc#system('shiba --deatch ' . path)
endfunction
command! -nargs=? -complete=file Shiba call <SID>shiba([<f-args>])

" Note: utop does not work on Vim 8.1.26
let s:repl_programs = {
\   'ruby': ['pry', 'irb'],
\   'python': ['ptpython', 'python'],
\   'ocaml': ['ocaml'],
\   'javascript': ['node'],
\   'typescript': ['ts-node'],
\   'haskell': ['ghci'],
\ }
function! s:start_repl(args) abort
    let ft = &filetype
    if !has_key(s:repl_programs, ft)
        echom 'No REPL program found for this filetype'
        return
    endif
    let exe = ''
    for cmd in s:repl_programs[ft]
        if executable(cmd)
            let exe = cmd
            break
        endif
    endfor
    if exe ==# ''
        echom 'No REPL executable for filetype ' . ft . ' was found. Candidates: ' . string(s:repl_programs[ft])
        return
    endif
    let bufnr = term_start([exe] + a:args, {
                \   'term_name': 'REPL: ' . exe,
                \   'vertical': 1,
                \   'term_finish': 'close',
                \ })
    echo 'Started REPL at buffer ' . bufnr
endfunction
command! -nargs=* Repl call <SID>start_repl([<q-args>])
"}}}

" 追加のハイライト {{{
let s:zenkaku_no_highlight_filetypes = []
" 全角スペース
Autocmd ColorScheme * highlight link ZenkakuSpace Error
Autocmd VimEnter,WinEnter * if index(s:zenkaku_no_highlight_filetypes, &filetype) == -1 | syntax match ZenkakuSpace containedin=ALL /　/ | endif
Autocmd ColorScheme * highlight link githubFlavoredMarkdownCode CursorLine
" }}}

" カラースキーム {{{
" シンタックスハイライト
syntax enable
if !has('gui_running')
    if &t_Co < 256
        set background=dark
        colorscheme default
    else
        if has('termguicolors') && $TERM_PROGRAM ==# 'iTerm.app'
            let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
            let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
            set termguicolors
            colorscheme spring-night
            let g:airline_theme = 'spring_night'
        else
            colorscheme wallaby
            let g:airline_theme = 'wombat'
        endif
    endif
endif

let g:seoul256_background = 233
let g:quantum_black = 1
" }}}

" Ruby {{{
AutocmdFT ruby SetIndent 2
AutocmdFT ruby inoremap <buffer><C-s> self.
AutocmdFT ruby inoremap <buffer>;; ::
AutocmdFT ruby nnoremap <buffer>[unite]r :<C-u>Unite ruby/require<CR>
Autocmd BufRead,BufNew,BufNewFile Guardfile setlocal filetype=ruby

let s:ruby_template = ['#!/usr/bin/env ruby', '']
Autocmd BufNewFile *.rb call append(0, s:ruby_template) | normal! G
"}}}

" C++ {{{

" C++ ラベル字下げ設定
set cinoptions& cinoptions+=:0,g0,N-1,m1

AutocmdFT cpp setlocal matchpairs+=<:>
AutocmdFT cpp inoremap <buffer>, ,<Space>
AutocmdFT cpp inoremap <expr> e getline('.')[col('.') - 6:col('.') - 2] ==# 'const' ? 'expr ' : 'e'

let g:c_syntax_for_h = 1
" }}}

" Haskell {{{
AutocmdFT haskell inoremap <buffer>;; ::
"}}}

" Vim script "{{{
" gf を拡張し，autoload 関数を開けるように対応
function! s:jump_to_autoload_function_definition() abort
    let current_line = getline('.')
    let name_pattern = '\h\k*\%(#\h\k*\)*\ze#\h\k*('
    let begin = match(current_line, name_pattern)
    let end = matchend(current_line, name_pattern)
    let cursor = col('.')-1
    if begin <= cursor && cursor <= end
        let fname = globpath(&rtp, 'autoload/'.substitute(matchstr(current_line, name_pattern), '#', '/', 'g').'.vim')
        if filereadable(fname)
            execute 'edit' fname
            call search('\<fu\%[nction]\>!\=\s\+'.matchstr(current_line, '\h\k*\%(#\h\k*\)*#\h\k*('), 'cw')
        else
            echoerr fname.' is not found in runtimepath'
        endif
    else
        normal! gf
    endif
endfunction

AutocmdFT vim inoremap , ,<Space>
AutocmdFT vim nnoremap <silent><buffer>gf :<C-u>call <SID>jump_to_autoload_function_definition()<CR>
AutocmdFT vim nnoremap <silent><buffer>K :<C-u>call <SID>smart_help(expand('<cword>'))<CR>
"}}}

" LLVM IR {{{
AutocmdFT llvm SetIndent 2
" }}}

" Crystal {{{
AutocmdFT crystal SetIndent 2
" }}}

" html, css, sass, scss, haml {{{
AutocmdFT html,javascript
            \ if expand('%:e') ==# 'html' |
            \   nnoremap <buffer><silent><C-t>
            \       :<C-u>if &filetype ==# 'javascript' <Bar>
            \               setf html <Bar>
            \             else <Bar>
            \               setf javascript <Bar>
            \             endif<CR> |
            \ endif

AutocmdFT haml inoremap <expr> k getline('.')[col('.') - 2] ==# 'k' ? "\<BS>%" : 'k'
AutocmdFT haml,html,css SetIndent 2
Autocmd BufRead,BufNew,BufNewFile *.ejs setlocal ft=html

" <i> のイタリック表示や <b> のボールド表示を無効にする
let g:html_my_rendering = 0
"}}}

" Markdown {{{
AutocmdFT markdown nnoremap <buffer><silent><Leader>= :<C-u>call append('.', repeat('=', strdisplaywidth(getline('.'))))<CR>
AutocmdFT markdown nnoremap <buffer><silent><Leader>- :<C-u>call append('.', repeat('-', strdisplaywidth(getline('.'))))<CR>
AutocmdFT markdown setlocal foldlevel=99
"}}}

" Dachs {{{
" For Readme
function! s:bold(...) abort
    for k in a:000
        execute '%s/\%(#[^#]*\)\@<!\<' . k . '\>/<b>&<\/b>/geI'
    endfor
endfunction
function! s:to_readme_embdable_html() abort
    if &filetype !=# 'dachs'
        echoerr 'This command is for Dachs.'
        return
    endif

    %s/&/\&amp;/geI
    %s/</\&lt;/geI
    %s/>/\&gt;/geI

    call s:bold('end', 'var', 'do', 'as', 'if', 'unless', 'then', 'else', 'elseif', 'func', 'proc', 'ret', 'case', 'when', 'for', 'in', 'let', 'ensure', 'begin', 'class')
    %s/#[^#]*\%(#\|\_$\)/<i>&<\/i>/geI

    call append(0, '<pre>')
    call append(line('$'), '</pre>')

    setlocal filetype=html
endfunction
command! -nargs=0 ToReadmeEmbdableHTML call <SID>to_readme_embdable_html()

function! s:check_dachs_syntax() abort
    let root = finddir('Dachs', ';')
    if root ==# ''
        return
    endif
    let bin = root . '/build/bin/dachs'
    execute 'QuickRun' 'sh -outputter buffer -outputter/buffer/close_on_empty 1 -src' '"' . bin . ' --check-syntax --disable-color ' . expand('%:p') . '"'
endfunction
" Autocmd BufWritePost *.dcs call <SID>check_dachs_syntax()
AutocmdFT dachs setl errorformat=Error\ in\ line:%l,\ col:%c
" }}}

" JSON {{{
" 自動的にオブジェクトのキーをクォートで囲む
function! s:json_colon() abort
    let current_line = getline('.')
    if current_line[col('.')-1] !=# ':' || current_line !~# '\w\+\s*:$'
        return
    endif

    " check if in String or not
    let syn_id_attr_on_colon = synIDattr(synIDtrans(synID(line('.'),col('.'),1)),'name')
    if syn_id_attr_on_colon ==# 'String'
        return
    endif

    let [prefix, key] = matchlist(current_line, '\(^\|.*\s\)\(\w\+\)\s*:$')[1:2]
    call setline('.', prefix . '"' . key . '": ')
    let diff = len(getline('.')) - len(current_line)
    execute 'normal!' (diff > 0 ? diff . 'l' : -diff . 'h')
endfunction

AutocmdFT json inoremap <buffer>: :<C-o>:call <SID>json_colon()<CR>
AutocmdFT json inoremap <buffer><C-j> <End>,<CR>
AutocmdFT json SetIndent 2
AutocmdFT json setlocal foldmethod=syntax foldlevel=99
" }}}

" Python {{{
function! s:python_settings() abort
    setlocal noautoindent nosmartindent nocindent
    syntax keyword Constant self
endfunction
AutocmdFT python call <SID>python_settings()
"}}}

" Go {{{
function! s:golang_settings() abort
    setlocal noexpandtab

    let g:go_snippet_engine = 'neosnippet'
    let g:go_highlight_trailing_whitespace_error = 0
    let g:go_play_open_browser = 1

    let g:go_highlight_chan_whitespace_error = 0
    let g:go_highlight_extra_types = 0
    let g:go_highlight_space_tab_error = 0
    let g:go_highlight_array_whitespace_error = 0
    let g:go_highlight_functions = 1

    let g:go_metalinter_autosave_enabled = ['vet', 'golint']
    if executable('gofmtrlx')
        let g:go_fmt_command = 'gofmtrlx'
    elseif executable('goimports')
        let g:go_fmt_command = 'goimports'
    endif
    let g:go_snippet_engine = ''

    nnoremap <buffer><Space>i :<C-u>Unite go/import -start-insert<CR>
    nnoremap <buffer><Leader>i :<C-u>GoImports<CR>
    inoremap <buffer><C-g><C-i> <C-o>:GoImports<CR>
    nnoremap <buffer><Leader>gt :<C-u>GoTestFunc<CR>
    nnoremap <buffer><Leader>gr :<C-u>GoRename<Space>
    nnoremap <buffer><Leader>gi :<C-u>GoInfo<CR>
    nnoremap <buffer><Leader>gn :<C-u>GoSameIds<CR>
endfunction

AutocmdFT go,go.test call <SID>golang_settings()
AutocmdFT godoc nnoremap<buffer>q :<C-u>quit<CR>
AutocmdFT godoc nnoremap<buffer>d <C-d>
AutocmdFT godoc nnoremap<buffer>u <C-u>
AutocmdFT godoc nnoremap<buffer>o :<C-u>Unite outline<CR>
" }}}

" Rust {{{
let g:rust_recommended_style = 0
let g:rust_doc#downloaded_rust_doc_dir = '~/Documents/rust-docs'
let $RUST_SRC_PATH = $HOME . '/Develop/github.com/rust-lang/rust/src'
let g:racer_cmd = 'racer'
let g:racer_insert_paren = 0
let g:racer_experimental_completer = 1
AutocmdFT rust nnoremap <buffer><Leader>x :<C-u>RustFmt<CR>
" }}}

" TypeScript {{{
let g:tsuquyomi_auto_open = 0
function! s:tsu_open() abort
    call tsuquyomi#open()
    iunmap <buffer><C-x><C-o>
    autocmd! MyVimrc-tsuopen
    call feedkeys("\<C-x>\<C-o>")
endfunction
augroup MyVimrc-tsuopen
    autocmd!
    autocmd FileType typescript inoremap <buffer><C-x><C-o> <C-o>:call <SID>tsu_open()<CR>
augroup END
" }}}

" Zsh {{{
let g:zsh_fold_enable = 0

let s:sh_template = ['#!/bin/bash', '']
Autocmd BufNewFile *.sh call append(0, s:sh_template) | normal! G
let s:zsh_template = ['#!/usr/bin/env zsh', '']
Autocmd BufNewFile *.zsh call append(0, s:sh_template) | normal! G
" }}}

" vimspec {{{
AutocmdFT vimspec setlocal foldmethod=marker
" }}}

" PlantUML {{{
function! s:preview_plantuml(fpath) abort
    if &filetype !=# 'plantuml' || &buftype ==# 'nofile' || !executable('plantuml')
        echohl ErrorMsg | echomsg 'Cannot preview PlantUML. File is not a PlantUML file, nor `plantuml` command is not found' | echohl None
        return
    endif

    let fpath = a:fpath
    if fpath ==# ''
        let fpath = expand('%:p')
    endif

    let dir = fpath
    if !isdirectory(fpath)
        let dir = fnamemodify(fpath, ':h')
    endif

    if dir ==# ''
        echohl ErrorMsg | echomsg 'Cannot get a file of current buffer.' | echohl None
        return
    endif

    let cmd = ['/bin/sh', '-c', 'cd ' . dir . ' && plantuml -gui']
    call job_start(cmd)
endfunction
command! -bar -nargs=? PlantUML call s:preview_plantuml(<q-args>)
" }}}

if s:meet_neocomplete_requirements
" neocomplete.vim {{{
"AutoComplPopを無効にする
let g:acp_enableAtStartup = 0
"vim起動時に有効化
let g:neocomplete#enable_at_startup = 1
"smart_caseを有効にする．大文字が入力されるまで大文字小文字の区別をなくす
let g:neocomplete#enable_smart_case = 1
" あいまいな候補一致
let g:neocomplete#enable_fuzzy_completion = 1
" デリミタ（autoload 関数の # など）の自動挿入
let g:neocomplete#enable_auto_delimiter = 1
"シンタックスをキャッシュするときの最小文字長を4に
let g:neocomplete#min_keyword_length = 4
let g:neocomplete#sources#syntax#min_keyword_length = 4
"補完を開始する入力文字長
let g:neocomplete#auto_completion_start_length = 3
"日本語を収集しないようにする
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'
" ctags は自分の用意したものを使う
if executable('/usr/local/bin/ctags')
    let g:neocomplete#ctags_command = '/usr/local/bin/ctags'
elseif executable('/usr/bin/ctags')
    let g:neocomplete#ctags_command = '/usr/bin/ctags'
endif
" Ruby の外部ファイルの拡張子
let g:neocomplete#sources#file_include#exts
            \ = get(g:, 'neocomplete#sources#file_include#exts', {})
let g:neocomplete#sources#file_include#exts.ruby = ['', 'rb']
"リスト表示
let g:neocomplete#max_list = 300
"区切り文字パターンの定義
if !exists('g:neocomplete#delimiter_patterns')
    let g:neocomplete#delimiter_patterns = {}
endif
let g:neocomplete#delimiter_patterns.vim = ['#']
let g:neocomplete#delimiter_patterns.cpp = ['::']
"インクルードパスの指定
if !exists('g:neocomplete#sources#include#paths')
    let g:neocomplete#sources#include#paths = {}
endif
let g:neocomplete#sources#include#paths.cpp  = '.,/usr/local/include'
let g:neocomplete#sources#include#paths.c    = '.,/usr/include'
"インクルード文のパターンを指定
let g:neocomplete#sources#include#patterns = { 'c' : '^\s*#\s*include', 'cpp' : '^\s*#\s*include', 'ruby' : '^\s*require', 'perl' : '^\s*use', }
"インクルード先のファイル名の解析パターン
let g:neocomplete#filename#include#exprs = {
            \ 'ruby' : "substitute(substitute(v:fname,'::','/','g'),'$','.rb','')"
            \ }
" オムニ補完を有効にする(ruby のオムニ補完は挙動が怪しいので off)
AutocmdFT html   setlocal omnifunc=htmlcomplete#CompleteTags
AutocmdFT css    setlocal omnifunc=csscomplete#CompleteCSS
" オムニ補完を実行するパターン
if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.c   = '\%(\.\|->\)\h\w*'
let g:neocomplete#sources#omni#input_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.javascript = '\%(\h\w*\|[^. \t]\.\w*\)'
let g:neocomplete#sources#omni#input_patterns.markdown = ''
let g:neocomplete#sources#omni#input_patterns.gitcommit = ''
" neocomplete 補完用関数
let g:neocomplete#sources#vim#complete_functions = {
    \ 'Unite' : 'unite#complete_source',
    \}
let g:neocomplete#force_overwrite_completefunc = 1
if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.python = '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
" neosnippet だけは短いキーワードでも候補に出す
call neocomplete#custom#source('neosnippet', 'min_pattern_length', 1)
" オムニ補完に使う関数
let g:neocomplete#sources#omni#functions = get(g:, 'neocomplete#sources#omni#functions', {})
if s:enable_tern_for_vim
    let g:neocomplete#sources#omni#functions.javascript = 'tern#Complete'
    AutocmdFT javascript setlocal omnifunc=tern#Complete
endif

"neocompleteのマッピング
inoremap <expr><C-g> neocomplete#undo_completion()
inoremap <expr><C-s> neocomplete#complete_common_string()
" <Tab>: completion
inoremap <expr><Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
"<C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y> neocomplete#cancel_popup()
" HACK: This hack needs because of using both vim-smartinput and neocomplete
" when <CR> is typed.
"    A user types <CR> ->
"    smart_close_popup() is called when pumvisible() ->
"    <Plug>(physical_key_return) hooked by vim-smartinput is used
imap <expr><CR> (pumvisible() ? neocomplete#smart_close_popup() : "")."\<Plug>(physical_key_return)"
" コマンドラインウィンドウでは Tab の挙動が変わるのでワークアラウンド
Autocmd CmdwinEnter * inoremap <silent><buffer><Tab> <C-n>
Autocmd CmdwinEnter * inoremap <expr><buffer><CR> (pumvisible() ? neocomplete#smart_close_popup() : "")."\<CR>"
Autocmd CmdwinEnter * inoremap <silent><buffer><expr><C-h> col('.') == 1 ?
                                    \ "\<ESC>:quit\<CR>" : neocomplete#cancel_popup()."\<C-h>"
Autocmd CmdwinEnter * inoremap <silent><buffer><expr><BS> col('.') == 1 ?
                                    \ "\<ESC>:quit\<CR>" : neocomplete#cancel_popup()."\<BS>"
" }}}
endif

" neosnippet {{{
"スニペット展開候補があれば展開を，そうでなければbash風補完を．
" プレースホルダ優先で展開
imap <expr><C-l> neosnippet#expandable() \|\| neosnippet#jumpable() ?
            \ "\<Plug>(neosnippet_jump_or_expand)" :
            \ "\<C-s>"
smap <expr><C-l> neosnippet#expandable() \|\| neosnippet#jumpable() ?
            \ "\<Plug>(neosnippet_jump_or_expand)" :
            \ "\<C-s>"
" ネスト優先で展開
imap <expr><C-S-l> neosnippet#expandable() \|\| neosnippet#jumpable() ?
            \ "\<Plug>(neosnippet_expand_or_jump)" :
            \ "\<C-s>"
smap <expr><C-S-l> neosnippet#expandable() \|\| neosnippet#jumpable() ?
            \ "\<Plug>(neosnippet_expand_or_jump)" :
            \ "\<C-s>"
let g:neosnippet#disable_runtime_snippets = {'_' : 1}
"}}}

" unite.vim {{{
let s:bundle = neobundle#get('unite.vim')
function! s:bundle.hooks.on_source(bundle) abort
    " 無指定にすることで高速化
    let g:unite_source_file_mru_filename_format = ''
    " most recently used のリストサイズ
    let g:unite_source_file_mru_limit = 100
    " unite-grep で使うオプション
    let g:unite_source_grep_default_opts = '-Hn --color=never'

    " Git リポジトリのすべてのファイルを開くアクション {{{
    let git_repo = { 'description' : 'all file in git repository' }
    function! git_repo.func(candidate) abort
        if system('git rev-parse --is-inside-work-tree') ==# "true\n"
            execute 'args'
                    \ join( filter(split(system('git ls-files `git rev-parse --show-cdup`'), '\n')
                            \ , 'empty(v:val) || isdirectory(v:val) || filereadable(v:val)') )
        else
            echoerr 'Not a git repository!'
        endif
    endfunction

    call unite#custom#action('file', 'git_repo_files', git_repo)
    " }}}

    " ファイルなら開き，ディレクトリなら dirvish に渡す {{{
    let open_or_dirvish = {
                \ 'description' : 'open a file or open a directory with dirvish',
                \ 'is_selectable' : 1,
                \ }
    function! open_or_dirvish.func(candidates) abort
        for candidate in a:candidates
            if candidate.kind ==# 'directory'
                execute 'Dirvish' candidate.action__path
                return
            endif
        endfor
        execute 'args' join(map(a:candidates, 'v:val.action__path'), ' ')
    endfunction
    call unite#custom#action('file', 'open_or_dirvish', open_or_dirvish)
    "}}}

    " Finder for Mac
    if has('mac')
        let finder = { 'description' : 'open with Finder.app' }
        function! finder.func(candidate) abort
            if a:candidate.kind ==# 'directory'
                call unite#util#system('open -a Finder '.a:candidate.action__path)
            endif
        endfunction
        call unite#custom#action('directory', 'finder', finder)
    endif

    call unite#custom#profile('source/quickfix,source/outline,source/line,source/line/fast,source/grep', 'context', {'prompt_direction' : 'top'})
    call unite#custom#profile('source/ghq', 'context', {'default_action' : 'open_or_dirvish'})

    call unite#custom#profile('default', 'context', {
                \ 'start_insert' : 1,
                \ 'direction' : 'botright',
                \ })

    "C-gでいつでもバッファを閉じられる（絞り込み欄が空の時はC-hでもOK）
    AutocmdFT unite imap <buffer><C-g> <Plug>(unite_exit)
    AutocmdFT unite nmap <buffer><C-g> <Plug>(unite_exit)
    "直前のパス削除
    AutocmdFT unite imap <buffer><C-w> <Plug>(unite_delete_backward_path)
    AutocmdFT unite nmap <buffer>h <Plug>(unite_delete_backward_path)
    "ファイル上にカーソルがある時，pでプレビューを見る
    AutocmdFT unite inoremap <buffer><expr>p unite#smart_map("p", unite#do_action('preview'))
    "C-xでクイックマッチ
    AutocmdFT unite imap <buffer><C-x> <Plug>(unite_quick_match_default_action)
    "lでデフォルトアクションを実行
    AutocmdFT unite nmap <buffer>l <Plug>(unite_do_default_action)
    AutocmdFT unite imap <buffer><expr>l unite#smart_map("l", unite#do_action(unite#get_current_unite().context.default_action))
    "jjで待ち時間が発生しないようにしていると候補が見えなくなるので対処
    AutocmdFT unite imap <buffer><silent>jj <Plug>(unite_insert_leave)
endfunction
unlet s:bundle

"unite.vimのキーマップ {{{
noremap [unite] <Nop>
map     <Space> [unite]
" コマンドラインウィンドウで Unite コマンドを入力
nnoremap [unite]u                 :<C-u>Unite source<CR>
"バッファを開いた時のパスを起点としたファイル検索
nnoremap <silent>[unite]ff        :<C-u>UniteWithBufferDir -buffer-name=files -vertical file directory file/new<CR>
"最近使用したファイル
nnoremap <silent>[unite]m         :<C-u>Unite file_mru directory_mru zsh-cdr oldfiles file/new<CR>
"バッファ一覧
nnoremap <silent>[unite]b         :<C-u>Unite -immediately -no-empty -auto-preview buffer<CR>
"プログラミングにおけるアウトラインの表示
nnoremap <silent>[unite]o         :<C-u>Unite outline -vertical -no-start-insert<CR>
"コマンドの出力
nnoremap <silent>[unite]c         :<C-u>Unite output<CR>
"grep検索．
nnoremap <silent>[unite]gr        :<C-u>Unite -no-start-insert grep<CR>
"Uniteバッファの復元
nnoremap <silent>[unite]r         :<C-u>UniteResume<CR>
" Haskell Import
AutocmdFT haskell nnoremap <buffer>[unite]hd :<C-u>Unite haddock<CR>
AutocmdFT haskell nnoremap <buffer>[unite]ho :<C-u>Unite hoogle<CR>
AutocmdFT haskell nnoremap <buffer><expr>[unite]hi
                    \        empty(expand("<cWORD>")) ? ":\<C-u>Unite haskellimport\<CR>"
                    \                                 :":\<C-u>UniteWithCursorWord haskellimport\<CR>"
" Git で管理されているファイルから選んで開く
nnoremap <silent><expr>[unite]p  ":\<C-u>Unite file_rec/git:".fnamemodify(<SID>git_root_dir(),':p')
" C++ インクルードファイル
AutocmdFT cpp nnoremap <buffer>[unite]i :<C-u>Unite file_include -vertical<CR>
" help(項目が多いので，検索語を入力してから絞り込む)
nnoremap <silent>[unite]hh        :<C-u>UniteWithInput help -vertical<CR>
" 履歴
nnoremap <silent>[unite]hc        :<C-u>Unite -buffer-name=lines history/command -start-insert<CR>
nnoremap <silent>[unite]hs        :<C-u>Unite -buffer-name=lines history/search<CR>
nnoremap <silent>[unite]hy        :<C-u>Unite -buffer-name=lines history/yank<CR>
" unite-lines ファイル内インクリメンタル検索
nnoremap <silent><expr> [unite]L line('$') > 5000 ?
            \ ":\<C-u>Unite -no-split -start-insert -auto-preview line/fast\<CR>" :
            \ ":\<C-u>Unite -start-insert -auto-preview line:all\<CR>"
" カラースキーム
nnoremap [unite]C :<C-u>Unite -auto-preview colorscheme<CR>
" locate
nnoremap <silent>[unite]l :<C-u>UniteWithInput locate<CR>
" 検索
nnoremap <silent>[unite]/ :<C-u>execute 'Unite grep:'.expand('%:p').' -input='.escape(substitute(@/, '^\\v', '', ''), ' \')<CR>
" ghq
" }}}

" }}}

" unite-n3337 "{{{
let g:unite_n3337_pdf = $HOME.'/Documents/C++/n3337.pdf'
AutocmdFT cpp nnoremap <buffer>[unite]n :<C-u>Unite n3337<CR>
"}}}

" vim-quickrun {{{
"<Leader>r を使わない
let g:quickrun_no_default_key_mappings = 1
" quickrun_configの初期化
let g:quickrun_config = get(g:, 'quickrun_config', {})
"QuickRun 結果の開き方
let g:quickrun_config._ = {
            \ 'outputter' : 'error',
            \ 'outputter/error/success' : 'buffer',
            \ 'outputter/error/error' : 'quickfix',
            \ 'outputter/buffer/close_on_empty' : 1,
            \ 'split' : 'rightbelow',
            \ 'runner' : 'job',
            \ }
"C++
let g:quickrun_config.cpp = {
            \ 'command' : 'clang++',
            \ 'cmdopt' : '-std=c++1y -Wall -Wextra -O2',
            \ }
let g:quickrun_config['cpp/llvm'] = {
            \ 'type' : 'cpp/clang++',
            \ 'exec' : '%c %o -emit-llvm -S %s -o -',
            \ }
let g:quickrun_config['c/llvm'] = {
            \ 'type' : 'c/clang',
            \ 'exec' : '%c %o -emit-llvm -S %s -o -',
            \ }
"outputter
let g:quickrun_unite_quickfix_outputter_unite_context = { 'no_empty' : 1 }
Autocmd BufReadPost,BufNewFile [Rr]akefile{,.rb}
            \ let b:quickrun_config = {'exec': 'rake -f %s'}
" tmux
let g:quickrun_config['tmux'] = {
            \ 'command' : 'tmux',
            \ 'cmdopt' : 'source-file',
            \ 'exec' : ['%c %o %s:p', 'echo "sourced %s"'],
            \ }

let g:quickrun_config['llvm'] = {
            \   'exec' : 'llvm-as-3.4 %s:p -o=- | lli-3.4 - %a',
            \ }

let g:quickrun_config['dachs'] = {
            \   'command' : './bin/dachs',
            \   'cmdopt' : '--disable-color',
            \   'exec' : ['%c %o %s:p', '%s:p:r %a'],
            \ }

let g:quickrun_config['dachs/llvm'] = {
            \   'type' : 'dachs',
            \   'cmdopt' : '--emit-llvm',
            \   'exec' : '%c %o %s:p',
            \ }

let g:quickrun_config['slim'] = {
            \   'command' : 'slimrb',
            \   'cmdopt' : '--pretty',
            \   'exec' : '%c %o %s:p',
            \ }

let g:quickrun_config['gocaml'] = {
            \   'command' : $GOPATH . '/src/github.com/rhysd/gocaml/gocaml',
            \   'exec' : ['%c %o %s:p', '%s:p:r %a'],
            \   'errorformat' : '',
            \ }

let g:quickrun_config['vimspec'] = {
            \   'command' : $HOME . '/.vim/bundle/vim-themis/bin/themis',
            \   'exec' : '%c %o %s:p',
            \   'errorformat' : '',
            \ }

"QuickRunのキーマップ {{{
nnoremap <silent><Leader>q :<C-u>QuickRun<CR>
vnoremap <silent><Leader>q :QuickRun<CR>
" }}}
" }}}

" vim-smartinput"{{{
" 括弧内のスペース
call smartinput#map_to_trigger('i', '<Space>', '<Space>', '<Space>')
call smartinput#define_rule({
            \   'at'    : '(\%#)',
            \   'char'  : '<Space>',
            \   'input' : '<Space><Space><Left>',
            \   })

call smartinput#map_to_trigger('i', '<BS>', '<BS>', '<BS>')
call smartinput#define_rule({
            \   'at'    : '( \%# )',
            \   'char'  : '<BS>',
            \   'input' : '<Del><BS>',
            \   })

call smartinput#define_rule({
            \   'at'    : '{\%#}',
            \   'char'  : '<Space>',
            \   'input' : '<Space><Space><Left>',
            \   })

call smartinput#define_rule({
            \   'at'    : '{ \%# }',
            \   'char'  : '<BS>',
            \   'input' : '<Del><BS>',
            \   })

call smartinput#define_rule({
            \   'at'    : '\[\%#\]',
            \   'char'  : '<Space>',
            \   'input' : '<Space><Space><Left>',
            \   })

call smartinput#define_rule({
            \   'at'    : '\[ \%# \]',
            \   'char'  : '<BS>',
            \   'input' : '<Del><BS>',
            \   })

call smartinput#map_to_trigger('i', '<Plug>(physical_key_return)', '<CR>', '<CR>')
" 行末のスペースを削除する
call smartinput#define_rule({
            \   'at'    : '\s\+\%#',
            \   'char'  : '<CR>',
            \   'input' : "<C-o>:call setline('.', substitute(getline('.'), '\\s\\+$', '', '')) <Bar> echo 'delete trailing spaces'<CR><CR>",
            \   })

" Ruby 文字列内変数埋め込み
call smartinput#map_to_trigger('i', '#', '#', '#')
call smartinput#define_rule({
            \   'at'       : '\%#',
            \   'char'     : '#',
            \   'input'    : '#{}<Left>',
            \   'filetype' : ['ruby'],
            \   'syntax'   : ['Constant', 'Special'],
            \   })

" Ruby ブロック引数 ||
call smartinput#map_to_trigger('i', '<Bar>', '<Bar>', '<Bar>')
call smartinput#define_rule({
            \   'at' : '\%({\|\<do\>\)\s*\%#',
            \   'char' : '|',
            \   'input' : '||<Left>',
            \   'filetype' : ['ruby', 'dachs'],
            \    })

" テンプレート内のスペース
call smartinput#define_rule({
            \   'at' :       '<\%#>',
            \   'char' :     '<Space>',
            \   'input' :    '<Space><Space><Left>',
            \   'filetype' : ['cpp'],
            \   })
call smartinput#define_rule({
            \   'at' :       '< \%# >',
            \   'char' :     '<BS>',
            \   'input' :    '<Del><BS>',
            \   'filetype' : ['cpp'],
            \   })

" ブロックコメント
call smartinput#map_to_trigger('i', '*', '*', '*')
call smartinput#define_rule({
            \   'at'       : '\/\%#',
            \   'char'     : '*',
            \   'input'    : '**/<Left><Left>',
            \   'filetype' : ['c', 'cpp'],
            \   })
call smartinput#define_rule({
            \   'at'       : '/\*\%#\*/',
            \   'char'     : '<Space>',
            \   'input'    : '<Space><Space><Left>',
            \   'filetype' : ['c', 'cpp'],
            \   })
call smartinput#define_rule({
            \   'at'       : '/* \%# */',
            \   'char'     : '<BS>',
            \   'input'    : '<Del><BS>',
            \   'filetype' : ['c', 'cpp'],
            \   })

" セミコロンの挙動
call smartinput#map_to_trigger('i', ';', ';', ';')
" 2回押しで :: の代わり（待ち時間無し）
call smartinput#define_rule({
            \   'at'       : ';\%#',
            \   'char'     : ';',
            \   'input'    : '<BS>::',
            \   'filetype' : ['cpp', 'rust'],
            \   })
" boost:: の補完
call smartinput#define_rule({
            \   'at'       : '\<b;\%#',
            \   'char'     : ';',
            \   'input'    : '<BS>oost::',
            \   'filetype' : ['cpp'],
            \   })
" std:: の補完
call smartinput#define_rule({
            \   'at'       : '\<s;\%#',
            \   'char'     : ';',
            \   'input'    : '<BS>td::',
            \   'filetype' : ['cpp', 'rust'],
            \   })
" detail:: の補完
call smartinput#define_rule({
            \   'at'       : '\%(\s\|::\)d;\%#',
            \   'char'     : ';',
            \   'input'    : '<BS>etail::',
            \   'filetype' : ['cpp'],
            \   })
" llvm:: の補完
call smartinput#define_rule({
            \   'at'       : '\%(\s\|::\)l;\%#',
            \   'char'     : ';',
            \   'input'    : '<BS>lvm::',
            \   'filetype' : ['cpp'],
            \   })
" クラス定義や enum 定義の場合は末尾に;を付け忘れないようにする
call smartinput#define_rule({
            \   'at'       : '\%(\<struct\>\|\<class\>\|\<enum\>\)\s*\w\+.*\%#',
            \   'char'     : '{',
            \   'input'    : '{};<Left><Left>',
            \   'filetype' : ['cpp'],
            \   })
" template に続く <> を補完
call smartinput#define_rule({
            \   'at'       : '\<template\>\s*\%#',
            \   'char'     : '<',
            \   'input'    : '<><Left>',
            \   'filetype' : ['cpp'],
            \   })

" Vim の正規表現内で \( が入力されたときの \) の補完
call smartinput#define_rule({
            \   'at'       : '\\\%(\|%\|z\)\%#',
            \   'char'     : '(',
            \   'input'    : '(\)<Left><Left>',
            \   'filetype' : ['vim'],
            \   'syntax'   : ['String'],
            \   })
call smartinput#define_rule({
            \   'at'       : '\\[%z](\%#\\)',
            \   'char'     : '<BS>',
            \   'input'    : '<Del><Del><BS><BS><BS>',
            \   'filetype' : ['vim'],
            \   'syntax'   : ['String'],
            \   })
call smartinput#define_rule({
            \   'at'       : '\\(\%#\\)',
            \   'char'     : '<BS>',
            \   'input'    : '<Del><Del><BS><BS>',
            \   'filetype' : ['vim'],
            \   'syntax'   : ['String'],
            \   })

" my-endwise のための設定（手が焼ける…）
call smartinput#define_rule({
            \   'at'    : '\%#',
            \   'char'  : '<CR>',
            \   'input' : '<CR><C-r>=endwize#crend()<CR>',
            \   'filetype' : ['vim', 'ruby', 'sh', 'zsh', 'dachs'],
            \   })
call smartinput#define_rule({
            \   'at'    : '\s\+\%#',
            \   'char'  : '<CR>',
            \   'input' : "<C-o>:call setline('.', substitute(getline('.'), '\\s\\+$', '', ''))<CR><CR><C-r>=endwize#crend()<CR>",
            \   'filetype' : ['vim', 'ruby', 'sh', 'zsh', 'dachs'],
            \   })
call smartinput#define_rule({
            \   'at'    : '^#if\%(\|def\|ndef\)\s\+.*\%#',
            \   'char'  : '<CR>',
            \   'input' : "<C-o>:call setline('.', substitute(getline('.'), '\\s\\+$', '', ''))<CR><CR><C-r>=endwize#crend()<CR>",
            \   'filetype' : ['c', 'cpp'],
            \   })

" \s= を入力したときに空白を挟む
call smartinput#map_to_trigger('i', '=', '=', '=')
call smartinput#define_rule(
    \ { 'at'    : '\s\%#'
    \ , 'char'  : '='
    \ , 'input' : '= '
    \ , 'filetype' : ['c', 'cpp', 'vim', 'ruby']
    \ })

" でも連続した == となる場合には空白は挟まない
call smartinput#define_rule(
    \ { 'at'    : '=\s\%#'
    \ , 'char'  : '='
    \ , 'input' : '<BS>= '
    \ , 'filetype' : ['c', 'cpp', 'vim', 'ruby']
    \ })

" でも連続した =~ となる場合には空白は挟まない
call smartinput#map_to_trigger('i', '~', '~', '~')
call smartinput#define_rule(
    \ { 'at'    : '=\s\%#'
    \ , 'char'  : '~'
    \ , 'input' : '<BS>~ '
    \ , 'filetype' : ['c', 'cpp', 'vim', 'ruby']
    \ })

" Vim は ==# と =~# がある
call smartinput#map_to_trigger('i', '#', '#', '#')
call smartinput#define_rule(
    \ { 'at'    : '=[~=]\s\%#'
    \ , 'char'  : '#'
    \ , 'input' : '<BS># '
    \ , 'filetype' : ['vim']
    \ })

" Vim help
call smartinput#define_rule(
    \ { 'at'    : '\%#'
    \ , 'char'  : '|'
    \ , 'input' : '||<Left>'
    \ , 'filetype' : ['help']
    \ })
call smartinput#define_rule(
    \ { 'at'    : '|\%#|'
    \ , 'char'  : '<BS>'
    \ , 'input' : '<Del><BS>'
    \ , 'filetype' : ['help']
    \ })
call smartinput#map_to_trigger('i', '*', '*', '*')
call smartinput#define_rule(
    \ { 'at'    : '\%#'
    \ , 'char'  : '*'
    \ , 'input' : '**<Left>'
    \ , 'filetype' : ['help']
    \ })
call smartinput#define_rule(
    \ { 'at'    : '\*\%#\*'
    \ , 'char'  : '<BS>'
    \ , 'input' : '<Del><BS>'
    \ , 'filetype' : ['help']
    \ })
"}}}

" caw.vim {{{
" デフォルトマッピングを OFF
let g:caw_no_default_keymappings = 1

" キーマッピング {{{
" 行コメント
nmap <Leader>cc <Plug>(caw:hatpos:toggle)
" 行末尾コメント
nmap <Leader>ca <Plug>(caw:dollarpos:toggle)
" ブロックコメント
nmap <Leader>cb <Plug>(caw:wrap:toggle)
" 改行後コメント
nmap <Leader>co <Plug>(caw:jump:comment-next)
nmap <Leader>cO <Plug>(caw:jump:comment-prev)
map <Leader>c <Plug>(caw:hatpos:toggle:operator)
"}}}

"}}}

" textobj-anyblock {{{
let g:textobj#anyblock#blocks = [ '(', '{', '[', '"', "'", '<', 'f`']
AutocmdFT help,markdown let b:textobj_anyblock_local_blocks = ['f*', 'f|']
"}}}

" vim-operator {{{
" operator-replace
map <Leader>r <Plug>(operator-replace)
" v_p を置き換える
vmap p <Plug>(operator-replace)
" operator-blank-killer
map <silent><Leader>k <Plug>(operator-trailingspace-killer)
" vim-operator-surround {{{
let g:operator#surround#blocks =
            \ {
            \   '-' : [
            \       { 'block' : ['(', ')'], 'motionwise' : ['char', 'line', 'block'], 'keys' : ['p'] },
            \       { 'block' : ['[', ']'], 'motionwise' : ['char', 'line', 'block'], 'keys' : ['c'] },
            \       { 'block' : ['{', '}'], 'motionwise' : ['char', 'line', 'block'], 'keys' : ['b'] },
            \       { 'block' : ['<', '>'], 'motionwise' : ['char', 'line', 'block'], 'keys' : ['a'] },
            \       { 'block' : ['"', '"'], 'motionwise' : ['char', 'line', 'block'], 'keys' : ['q'] },
            \       { 'block' : ["'", "'"], 'motionwise' : ['char', 'line', 'block'], 'keys' : ['s'] },
            \   ]
            \ }
map <silent>gy <Plug>(operator-surround-append)
map <silent>gd <Plug>(operator-surround-delete)
map <silent>gc <Plug>(operator-surround-replace)
"}}}
"}}}

" ghcmod-vim {{{
AutocmdFT haskell nnoremap <buffer><C-t> :<C-u>GhcModType<CR>
AutocmdFT haskell let &l:statusline = '%{empty(getqflist()) ? "[No Errors] " : "[Errors Found] "}'
                                            \ . (empty(&l:statusline) ? &statusline : &l:statusline)
AutocmdFT haskell nnoremap <buffer><silent><Esc><Esc> :<C-u>nohlsearch<CR>:GhcModTypeClear<CR>
AutocmdFT haskell nnoremap <buffer><Leader>ge :<C-u>GhcModExpand<CR>
Autocmd BufWritePost *.hs GhcModCheckAndLintAsync
let g:ghcmod_open_quickfix_function = s:SID . 'open_quickfix_with_unite'
function! s:open_quickfix_with_unite() abort
    Unite -no-empty -no-start-insert quickfix
endfunction
"}}}

" vim2hs.vim {{{
" quasi operator highlight is broken (2012/09/26 (Wed) 05:07)
let g:haskell_quasi = 0
" disable conceal settings because multi-byte signs are broken in a console
let g:haskell_conceal = 0
" relieve load on highlighting
let g:haskell_sql = 0
let g:haskell_json = 0
let g:haskell_xml = 0
let g:haskell_hsp = 0
" }}}

" inu-snippets {{{
let g:neosnippet#snippets_directory = $HOME . '/.vim/bundle/inu-snippets/snippets'
"}}}

" vim-alignta {{{
let g:alignta_default_options   = '<<<0:0'
let g:alignta_default_arguments = '\s'
vnoremap <expr><leader>al   ':Alignta 1:1 '.nr2char(getchar())."\<CR>"
vnoremap <Leader>aa :Alignta<CR>
vnoremap <Leader>ae :Alignta <<<1 =<CR>
vnoremap <Leader>a= :Alignta <<<1 =<CR>
vnoremap <Leader>a, :Alignta ,<CR>
vnoremap <Leader>a> :Alignta =><CR>

vnoremap <expr>x ':Alignta 1:1 '.nr2char(getchar())."\<CR>"

let g:unite_source_alignta_preset_arguments = [
      \ ["Align at '='", '11 =>\='],
      \ ["Align at ':'", '01 :'],
      \ ["Align at '|'", '|'   ],
      \ ["Align at ')'", '0 )' ],
      \ ["Align at ']'", '0 ]' ],
      \ ["Align at '}'", '}'   ],
      \ ["Align at '>'", '0 >' ],
      \ ["Align at '('", '0 (' ],
      \ ["Align at '['", '0 [' ],
      \ ["Align at '{'", '{'   ],
      \ ["Align at '<'", '0 <' ],
      \ ["Align at ','", '01 ,' ],
      \ ['Align first spaces', '0 \s/1' ],
      \]

let g:unite_source_alignta_preset_options = [
      \ ['Justify Left',             '<<' ],
      \ ['Justify Center',           '||' ],
      \ ['Justify Right',            '>>' ],
      \ ['Justify None',             '==' ],
      \ ['Shift Left',               '<-' ],
      \ ['Shift Right',              '->' ],
      \ ['Shift Left  [Tab]',        '<--'],
      \ ['Shift Right [Tab]',        '-->'],
      \ ['Margin 0:0',               '0'  ],
      \ ['Margin 0:1',               '01' ],
      \ ['Margin 1:0',               '10' ],
      \ ['Margin 1:1',               '1'  ],
      \ [' : (key: val)',            '01 :'],
      \ [' , (ruby array #comment)', ',\zs 0:1 #'],
      \ ['Not space',                '\S\+'],
      \]

" }}}

" endwize.vim "{{{
" 自動挿入された end の末尾に情報を付け加える e.g. end # if hoge

let g:endwize_add_verbose_info_filetypes = ['c', 'cpp']
AutocmdFT dachs
    \ let b:endwize_addition = '\=submatch(0)=="let" ? "in" : "end"' |
    \ let b:endwize_words = 'func,proc,if,unless,case,for,do,let,class,init' |
    \ let b:endwize_pattern = '^\s*\%(in\s\+\|+\s\+\|-\s\+\)\=\zs\%(func\|proc\|if\|unless\|case\|for\|class\|init\)\>\%(.*[^.:@$]\<end\>\)\@!\|\<do\ze\%(\s*|.*|\|\<let\>\%(.*[^.:@$]\<in\>\)\@!\)\=\s*$' |
    \ let b:endwize_syngroups = 'dachsConditional,dachsControl,dachsFuncDefine,dachsRepeat,dachsClassDefine' |
    \ let b:endwize_comment = '#'
AutocmdFT vimspec
    \ let b:endwize_addition = 'End' |
    \ let b:endwize_words = 'Describe,Context,It,Before,After' |
    \ let b:endwize_syngroups = 'vimspecCommand' |
    \ let b:endwize_comment = '"'
"}}}

" open-browser.vim "{{{
nmap <Leader>o <Plug>(openbrowser-smart-search)
xmap <Leader>o <Plug>(openbrowser-smart-search)
vnoremap <Leader>O :OpenGithubFile<CR>
nnoremap <Leader>O :<C-u>OpenGithubFile<CR>
function! s:open_github_here() abort
    let [number, start, end] = matchstrpos(getline('.'), '#\d\+')
    if number ==# ''
        let l = line('.')
        call openbrowser#github#file([], 1, l, l)
        return
    endif

    let idx = col('.') - 1
    if idx < start || end < idx
        let l = line('.')
        call openbrowser#github#file([], 1, l, l)
        return
    endif

    execute 'OpenGithubIssue' number[1:]
endfunction
command! -nargs=0 -bar GitHubHere call <SID>open_github_here()
"}}}

" clever-f.vim "{{{
let g:clever_f_smart_case = 1
let g:clever_f_across_no_line = 1
let g:clever_f_use_migemo = 1
"}}}

" ZoomWin {{{
nnoremap <C-w>o :<C-u>ZoomWin<CR>
"}}}

" clang_complete {{{
let g:clang_complete_auto = 0
let g:clang_auto_select = 1
" let g:clang_make_default_keymappings = 0
" }}}

" submode.vim {{{
let g:submode_keep_leaving_key = 1
" タブ移動
call submode#enter_with('changetab', 'n', '', 'gt', 'gt')
call submode#enter_with('changetab', 'n', '', 'gT', 'gT')
call submode#map('changetab', 'n', '', 't', 'gt')
call submode#map('changetab', 'n', '', 'T', 'gT')
" ウィンドウサイズ変更
call submode#enter_with('winsize', 'n', '', '<C-w>>', '<C-w>>')
call submode#enter_with('winsize', 'n', '', '<C-w><', '<C-w><')
call submode#enter_with('winsize', 'n', '', '<C-w>+', '<C-w>-')
call submode#enter_with('winsize', 'n', '', '<C-w>-', '<C-w>+')
call submode#map('winsize', 'n', '', '>', '<C-w>>')
call submode#map('winsize', 'n', '', '<', '<C-w><')
call submode#map('winsize', 'n', '', '+', '<C-w>-')
call submode#map('winsize', 'n', '', '-', '<C-w>+')
" changelist
call submode#enter_with('change-list', 'n', '', 'g;', 'g;')
call submode#enter_with('change-list', 'n', '', 'g,', 'g,')
call submode#map('change-list', 'n', '', ';', 'g;')
call submode#map('change-list', 'n', '', ',', 'g,')
" vim-altr
call submode#enter_with('altr', 'n', 's', 'sa', ':<C-u>call altr#forward()<CR>')
call submode#enter_with('altr', 'n', 's', 'sA', ':<C-u>call altr#back()<CR>')
call submode#map('altr', 'n', 'r', 'a', 'sa')
call submode#map('altr', 'n', 'r', 'A', 'sA')
" }}}

" vim-altr {{{
let s:bundle = neobundle#get('vim-altr')
function! s:bundle.hooks.on_source(bundle) abort
    " for vimrc
    if has('mac')
        call altr#define('.vimrc', '.gvimrc', '.mac.vimrc')
    elseif has('win32') || has('win64')
        call altr#define('_vimrc', '_gvimrc')
    elseif has('unix')
        call altr#define('.vimrc', '.gvimrc', '.linux.vimrc')
    endif
    call altr#define('dotfiles/vimrc', 'dotfiles/gvimrc',
                   \ 'dotfiles/mac.vimrc', 'dotfiles/linux.vimrc')
    " Ruby
    call altr#define('%.rb', 'spec/%_spec.rb')
    " Crystal
    call altr#define('%.cr', 'spec/%_spec.cr')
    " golang
    call altr#define('%.go', '%_test.go')
endfunction
unlet s:bundle
" }}}

" vim-airline "{{{
let g:airline#extensions#whitespace#enabled = 0
"}}}

" memolist.vim "{{{
nnoremap <Leader>mn :<C-u>MemoNew<CR>
nnoremap <silent><Leader>ml :<C-u>call <SID>memolist()<CR>
nnoremap <Leader>mg :<C-u>execute 'Unite' 'grep:'.g:memolist_path '-auto-preview'<CR>

if isdirectory(expand('~/Dropbox/memo'))
    let g:memolist_path = expand('~/Dropbox/memo')
else
    let s:dir = expand('~/.vim/memo')
    if !isdirectory(s:dir)
        call mkdir(s:dir, 'p')
    endif
    let g:memolist_path = s:dir
    unlet s:dir
endif

let g:memolist_memo_suffix = 'md'
let g:memolist_unite = 1

function! s:memolist() abort
    " delete swap files because they make unite auto preview hung up
    for swap in glob(g:memolist_path.'/.*.sw?', 1, 1)
        if swap !~# '^\.\+$' && filereadable(swap)
            call delete(swap)
        endif
    endfor

    MemoList
endfunction
"}}}

" migemo-search.vim {{{
if executable('cmigemo')
    cnoremap <expr><CR> getcmdtype() =~# '^[/?]$' ? migemosearch#replace_search_word()."\<CR>zv" : "\<CR>"
endif
"}}}

" vim-fugitive {{{
nnoremap <Leader>gs :<C-u>Gstatus<CR>
nnoremap <Leader>gC :<C-u>Gcommit -v<CR>
function! s:fugitive_commit() abort
    ZoomWin
    Gcommit -v
    silent only
    if getline('.') ==# ''
        startinsert
    endif
endfunction
nnoremap <Leader>gc :<C-u>call <SID>fugitive_commit()<CR>
nnoremap <Leader>gl :<C-u>QuickRun sh -src 'git log --graph --oneline'<CR>
nnoremap <Leader>ga :<C-u>Gwrite<CR>
nnoremap <Leader>gd :<C-u>Gdiff<CR>
nnoremap <Leader>gb :<C-u>Gblame<CR>

let s:bundle = neobundle#get('vim-fugitive')
function! s:bundle.hooks.on_post_source(bundle) abort
    doautoall fugitive BufReadPost
    AutocmdFT fugitiveblame nnoremap <buffer>? :<C-u>SmartHelp :Gblame<CR>
    AutocmdFT gitcommit     if expand('%:t') ==# 'index' | nnoremap <buffer>? :<C-u>SmartHelp :Gstatus<CR> | endif
endfunction
unlet s:bundle
" }}}

" vim-window-adjuster {{{
" カレントウィンドウをリサイズ
nnoremap <silent><C-w>r :<C-u>AdjustWindowWidth --margin=1 --direction=shrink<CR>
"}}}

" EasyMotion {{{
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
" Avoid hit an enter bug of vim-easymotion
" https://github.com/easymotion/vim-easymotion/issues/308
let g:EasyMotion_verbose = 0
map : <Plug>(easymotion-overwin-f2)
" }}}

" wandbox-vim {{{
let g:wandbox#echo_command = 'echomsg'
let g:wandbox#default_compiler = get(g:, 'wandbox#default_compiler', {'cpp' : 'gcc-head,clang-head'})
noremap <Leader>wb :<C-u>Wandbox<CR>
"}}}

" tern_for_vim {{{
let s:hooks = neobundle#get_hooks('tern_for_vim')
function! s:hooks.on_source(bundle) abort
    call s:setup_tern()
endfunction
unlet s:hooks
function! s:setup_tern() abort
    nnoremap <buffer><Leader>td :<C-u>TernDef<CR>
    nnoremap <buffer><Leader>tk :<C-u>TernDoc<CR>
    nnoremap <buffer><silent><Leader>tt :<C-u>TernType<CR>
    nnoremap <buffer><Leader>tK :<C-u>TernRefs<CR>
    nnoremap <buffer><Leader>tr :<C-u>TernRename<CR>
endfunction
"}}}

" emmet-vim {{{
let g:user_emmet_mode = 'ivn'
let g:user_emmet_leader_key = '<C-Y>'
let g:use_emmet_complete_tag = 1
let g:user_emmet_settings = { 'lang' : 'ja' }
"}}}

" IndentGuide {{{
let s:bundle = neobundle#get('vim-indent-guides')
function! s:bundle.hooks.on_post_source(bundle) abort
    let g:indent_guides_guide_size = 1
    let g:indent_guides_auto_colors = 1
    if !has('gui_running') && &t_Co >= 256
        let g:indent_guides_auto_colors = 0
        Autocmd VimEnter,Colorscheme * hi IndentGuidesOdd  ctermbg=233
        Autocmd VimEnter,Colorscheme * hi IndentGuidesEven ctermbg=240
    endif
    call indent_guides#enable()
endfunction
unlet s:bundle
" }}}

" jedi-vim {{{
let g:jedi#auto_initialization = 0
let g:jedi#auto_vim_configuration = 0
let g:jedi#popup_select_first = 0
" 2 means showing call signatures in command-line area
let g:jedi#show_call_signatures = 2

function! s:jedi_settings() abort
    nnoremap <buffer><Leader>jr :<C-u>call jedi#rename()<CR>
    nnoremap <buffer><Leader>jg :<C-u>call jedi#goto_assignments()<CR>
    nnoremap <buffer><Leader>jd :<C-u>call jedi#goto_definitions()<CR>
    nnoremap <buffer>K :<C-u>call jedi#show_documentation()<CR>
    nnoremap <buffer><Leader>ju :<C-u>call jedi#usages()<CR>
    nnoremap <buffer><Leader>ji :<C-u>Pyimport<Space>
    setlocal omnifunc=jedi#completions
    command! -nargs=0 JediRename call jedi#rename()
endfunction

AutocmdFT python call <SID>jedi_settings()
" }}}

" committia.vim {{{
let g:committia_hooks = {}
function! g:committia_hooks.edit_open(info) abort
    " Additional settings
    setlocal spell

    " If no commit message, start with insert mode
    if getline(1) ==# ''
        startinsert
    end

    imap <buffer><C-n> <Plug>(committia-scroll-diff-down-half)
    imap <buffer><C-p> <Plug>(committia-scroll-diff-up-half)
endfunction
" }}}

" gist-vim {{{
let g:gist_open_browser_after_post = 1
" }}}

" vim-prettyprint {{{
function! AP(...) abort
    silent tabnew! +:put!\ =call('prettyprint#prettyprint',a:000) __AWESOME_PRINT__
    setlocal ft=vim buftype=nofile
    execute 0
    nnoremap <buffer>q :<C-u>quit!
endfunction
command! -nargs=+ -complete=expression AP call AP(<args>)
" }}}

" vim-table-mode {{{
let g:table_mode_corner = '|'
" }}}

" vim-gitgutter {{{
let g:gitgutter_map_keys = 0
nnoremap <Leader>gg :<C-u>GitGutterLineHighlightsToggle<CR>
nnoremap <Leader>gh :<C-u>GitGutterStageHunk<CR>
nmap <Leader>gp <Plug>GitGutterPreviewHunk
nmap ]h <Plug>GitGutterNextHunk
nmap [h <Plug>GitGutterPrevHunk
omap ih <Plug>GitGutterTextObjectInnerPending
omap ah <Plug>GitGutterTextObjectOuterPending
xmap ih <Plug>GitGutterTextObjectInnerVisual
xmap ah <Plug>GitGutterTextObjectOuterVisual
" }}}

" vim-gfm-syntax {{{
let g:gfm_syntax_emoji_conceal = 1
" }}}

" vim-grammarous {{{
let g:grammarous#show_first_error = 1
" }}}

" ale {{{
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 0
let g:ale_completion_enabled = 0
let g:ale_fix_on_save = 0
let g:ale_set_balloons = 0

nmap <Leader>al <Plug>(ale_next)
let g:ale_vim_vint_show_style_issues = 0
let s:ale_fixers = {
    \   'javascript': ['eslint', 'prettier'],
    \   'typescript': ['tslint', 'prettier'],
    \   'css': ['prettier'],
    \   'c': ['clang-format'],
    \   'cpp': ['clang-format'],
    \   'python': ['yapf'],
    \   'rust': ['rustfmt'],
    \   'json': ['fixjson'],
    \ }
let g:ale_linters = {
    \   'python': ['pylint', 'mypy'],
    \ }
let g:ale_fixers = s:ale_fixers
AutocmdFT typescript,javascript,css,c,cpp,python,rust,json let b:ale_fix_on_save = 1
function! s:toggle_ale_fix(bang) abort
    if a:bang
        if empty(g:ale_fixers)
            let g:ale_fixers = s:ale_fixers
            echo 'Enabled ALE fixer (global)'
        else
            let g:ale_fixers = {}
            echo 'Disabled ALE fixer (global)'
        endif
        return
    endif
    if !exists('b:ale_fix_on_save') || !b:ale_fix_on_save
        let b:ale_fix_on_save = 1
        echo 'Enabled ALE fixer'
    else
        let b:ale_fix_on_save = 0
        echo 'Disabled ALE fixer'
    endif
endfunction
command! -nargs=0 -bar -bang ALEToggleFix call <SID>toggle_ale_fix(<bang>0)
" }}}

" dirvish {{{
function! s:on_dirvish() abort
    nnoremap <buffer><silent>l :<C-u>.call dirvish#open('edit', 0)<CR>
    nmap <buffer><silent>h <Plug>(dirvish_up)
    nnoremap <buffer><silent>O :<C-u>execute 'OpenBrowser' getline('.')<CR>
    nnoremap <buffer>/ :<C-u>Unite dirvish<CR>
endfunction
augroup dirvish-vimrc
    autocmd!
    autocmd FileType dirvish call <SID>on_dirvish()
augroup END
let g:loaded_netrwPlugin = 1
nnoremap <Leader>f <Nop>
nnoremap <silent><Leader><Leader> :<C-u>Dirvish<CR>
nnoremap <silent><Leader>ff :<C-u>execute 'Dirvish' expand('%:p:h')<CR>
nnoremap <silent><Leader>fs :<C-u>botright vsplit <Bar> Dirvish<CR>
nnoremap <silent><expr><Leader>fg ":\<C-u>Dirvish " . <SID>git_root_dir() . "\<CR>"
" }}}

" auto-git-diff {{{
function! s:setup_auto_git_diff() abort
    nmap <buffer><C-n> <Plug>(auto_git_diff_scroll_down_half)
    nmap <buffer><C-p> <Plug>(auto_git_diff_scroll_up_half)
endfunction
AutocmdFT gitrebase call <SID>setup_auto_git_diff()
" }}}

" vim-highlightedyank {{{
if !exists('##TextYankPost')
    map y <Plug>(highlightedyank)
endif
" }}}

" プラットフォーム依存な設定をロードする "{{{
function! SourceIfExist(path) abort
    if filereadable(a:path)
        execute 'source' a:path
    endif
endfunction

if has('mac')
    " 不可視文字
    set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%

    " option キーを Alt として使う．
    if exists('+macmeta')
        set macmeta
    endif

    AutocmdFT cpp setlocal path=.,/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1,/usr/local/include,/usr/include

    " Mac の辞書.appで開く {{{
    " 引数に渡したワードを検索
    command! -range -nargs=? MacDict call system('open ' . shellescape('dict://' . <q-args>))
    " キーマッピング
    AutocmdFT gitcommit,markdown nnoremap <buffer>K :<C-u>call system('open ' . shellescape('dict://' . expand('<cword>')))<CR>
    "}}}

    " unite-ruby-require.vim
    let g:unite_source_ruby_require_ruby_command = $HOME . '/.rbenv/shims/ruby'

    " airline
    let g:airline_left_sep = '»'
    let g:airline_right_sep = '«'

    " gist-vim
    let g:gist_clip_command = 'pbcopy'

    " ale
    if filereadable('/usr/local/opt/llvm/bin/llc')
        let g:ale_llvm_llc_executable = '/usr/local/opt/llvm/bin/llc'
    endif
elseif has('unix')
    " 不可視文字
    set listchars=tab:>-,trail:-,eol:$,extends:>,precedes:<,nbsp:%
    " 256色使う
    set t_Co=256
" elseif has('win32') || has('win64')
endif

call SourceIfExist($HOME . '/.local.vimrc')
"}}}

" vim: set ft=vim fdm=marker ff=unix fileencoding=utf-8:
