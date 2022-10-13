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

let s:on_win = has('win32')
let s:on_mac = has('mac')

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
" 自前で用意したものへの path
set path=.,/usr/include,/usr/local/include
" 補完でプレビューウィンドウを開かない
set completeopt=menuone,longest,noselect
" メニューの言語
set langmenu=none
" foldingの設定
set foldenable
set foldmethod=marker
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
set directory=~/.vim/swap
if !isdirectory(&directory)
    call mkdir(&directory, 'p')
endif
" 編集履歴を保存して終了する
if has('persistent_undo')
    set undofile
    set undodir=~/.vim/undo
    if !isdirectory(&undodir)
        call mkdir(&undodir, 'p')
    endif
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
set backupskip=/tmp/*,/private/tmp/*,/var/*

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
" vim-lsp の quickpick は選択中のアイテムの表示のために cursorline を使うので，その設定を変更しない
Autocmd CursorMoved,CursorMovedI,WinLeave * noautocmd if &filetype !=# 'lsp-quickpick' | setlocal nocursorline | endif
Autocmd CursorHold,CursorHoldI,WinEnter * noautocmd if &filetype !=# 'lsp-quickpick' | setlocal cursorline | endif

" git config file
Autocmd BufRead,BufNew,BufNewFile gitconfig setlocal ft=gitconfig
" Gnuplot のファイルタイプを設定
Autocmd BufRead,BufNew,BufNewFile *.plt,*.plot,*.gnuplot setlocal ft=gnuplot
" Ruby の guard 用ファイル
Autocmd BufRead,BufNew,BufNewFile Guardfile setlocal ft=ruby
" Swift
Autocmd BufRead,BufNew,BufNewFile *.swift setlocal ft=swift
" Mal,Crisp
Autocmd BufRead,BufNew,BufNewFile *.mal,*.crisp setlocal ft=lisp
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
            \ echo 'hi<' . synIDattr(synID(line('.'), col('.'), 1), 'name') . '>trans<'
            \ . synIDattr(synID(line('.'), col('.'), 0), 'name') . '>lo<'
            \ . synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name') . '>'

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
    let target_buftype  = ['help', 'quickfix', 'nofile', 'terminal', 'acwrite']

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
command! Vimrc execute 'args' $MYVIMRC $MYGVIMRC

" カレントパスをクリプボゥにコピー
command! CopyCurrentPath :call s:copy_current_path()
function! s:copy_current_path() abort
    if s:on_win
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
command! -bang -bar -nargs=1 SetIndent
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
" <C-c> をオムニ補完に使う
inoremap <C-c> <C-x><C-o>
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
" {数値}<Tab>でその行へ移動．それ以外だと通常の<Tab>の動きに
function! s:go_to_line() abort
    set number
    augroup vimrc-go-to-line
        autocmd!
        autocmd InsertEnter,CursorHold * set nonumber | autocmd! vimrc-go-to-line
    augroup END
    return 'G'
endfunction
noremap <expr><Tab> v:count != 0 ? <SID>go_to_line() : "\<Tab>zvzz"
" Tab で補完候補選択
inoremap <silent><expr><Tab> pumvisible() ? "\<C-y>" : "\<Tab>"
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
nnoremap <expr><Leader>cl ":\<C-u>set colorcolumn=".(&cc == 0 ? v:count == 0 ? virtcol('.') : v:count : 0)."\<CR>"

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

if exists(':terminal')
    if exists('+termwinkey')
        set termwinkey=<Esc>
    else
        set termkey=<Esc>
    endif
    function! s:open_terminal() abort
        let terms = term_list()
        if !empty(terms)
            let w = bufwinnr(terms[0])
            if w != -1
                execute w . 'wincmd w'
            else
                execute winwidth(0) >= 160 ? 'vsplit' : 'split' '| bufffer' terms[0]
            endif
            return
        endif
        let shell = ''
        if s:on_win
            let shell = ' powershell'
        endif
        execute 'topleft' winwidth(0) >= 160 ? 'vsplit' : 'split' ' | terminal ++curwin ++close' . shell
    endfunction
    nnoremap <silent><Space><Space> :<C-u>call <SID>open_terminal()<CR>
    " XXX: This kills original <Esc><Esc>, which sends raw '<Esc>' to shell
    tmap <Esc><Esc> <Esc>N
    " Guard with exists() since it's very new (added at Vim 8.1)
    if exists('##TerminalOpen')
        Autocmd TerminalOpen * if &buftype ==# 'terminal' | setlocal listchars= | endif
    endif

    if s:on_win
        tnoremap <C-p> <Up>
        tnoremap <C-n> <Down>
        tnoremap <C-f> <Right>
        tnoremap <C-b> <Left>
        tnoremap <C-a> <Home>
        tnoremap <C-e> <End>
    endif
endif
" }}}
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
let s:bundles_dir = expand('~/.vim/bundle')
if !isdirectory(s:bundles_dir)
    echon 'Installing neobundle.vim...'
    if !isdirectory(s:bundles_dir)
        call mkdir(s:bundles_dir, 'p')
    endif
    if !s:on_win
        silent !git clone https://github.com/Shougo/neobundle.vim $HOME/.vim/bundle/neobundle.vim
    else
        " $HOME does not work on cmd.exe
        execute 'silent' '!git' 'clone' 'https://github.com/Shougo/neobundle.vim' expand('~/.vim/bundle/neobundle.vim')
    endif
    echo 'done.'
    if v:shell_error
        echoerr 'neobundle.vim installation has failed!'
        finish
    endif
endif

if has('vim_starting')
    set rtp+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('~/.vim/bundle'))

if neobundle#load_cache()
    " GitHub上のリポジトリ
    call neobundle#add('Shougo/neobundle.vim', { 'fetch': 1 })
    call neobundle#add('Shougo/vimproc.vim', {
                \   'build' : {
                \     'windows' : 'echo "Please build vimproc manually."',
                \     'cygwin'  : 'make -f make_cygwin.mak',
                \     'mac'     : 'make -f make_mac.mak',
                \     'unix'    : 'make -f make_unix.mak',
                \   }
                \ })
    call neobundle#add('Shougo/neosnippet.vim')
    call neobundle#add('rhysd/inu-snippets')
    call neobundle#add('thinca/vim-quickrun')
    call neobundle#add('vim-jp/vimdoc-ja')
    call neobundle#add('kana/vim-textobj-user')
    call neobundle#add('thinca/vim-prettyprint')
    call neobundle#add('kana/vim-operator-user')
    call neobundle#add('h1mesuke/vim-alignta')
    call neobundle#add('rhysd/clever-f.vim')
    call neobundle#add('airblade/vim-gitgutter')
    call neobundle#add('kana/vim-submode')
    call neobundle#add('vim-airline/vim-airline')
    call neobundle#add('vim-airline/vim-airline-themes')
    call neobundle#add('rhysd/conflict-marker.vim')
    call neobundle#add('rhysd/vim-window-adjuster')
    call neobundle#add('Shougo/neomru.vim')
    call neobundle#add('rhysd/committia.vim')
    call neobundle#add('rust-lang/rust.vim')
    call neobundle#add('cespare/vim-toml')
    call neobundle#add('slim-template/vim-slim')
    call neobundle#add('HerringtonDarkholme/yats.vim')
    call neobundle#add('keith/tmux.vim')
    call neobundle#add('rhysd/npm-filetypes.vim')
    call neobundle#add('rhysd/github-complete.vim')
    call neobundle#add('vim-crystal/vim-crystal')
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
    call neobundle#add('machakann/vim-highlightedyank')
    call neobundle#add('PProvost/vim-ps1')
    call neobundle#add('rhysd/vim-github-actions')
    call neobundle#add('rhysd/vim-notes-cli')
    call neobundle#add('rhysd/git-messenger.vim')
    call neobundle#add('prabirshrestha/vim-lsp')
    call neobundle#add('rhysd/vim-lsp-ale')
    call neobundle#add('ziglang/zig.vim')
    call neobundle#add('DingDean/wgsl.vim')

    " unite.vim sources
    call neobundle#add('Shougo/unite-outline')
    call neobundle#add('Shougo/unite-help')
    call neobundle#add('thinca/vim-unite-history')
    call neobundle#add('rhysd/unite-zsh-cdr.vim')
    call neobundle#add('rhysd/unite-ruby-require.vim')
    call neobundle#add('ujihisa/unite-colorscheme')
    call neobundle#add('rhysd/unite-locate')
    call neobundle#add('sorah/unite-ghq')
    call neobundle#add('rhysd/unite-go-import.vim')
    call neobundle#add('rhysd/unite-oldfiles.vim')
    call neobundle#add('rhysd/unite-dirvish.vim')

    " カラースキーム
    call neobundle#add('rhysd/wallaby.vim')
    call neobundle#add('rhysd/vim-color-spring-night')
    call neobundle#add('chriskempson/tomorrow-theme', {'rtp' : 'vim'})
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

    call neobundle#add('haya14busa/vim-asterisk', {
                \ 'lazy' : 1,
                \ 'autoload' : {
                \     'mappings' : '<Plug>(asterisk-',
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

    " Haskell 用プラグイン
    call neobundle#add('ujihisa/unite-haskellimport', {
                \ 'lazy' : 1,
                \ 'autoload' : {'filetypes' : 'haskell'}
                \ })
    call neobundle#add('eagletmt/unite-haddock', {
                \ 'lazy' : 1,
                \ 'autoload' : {'filetypes' : 'haskell'}
                \ })
    call neobundle#add('eagletmt/ghcmod-vim', {
                \ 'lazy' : 1,
                \ 'autoload' : {'filetypes' : 'haskell'}
                \ })

    " Python
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
               \     'filetypes' : ['go', 'gomod'],
               \     'commands' : ['GoImport', 'GoDrop', 'GoDef', 'GoVet', 'GoDoc', 'GoLint', 'GoRename', 'GoImports']
               \   }
               \ })

    " LLVM IR
    call neobundle#add('rhysd/vim-llvm')

    " Swift
    " Delay loading because it contains plugin/ directory
    call neobundle#add('keith/swift.vim', {
                \ 'lazy' : 1,
                \ 'autoload' : {
                \     'filetypes' : 'swift'
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
    let dir = expand('%:p:h')
    let gitdir = gitmessenger#git#root_dir(dir)
    if gitdir ==# ''
        throw 'Outside of Git repository: ' . dir
    endif
    return gitdir
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
        packadd matchit
    else
        runtime macros/matchit.vim
    endif
    let s:matchit_loaded = 1
endfunction
AutocmdFT vim,zsh,sh,ruby,ocaml,make,html,xml,rust call <SID>matchit()

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

" scope 演算子用に ;; を :: に置き換える
function! s:double_semi() abort
    if getline('.')[col('.')-2] ==# ';'
        return "\<BS>::"
    endif
    return ';'
endfunction
AutocmdFT cpp,rust,ruby inoremap <silent><buffer><expr>; <SID>double_semi()
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
        if has('termguicolors') && $COLORTERM ==# 'truecolor'
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

    let m = matchlist(current_line, '^\(\s*\)\([^"]\+\)\s*:$')
    if m ==# []
        return
    endif

    let [prefix, key] = m[1:2]
    call setline('.', prefix . '"' . key . '": ')
    let diff = len(getline('.')) - len(current_line)
    execute 'normal!' (diff > 0 ? diff . 'l' : -diff . 'h')
endfunction

AutocmdFT json inoremap <buffer>: :<C-o>:call <SID>json_colon()<CR>
AutocmdFT json inoremap <buffer><C-j> <End>,<CR>
AutocmdFT json SetIndent 2
" foldmethod=syntax is not allowed with neocomplete
" AutocmdFT json setlocal foldmethod=syntax foldlevel=99
" }}}

" Python {{{
function! s:python_settings() abort
    setlocal noautoindent nosmartindent nocindent
    syntax keyword Constant self
endfunction
AutocmdFT python call <SID>python_settings()
Autocmd BufRead,BufNew,BufNewFile *.pyi setlocal filetype=python
"}}}

" Go {{{
function! s:toggle_access() abort
    let before = expand('<cword>')
    if before ==# ''
        echoerr 'No identifier found under cursor'
        return
    endif
    let after = ''
    let c = before[0]
    if c =~# '\l'
        let after = toupper(c) . before[1:]
    elseif before[0] =~# '\u'
        let after = tolower(c) . before[1:]
    endif
    if after ==# ''
        echoerr "Word '" . before . "' does not start with uppder case nor lower case"
        return
    endif
    execute 'GoRename' after
endfunction

function! s:golang_settings() abort
    setlocal noexpandtab

    let g:go_def_mapping_enabled = 0
    let g:go_code_completion_enabled = 0
    let g:go_gopls_enabled = 0
    let g:go_doc_keywordprg_enabled = 0
    let g:go_diagnostics_enabled = 0

    let g:go_snippet_engine = ''
    let g:go_highlight_trailing_whitespace_error = 0
    let g:go_play_open_browser = 1
    let g:go_highlight_chan_whitespace_error = 0
    let g:go_highlight_extra_types = 0
    let g:go_highlight_space_tab_error = 0
    let g:go_highlight_array_whitespace_error = 0
    let g:go_highlight_functions = 1
    let g:go_metalinter_autosave_enabled = []
    let g:go_fmt_command = 'goimports'

    nnoremap <buffer><Space>i :<C-u>Unite go/import -start-insert<CR>
    nnoremap <buffer><Leader>i :<C-u>GoImports<CR>
    inoremap <buffer><C-g><C-i> <C-o>:GoImports<CR>
    nnoremap <buffer><Leader>gt :<C-u>GoTestFunc<CR>
    nnoremap <buffer><Leader>gr :<C-u>GoRename<Space>
    nnoremap <buffer><Leader>gi :<C-u>execute 'GoImport' expand('<cword>')<CR>
    nnoremap <buffer><Leader>gn :<C-u>GoSameIds<CR>
    command! -buffer -nargs=0 -bar GoToggleAccess call <SID>toggle_access()
endfunction

AutocmdFT go call <SID>golang_settings()
function! s:setup_godoc() abort
    nnoremap<buffer>q :<C-u>quit<CR>
    nnoremap<buffer>d <C-d>
    nnoremap<buffer>u <C-u>
    nnoremap<buffer>o :<C-u>Unite outline<CR>
    nnoremap<buffer>? :<C-u>echo 'q=quit, d=down, u=up, o=outline'<CR>
endfunction
AutocmdFT godoc call <SID>setup_godoc()

Autocmd BufRead,BufNew,BufNewFile go.mod setlocal filetype=gomod
Autocmd BufRead,BufNew,BufNewFile go.sum setlocal filetype=
" }}}

" Rust {{{
let g:rust_recommended_style = 0

function! s:rust_analyzer_open_docs_callback(context) abort
    if !has_key(a:context, 'response')
        echohl ErrorMsg | echom 'experimental/externalDocs returned with no response: ' . string(a:context) | echohl None
        return
    endif
    let res = a:context['response']
    if has_key(res, 'error')
        let err = res['error']
        echohl ErrorMsg | echom printf('experimental/externalDocs returned an error: %s (code=%d)', err['message'], err['code']) | echohl None
        return
    endif
    if !has_key(res, 'result')
        echohl ErrorMsg | echom 'experimental/externalDocs returned with no result: ' . string(res) | echohl None
        return
    endif
    if res['result'] == v:null
        " Fallback to opening something under cursor with open-browser.vim
        execute 'normal' "\<Plug>(openbrowser-smart-search)"
        return
    endif
    execute 'OpenBrowser' res['result']
endfunction

function! s:rust_analyzer_open_docs() abort
    let params = {
    \   'textDocument': lsp#get_text_document_identifier(),
    \   'position': lsp#get_position(),
    \ }
    call lsp#send_request('rust-analyzer', {
    \   'method': 'experimental/externalDocs',
    \   'params': params,
    \   'sync': v:false,
    \   'on_notification': function('s:rust_analyzer_open_docs_callback')
    \ })
endfunction

function! s:setup_rust() abort
    command! -buffer -nargs=0 -bar RustDoc call <SID>rust_analyzer_open_docs()
    noremap <buffer><Leader>t :<C-u>RustTest<CR>
    nnoremap <buffer><Leader>o :<C-u>RustDoc<CR>
endfunction
AutocmdFT rust call <SID>setup_rust()
" }}}

" TypeScript {{{
let g:yats_host_keyword = 0
" }}}

" Zsh {{{
let g:zsh_fold_enable = 0

let s:sh_template = ['#!/bin/bash', '']
Autocmd BufNewFile *.sh call append(0, s:sh_template) | normal! G
let s:zsh_template = ['#!/usr/bin/env zsh', '']
Autocmd BufNewFile *.zsh call append(0, s:zsh_template) | normal! G
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

" YAML {{{
AutocmdFT yaml SetIndent 2
" }}}

" Zig {{{
let g:zig_fmt_parse_errors = 0
" }}}

" vim-lsp {{{
let g:lsp_fold_enabled = 0

" Disable document preview since it hides signatures of completion items
let g:lsp_documentation_float = 0
" Hide 'A>' sign for code action
let g:lsp_document_code_action_signs_enabled = 0
" Uncomment for debugging
" let g:lsp_log_file = 'vim-lsp-log.txt'

function! s:rust_analyzer_apply_source_change(context) abort
    let command = get(a:context, 'command', {})

    let arguments = get(command, 'arguments', [])
    let argument = get(arguments, 0, {})

    let workspace_edit = get(argument, 'workspaceEdit', {})
    if !empty(workspace_edit)
        call lsp#utils#workspace_edit#apply_workspace_edit(workspace_edit)
    endif

    let cursor_position = get(argument, 'cursorPosition', {})
    if !empty(cursor_position)
        call cursor(lsp#utils#position#lsp_to_vim('%', cursor_position))
    endif
endfunction

function! s:rust_analyzer_run_single(context) abort
    let command = get(a:context, 'command', {})
    let arguments = get(command, 'arguments', [])
    let argument = get(arguments, 0, {})

    if !has_key(argument, 'kind')
        throw printf('Unsupported rust-analyzer.runSingle command. command=%s, arg=%s', string(command), string(argument))
    endif

    if argument['kind'] ==# 'cargo'
        let label = get(argument, 'label', 'cargo')
        let args = get(argument, 'args', {})
        let workspaceRoot = get(args, 'workspaceRoot', getcwd())
        let cargoArgs = get(args, 'cargoArgs', [])
        let cargoExtraArgs = get(args, 'cargoExtraArgs', [])
        let executableArgs = get(args, 'executableArgs', [])
        let cmd = ['cargo'] + cargoArgs + cargoExtraArgs

        if !empty(executableArgs)
            let cmd += ['--'] + executableArgs
        endif

        call term_start(cmd, {'cwd': workspaceRoot})
    else
        throw printf('unsupported rust-analyzer.runSingle command. command=%s, arg=%s', string(command), string(argument))
    endif
endfunction

function! s:setup_lsp() abort
    if executable('pyls')
        " pip install python-language-server
        call lsp#register_server({
            \ 'name': 'pyls',
            \ 'cmd': { server_info -> ['pyls'] },
            \ 'allowlist': ['python'],
            \ })
    endif

    if executable('rust-analyzer')
        " https://rust-analyzer.github.io/manual.html#rust-analyzer-language-server-binary
        let config = {
        \   'name': 'rust-analyzer',
        \   'cmd': { server_info -> ['rust-analyzer'] },
        \   'allowlist': ['rust'],
        \ }
        let config.initialization_options = {}
        if executable('cargo-clippy')
            let config.initialization_options.checkOnSave = {
                \   'command': 'clippy',
                \   'features': 'all',
                \ }
        endif
        let config.initialization_options.cargo = { 'features': 'all' }
        call lsp#register_server(config)

        call lsp#register_command('rust-analyzer.applySourceChange', function('s:rust_analyzer_apply_source_change'))
        call lsp#register_command('rust-analyzer.runSingle', function('s:rust_analyzer_run_single'))
    endif

    if executable('gopls')
        call lsp#register_server({
            \ 'name': 'gopls',
            \ 'cmd': ['gopls'],
            \ 'allowlist': ['go', 'gomod'],
            \ })
    endif

    if executable('typescript-language-server')
        " npm install -g tyepscript-language-server
        call lsp#register_server({
            \ 'name': 'tyepscript-language-server',
            \ 'cmd': { server_info -> ['typescript-language-server', '--stdio'] },
            \ 'allowlist': ['typescript'],
            \ })
    endif

    if s:on_mac
        " brew install llvm (llvm formula is keg-only)
        let clangd = '/usr/local/opt/llvm/bin/clangd'
    else
        let clangd = 'clangd'
    endif

    if executable(clangd)
        " npm install -g tyepscript-language-server
        call lsp#register_server({
            \ 'name': 'clangd',
            \ 'cmd': { server_info -> [clangd] },
            \ 'allowlist': ['c', 'cpp'],
            \ })
    endif

    if executable('zls')
        " Build from source https://github.com/zigtools/zls
        call lsp#register_server({
            \ 'name': 'zls',
            \ 'cmd': { server_info -> ['zls'] },
            \ 'allowlist': ['zig'],
            \ })
    endif

    if executable('crystalline')
        " pip install python-language-server
        call lsp#register_server({
            \ 'name': 'crystalline',
            \ 'cmd': { server_info -> ['crystalline'] },
            \ 'allowlist': ['crystal'],
            \ })
    endif
endfunction

Autocmd User lsp_setup call s:setup_lsp()

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    if exists('+tagfunc')
        setlocal tagfunc=lsp#tagfunc
    endif

    " Override
    nmap <buffer> gd <Plug>(lsp-definition)
    nmap <buffer> K <Plug>(lsp-hover)
    " Mapping features under <Leader>l
    nmap <buffer> <Leader>ld <plug>(lsp-document-diagnostics)
    nmap <buffer> <Leader>lD <Plug>(lsp-declaration)
    nmap <buffer> <Leader>lh <Plug>(lsp-hover)
    nmap <buffer> <Leader>lr <Plug>(lsp-references)
    nmap <buffer> <Leader>li <Plug>(lsp-implementation)
    nmap <buffer> <Leader>lt <Plug>(lsp-type-definition)
    nmap <buffer> <Leader>lT <Plug>(lsp-type-hierarchy)
    nmap <buffer> <Leader>lR <Plug>(lsp-rename)
    nmap <buffer> <Leader>lw <Plug>(lsp-workspace-symbol)
    nmap <buffer> <Leader>l/ <Plug>(lsp-workspace-symbol-search)
    nmap <buffer> <Leader>ll <Plug>(lsp-code-lens)
    nmap <buffer> <Leader>la <Plug>(lsp-code-action)
    nmap <buffer> <Leader>lco <Plug>(lsp-call-hierarchy-outgoing)
    nmap <buffer> <Leader>lci <Plug>(lsp-call-hierarchy-incoming)
endfunction

Autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()

" Change border of popup. Note that this only affects document hover and
" doesn't affect document preview
Autocmd User lsp_float_opened call popup_setoptions(
        \ lsp#ui#vim#output#getpreviewwinid(),
        \ {
        \   'borderchars': ['─', '│', '─', '│', '┌', '┐', '┘', '└'],
        \   'highlight': 'NormalFloat',
        \ })

function! s:quickpick_wrap(next) abort
    let winid = lsp#internal#ui#quickpick#results_winid()
    if winid == 0
        return
    endif

    if a:next
        let cur = line('.', winid)
        let end = line('$', winid)
        let cmd = cur == end ? 'gg' : 'j'
    else
        let cur = line('.', winid)
        let cmd = cur == 1 ? 'G' : 'k'
    endif

    call win_execute(winid, 'noautocmd normal! ' . cmd)
endfunction

function! s:on_lsp_quickpick() abort
    nmap <silent><buffer> <C-g> <Plug>(lsp-quickpick-cancel)
    imap <silent><buffer> <C-g> <Plug>(lsp-quickpick-cancel)
    nmap <silent><buffer> <Esc> <Plug>(lsp-quickpick-cancel)
    imap <silent><buffer> <Esc> <Plug>(lsp-quickpick-cancel)
    " Dummy mappings to prevent quickpick from overriding below mappings
    nmap <buffer><expr><Nop> <Plug>(lsp-quickpick-move-next)
    nmap <buffer><expr><Nop><Nop> <Plug>(lsp-quickpick-move-previous)
    " Wrap scroll to choosei item
    nnoremap <buffer><C-n> :<C-u>call <SID>quickpick_wrap(1)<CR>
    inoremap <buffer><C-n> <C-o>:call <SID>quickpick_wrap(1)<CR>
    nnoremap <buffer><C-p> :<C-u>call <SID>quickpick_wrap(0)<CR>
    inoremap <buffer><C-p> <C-o>:call <SID>quickpick_wrap(0)<CR>
endfunction
AutocmdFT lsp-quickpick-filter call s:on_lsp_quickpick()
" }}}

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
    if s:on_mac
        let finder = { 'description' : 'open with Finder.app' }
        function! finder.func(candidate) abort
            if a:candidate.kind ==# 'directory'
                call unite#util#system('open -a Finder '.a:candidate.action__path)
            endif
        endfunction
        call unite#custom#action('directory', 'finder', finder)
    endif

    call unite#custom#profile('source/quickfix,source/outline,source/line,source/line,source/grep', 'context', {'prompt_direction' : 'top'})
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
nnoremap [unite]u                :<C-u>Unite source<CR>
"バッファを開いた時のパスを起点としたファイル検索
nnoremap <silent>[unite]ff       :<C-u>UniteWithBufferDir -buffer-name=files -vertical file directory file/new<CR>
"最近使用したファイル
if !s:on_win
    nnoremap <silent>[unite]m    :<C-u>Unite file_mru directory_mru zsh-cdr oldfiles file/new<CR>
else
    nnoremap <silent>[unite]m    :<C-u>Unite file_mru directory_mru oldfiles file/new<CR>
endif
"バッファ一覧
nnoremap <silent>[unite]b        :<C-u>Unite -immediately -no-empty buffer<CR>
"プログラミングにおけるアウトラインの表示
nnoremap <silent>[unite]o        :<C-u>Unite outline -vertical -no-start-insert<CR>
"コマンドの出力
nnoremap <silent>[unite]c        :<C-u>Unite output<CR>
"grep検索．
nnoremap <silent>[unite]gr       :<C-u>Unite -no-start-insert grep<CR>
"Git リポジトリ
nnoremap <silent>[unite]gg       :<C-u>Unite -no-start-insert grep/git<CR>
" Git で管理されているファイルから選んで開く
nnoremap <silent><expr>[unite]gf ":\<C-u>Unite file_rec/git:" . escape(substitute(<SID>git_root_dir(), '\', '/', 'g'), ':') . "\<CR>"
nmap [unite]p [unite]gf
"Uniteバッファの復元
nnoremap <silent>[unite]r        :<C-u>UniteResume<CR>
" C++ インクルードファイル
AutocmdFT cpp nnoremap <buffer>[unite]i :<C-u>Unite file_include -vertical<CR>
" help(項目が多いので，検索語を入力してから絞り込む)
nnoremap <silent>[unite]hh       :<C-u>UniteWithInput help -vertical<CR>
" 履歴
nnoremap <silent>[unite]hc       :<C-u>Unite -buffer-name=lines history/command -start-insert<CR>
nnoremap <silent>[unite]hs       :<C-u>Unite -buffer-name=lines history/search<CR>
nnoremap <silent>[unite]hy       :<C-u>Unite -buffer-name=lines history/yank<CR>
" unite-lines ファイル内インクリメンタル検索
nnoremap <silent><expr> [unite]L line('$') > 5000 ?
            \ ":\<C-u>Unite -no-split -start-insert -auto-preview line\<CR>" :
            \ ":\<C-u>Unite -start-insert -auto-preview line:all\<CR>"
" カラースキーム
nnoremap [unite]C :<C-u>Unite -auto-preview colorscheme<CR>
" locate
nnoremap <silent>[unite]l :<C-u>UniteWithInput locate<CR>
" 検索
nnoremap <silent>[unite]/ :<C-u>execute 'Unite grep:'.expand('%:p').' -input='.escape(substitute(@/, '^\\v', '', ''), ' \')<CR>
" Haskell Import
AutocmdFT haskell nnoremap <buffer>[unite]hd :<C-u>Unite haddock<CR>
AutocmdFT haskell nnoremap <buffer>[unite]ho :<C-u>Unite hoogle<CR>
AutocmdFT haskell nnoremap <buffer><expr>[unite]hi
                    \ empty(expand("<cWORD>")) ? ":\<C-u>Unite haskellimport\<CR>"
                    \ : ":\<C-u>UniteWithCursorWord haskellimport\<CR>"
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
inoremap <CR> <CR><C-r>=endwize#crend()<CR>
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
let g:clever_f_highlight_timeout_ms = 1000
"}}}

" ZoomWin {{{
nnoremap <C-w>o :<C-u>ZoomWin<CR>
"}}}

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
nnoremap <Leader>ga :<C-u>Gwrite <Bar> GitGutter<CR>
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

" EasyMotion {{{
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
" Avoid hit an enter bug of vim-easymotion
" https://github.com/easymotion/vim-easymotion/issues/308
let g:EasyMotion_verbose = 0
map : <Plug>(easymotion-overwin-f2)
" }}}

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
let g:prettyprint_indent = 2
" }}}

" vim-table-mode {{{
let g:table_mode_corner = '|'
" }}}

" vim-gitgutter {{{
let g:gitgutter_map_keys = 0
nnoremap <Leader>gg :<C-u>GitGutterLineHighlightsToggle<CR>
nnoremap <Leader>gh :<C-u>GitGutterStageHunk<CR>
nnoremap <Leader>gu :<C-u>GitGutterUndoHunk<CR>
nnoremap <Leader>gA :<C-u>GitGutterAll<CR>
nmap <Leader>gp <Plug>(GitGutterPreviewHunk)
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)
omap ih <Plug>(GitGutterTextObjectInnerPending)
omap ah <Plug>(GitGutterTextObjectOuterPending)
xmap ih <Plug>(GitGutterTextObjectInnerVisual)
xmap ah <Plug>(GitGutterTextObjectOuterVisual)
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
let g:ale_c_clangformat_options = '-style="{BasedOnStyle: llvm, IndentWidth: 4, ColumnLimit: 0}"'

nmap <Leader>al <Plug>(ale_next)
let g:ale_vim_vint_show_style_issues = 0
let g:ale_sh_shfmt_options = '-i 4'
let s:ale_fixers = {
    \   'javascript': ['prettier'],
    \   'typescript': ['prettier'],
    \   'css': ['stylelint'],
    \   'c': ['clang-format'],
    \   'cpp': ['clang-format'],
    \   'python': ['black', 'yapf'],
    \   'rust': ['rustfmt'],
    \   'json': ['fixjson'],
    \   'sh': ['shfmt'],
    \ }
let g:ale_linters = {
    \   'python': ['pylint', 'mypy', 'vim-lsp'],
    \   'javascript': ['eslint'],
    \   'typescript': ['eslint', 'vim-lsp'],
    \   'go': ['golint', 'vim-lsp'],
    \   'rust': ['vim-lsp'],
    \   'c': ['clang-tidy', 'vim-lsp'],
    \   'cpp': ['clang-tidy', 'vim-lsp'],
    \   'zig': ['vim-lsp'],
    \   'wgsl': ['naga'],
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
" Shows all files in the order returned by glob()
let g:dirvish_mode = 2
function! s:on_dirvish() abort
    nnoremap <buffer><silent>l :<C-u>.call dirvish#open('edit', 0)<CR>
    nmap <buffer><silent>h <Plug>(dirvish_up)
    nnoremap <buffer><silent>O :<C-u>execute 'OpenBrowser' getline('.')<CR>
    nnoremap <buffer>~ :<C-u>Dirvish ~<CR>
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

" vim-asterisk {{{
map *   <Plug>(asterisk-*)
map #   <Plug>(asterisk-#)
map g*  <Plug>(asterisk-g*)
map g#  <Plug>(asterisk-g#)
map z*  <Plug>(asterisk-z*)
map gz* <Plug>(asterisk-gz*)
map z#  <Plug>(asterisk-z#)
map gz# <Plug>(asterisk-gz#)
" }}}

" vim-notes-cli {{{
nnoremap <Leader>mn :<C-u>NotesNew<CR>
nnoremap <Leader>ml :<C-u>NotesList<CR>
nnoremap <Leader>ms :<C-u>NotesSelect<CR>
" }}}

" プラットフォーム依存な設定をロードする "{{{
function! SourceIfExist(path) abort
    if filereadable(a:path)
        execute 'source' a:path
    endif
endfunction

if s:on_mac
    " 不可視文字
    set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%

    " option キーを Alt として使う．
    if exists('+macmeta')
        set macmeta
    endif

    " :quit 時にアプリケーションも終了する
    if has('gui_running')
        Autocmd VimLeave * macaction terminate:
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

    " macOS では python コマンドは Python2 なので Homebrew で入る python3 を使う
    let g:quickrun_config['python'] = { 'command' : 'python3' }
elseif has('unix') || s:on_win
    " 不可視文字
    set listchars=tab:>-,trail:-,eol:$,extends:>,precedes:<,nbsp:%
    " 256色使う
    set t_Co=256
endif

call SourceIfExist($HOME . '/.local.vimrc')
"}}}

" vim: set ft=vim fdm=marker ff=unix fileencoding=utf-8:
