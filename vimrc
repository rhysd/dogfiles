scriptencoding utf-8
" 必須な基本設定 {{{
" tiny と small では vimrc を読み込まない
if !1 | finish | endif

" This is vim, not vi.
set nocompatible

function! s:get_SID()
    return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeget_SID$')
endfunction
let s:SID = s:get_SID()
delfunction s:get_SID

" Vimrc augroup
augroup MyVimrc
    autocmd!
augroup END
command! -nargs=* Autocmd autocmd MyVimrc <args>
command! -nargs=* AutocmdFT autocmd MyVimrc FileType <args>
" XXX
AutocmdFT vim highlight def link myVimAutocmd vimAutoCmd
AutocmdFT vim match myVimAutocmd /\<\(Autocmd\|AutocmdFT\)\>/

"エンコーディング
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,cp932,euc-jp
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
"高速ターミナル接続を行う
set ttyfast
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
" Ruby シンタックスチェック
    " function! s:ExecuteMake()
    "   if &filetype == 'ruby' && expand('%:t') !~? '^pry\d\{8}.\+\.rb'
    "     silent make! -c "%" | redraw!
    "   endif
    " endfunction
    " compiler ruby
    " augroup rbsyntaxcheck
    "   autocmd BufWritePost <buffer> call s:ExecuteMake()
    " augroup END
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

" 一定時間カーソルを移動しないとカーソルラインを表示（ただし，ウィンドウ移動時
" はなぜか切り替わらない
" http://d.hatena.ne.jp/thinca/20090530/1243615055
Autocmd CursorMoved,CursorMovedI,WinLeave * setlocal nocursorline
Autocmd CursorHold,CursorHoldI,WinEnter * setlocal cursorline

" *.md で読み込む filetype を変更（デフォルトは modula2）
Autocmd BufRead,BufNew,BufNewFile *.md,*.markdown,*.mkd setlocal ft=markdown
" tmux
Autocmd BufRead,BufNew,BufNewFile *tmux.conf setlocal ft=tmux
" git config file
Autocmd BufRead,BufNew,BufNewFile gitconfig setlocal ft=gitconfig
" Gnuplot のファイルタイプを設定
Autocmd BufRead,BufNew,BufNewFile *.plt,*.plot,*.gnuplot setlocal ft=gnuplot
" Ruby の guard 用ファイル
Autocmd BufRead,BufNew,BufNewFile Guardfile setlocal ft=ruby
" JSON
Autocmd BufRead,BufNew,BufNewFile *.json,*.jsonp setlocal ft=json
" jade
Autocmd BufRead,BufNew,BufNewFile *.jade setlocal ft=jade
" Go
Autocmd BufRead,BufNew,BufNewFile *.go setlocal ft=go
" vimspec
Autocmd BufRead,BufNew,BufNewFile *.vimspec setlocal ft=vim.vimspec

" 行数が少ない時だけ行数表示
Autocmd BufEnter * if line('$') > 10000 | setlocal nonumber | else | setlocal number | endif

" カーソル位置の復元
Autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
" Hack #202: 自動的にディレクトリを作成する
" http://vim-users.jp/2011/02/hack202/
Autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
function! s:auto_mkdir(dir, force)
    if !isdirectory(a:dir) && (a:force ||
                \    input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
        " call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
        call mkdir(a:dir, 'p')
    endif
endfunction
" ファイルタイプを書き込み時に自動判別
Autocmd BufWritePost
    \ * if &l:filetype ==# '' || exists('b:ftdetect')
    \ |   unlet! b:ftdetect
    \ |   filetype detect
    \ | endif
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

    function! s:add_permission_x()
        let file = expand('%:p')
        if getline(1) =~# '^#!' && !executable(file)
            silent! call vimproc#system('chmod a+x ' . shellescape(file))
        endif
    endfunction
endif

augroup InitialMessage
    autocmd!
    " 起動時メッセージ．ｲﾇｩ…
    autocmd VimEnter * echo "(U＾ω＾) enjoy vimming!"
augroup END

" ウィンドウ周りのユーティリティ "{{{
function! s:close_window(winnr)
    if winbufnr(a:winnr) !=# -1
        execute a:winnr . 'wincmd w'
        execute 'wincmd c'
        return 1
    else
        return 0
    endif
endfunction

function! s:get_winnr_like(expr)
    let ret = []
    let winnr = 1
    while winnr <= winnr('$')
        let bufnr = winbufnr(winnr)
        if eval(a:expr)
            call add(ret, winnr)
        endif
        let winnr = winnr + 1
    endwhile
    return ret
endfunction

function! s:close_windows_like(expr, ...)
    let winnr_list = s:get_winnr_like(a:expr)
    " Close current window if current matches a:expr.
    " let winnr_list = s:move_current_winnr_to_head(winnr_list)
    if empty(winnr_list)
        return
    endif

    let first_only = exists('a:1')
    let prev_winnr = winnr()
    try
        for winnr in reverse(sort(winnr_list))
            call s:close_window(winnr)
            if first_only
                return 1
            endif
        endfor
        return 0
    finally
        " Back to previous window.
        let cur_winnr = winnr()
        if cur_winnr !=# prev_winnr && winbufnr(prev_winnr) !=# -1
            execute prev_winnr . 'wincmd w'
        endif
    endtry
endfunction
"}}}

" あるウィンドウを他のウィンドウから閉じる "{{{
function! s:is_target_window(winnr)
    let target_filetype = ['ref', 'unite', 'vimfiler', 'vimshell']
    let target_buftype  = ['help', 'quickfix']
    let winbufnr = winbufnr(a:winnr)
    return index(target_filetype, getbufvar(winbufnr, '&filetype')) >= 0 ||
                \ index(target_buftype, getbufvar(winbufnr, '&buftype')) >= 0
endfunction

nnoremap <silent><C-q>
            \ :<C-u>call <SID>close_windows_like('s:is_target_window(winnr)')<CR>
inoremap <silent><C-q>
            \ <Esc>:call <SID>close_windows_like('s:is_target_window(winnr)')<CR>
nnoremap <silent><Leader>cp
            \ :<C-u>call <SID>close_windows_like('s:is_target_window(winnr)', 'first_only')<CR>
"}}}

command! Date :call setline('.', getline('.') . strftime('%Y/%m/%d (%a) %H:%M'))

" vimrc を開く
command! Vimrc call s:edit_myvimrc()
function! s:edit_myvimrc()
    let ghq_root = expand(substitute(system('git config ghq.root'), '\n$', '', ''))
    if isdirectory(ghq_root . '/github.com/rhysd/dotfiles')
        let vimrc = ghq_root . '/github.com/rhysd/dotfiles/vimrc*'
        let gvimrc = ghq_root . '/github.com/rhysd/dotfiles/gvimrc*'
    elseif isdirectory($HOME.'Github/dotfiles')
        let vimrc = expand('~/Github/dotfiles/vimrc*')
        let gvimrc = expand('~/Github/dotfiles/gvimrc*')
    else
        let vimrc = $MYVIMRC
        let gvimrc = $MYGVIMRC
    endif

    let files = ""
    if !empty($MYVIMRC)
        let files .= substitute(expand(vimrc), '\n', ' ', 'g')
    endif
    if !empty($MYGVIMRC)
        let files .= substitute(expand(gvimrc), '\n', ' ', 'g')
    endif

    execute "args " . files
endfunction

" カレントパスをクリプボゥにコピー
command! CopyCurrentPath :call s:copy_current_path()
function! s:copy_current_path()
    if has('win32') || has('win64')
        let c = substitute(expand('%:p'), '\\/', '\\', 'g')
    elseif has('unix')
        let c = expand('%:p')
    endif

    if &clipboard ==# 'plus$'
        let @+ = c
    else
        let @* = c
    endif
endfunction

" エンコーディング指定オープン
command! -bang -complete=file -nargs=? Utf8 edit<bang> ++enc=utf-8 <args>
command! -bang -complete=file -nargs=? Sjis edit<bang> ++enc=cp932 <args>
command! -bang -complete=file -nargs=? Euc edit<bang> ++enc=eucjp <args>

" 横幅と縦幅を見て縦分割か横分割か決める
command! -nargs=? -complete=command SmartSplit call <SID>smart_split(<q-args>)
nnoremap <C-w><Space> :<C-u>SmartSplit<CR>
function! s:smart_split(cmd)
    if winwidth(0) > winheight(0) * 2
        vsplit
        if exists(':AdjustWindowWidth')
            AdjustWindowWidth
        endif
    else
        split
    endif

    if !empty(a:cmd)
        execute a:cmd
    endif
endfunction

" 縦幅と横幅を見て help の開き方を決める
command! -nargs=* -complete=help SmartHelp call <SID>smart_help(<q-args>)
nnoremap <silent><Leader>h :<C-u>SmartHelp<Space><C-l>
function! s:smart_help(args)
    try
        if winwidth(0) > winheight(0) * 2
            " 縦分割
            execute 'vertical topleft help ' . a:args
        else
            execute 'aboveleft help ' . a:args
        endif
    catch /^Vim\%((\a\+)\)\=:E149/
        echohl ErrorMsg
        echomsg "E149: Sorry, no help for " . a:args
        echohl None
    endtry
    if &buftype ==# 'help'
        " 横幅を確保できないときはタブで開く
        if winwidth(0) < 80
            execute 'quit'
            execute 'tab help ' . a:args
        endif
        silent! AdjustWindowWidth --direction=shrink
    endif
endfunction

" インデント
command! -bang -nargs=1 SetIndent
            \ execute <bang>0 ? 'set' : 'setlocal'
            \         'tabstop='.<q-args>
            \         'shiftwidth='.<q-args>
            \         'softtabstop='.<q-args>

" カレンダーを開く
command! -nargs=0 CalendarApp call <SID>open_calendar_app()
function! s:open_calendar_app()
    if has('mac')
        call system('open -a Calendar.app')
    else
        OpenBrowser https://www.google.com/calendar/render
    endif
endfunction

" 基本マッピング {{{
" ; と : をスワップ
noremap : ;
if has('cmdline_hist')
    " コマンドラインウィンドウを使う
    " Note:
    "   noremap ; q:i は使えない
    "   マクロ記録中に q を記録終了に食われてしまう
    "   eval() にそのまま通すのは怖いので事前に &cedit をチェック
    noremap <silent><expr>; &cedit =~# '^<C-\a>$' ? ':'.eval('"\'.&cedit.'"').'i' : ':'
    noremap <Leader>; :
else
    noremap ; :
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
" 選択領域の頭に入力する（vim-niceblock を使うために vmap）
vmap m I
" gm にマーク機能を退避
noremap gm m
"Esc->Escで検索結果とエラーハイライトをクリア
nnoremap <silent><Esc><Esc> :<C-u>nohlsearch<CR>
"{数値}<Tab>でその行へ移動．それ以外だと通常の<Tab>の動きに
noremap <expr><Tab> v:count !=0 ? "G" : "\<Tab>zvzz"
" コマンドラインウィンドウ
" 検索後画面の中心に。
nnoremap n nzvzz
nnoremap N Nzvzz
nnoremap * *zvzz
nnoremap # *zvzz
" 検索で / をエスケープしなくて良くする（素の / を入力したくなったら<C-v>/）
cnoremap <expr>/ <SID>escaped_char_on_cmdline('/')
cnoremap <expr>< <SID>escaped_char_on_cmdline('<')
cnoremap <expr>> <SID>escaped_char_on_cmdline('>')
function! s:escaped_char_on_cmdline(c)
    if getcmdtype() !~# '[?/]'
        return a:c
    endif

    let p = getcmdpos()
    if p < 2
        return '\' . a:c
    endif

    if getcmdline()[p-2] ==# '\'
        return a:c
    endif

    return '\' . a:c
endfunction
" 空行挿入
function! s:cmd_cr_n(count)
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
nmap     s <C-w>
" 現在のウィンドウのみを残す
nnoremap <C-w>O <C-w>o
" バッファを削除
function! s:delete_current_buf()
    let bufnr = bufnr('%')
    bnext
    if bufnr == bufnr('%') | enew | endif
    silent! bdelete #
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
" 貼り付けは P のほうが好みかも
    " nnoremap p P
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
" カーソル付近の文字列で検索（新規ウィンドウ）
nnoremap <C-w>* <C-w>s*
nnoremap <C-w># <C-w>s#
nnoremap <silent><C-w>h :<C-u>call <SID>jump_window_wrapper('h', 'l')<CR>
nnoremap <silent><C-w>j :<C-u>call <SID>jump_window_wrapper('j', 'k')<CR>
nnoremap <silent><C-w>k :<C-u>call <SID>jump_window_wrapper('k', 'j')<CR>
nnoremap <silent><C-w>l :<C-u>call <SID>jump_window_wrapper('l', 'h')<CR>

function! s:jump_window_wrapper(cmd, fallback)
    let old = winnr()
    execute 'normal!' "\<C-w>" . a:cmd

    if old == winnr()
        execute 'normal!' "999\<C-w>" . a:fallback
    endif
endfunction

" 連結時にスペースを入れない
function! s:cmd_gJ()
    normal! J
    if getline('.')[col('.')-1] ==# ' '
        normal! "_x
    endif
endfunction
nnoremap gJ :<C-u>call <SID>cmd_gJ()<CR>
" コマンドラインウィンドウ設定
function! s:cmdline_window_settings()
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
function! s:on_FileType_help_define_mappings()
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
        " カーソル下の単語を help で調べる
        " AutocmdFT help nnoremap <buffer>K :<C-u>help <C-r><C-w><CR>
        " TODO v で選択した範囲を help
    endif
endfunction
AutocmdFT help call s:on_FileType_help_define_mappings()

" quickfix のマッピング
function! s:on_FileType_qf_define_mappings()
    nnoremap <buffer><silent> q :<C-u>cclose<CR>
    nnoremap <buffer><silent> j :<C-u>cnext!<CR>
    nnoremap <buffer><silent> k :<C-u>cprevious!<CR>
    nnoremap <buffer><silent> J :<C-u>cfirst<CR>
    nnoremap <buffer><silent> K :<C-u>clast<CR>
    nnoremap <buffer><silent> n :<C-u>cnewer<CR>
    nnoremap <buffer><silent> p :<C-u>colder<CR>
    nnoremap <buffer><silent> l :<C-u>clist<CR>
endfunction
AutocmdFT qf call s:on_FileType_qf_define_mappings()

" git-rebase
function! s:on_FileType_gitrebase_define_mappings()
    nnoremap <buffer><C-p> :<C-u>Pick<CR>
    nnoremap <buffer><C-s> :<C-u>Squash<CR>
    nnoremap <buffer><C-e> :<C-u>Edit<CR>
    nnoremap <buffer><C-r> :<C-u>Reword<CR>
    nnoremap <buffer><C-f> :<C-u>Fixup<CR>
endfunction
AutocmdFT gitrebase call s:on_FileType_gitrebase_define_mappings()

function! s:move_backward_by_step()
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

function! s:move_forward_by_step()
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

" 行頭 → 非空白行頭 → 行 をローテートする
function! s:rotate_in_line()
    let c = virtcol('.')

    let cmd = c == 1 ? 'g^' : 'g$'
    execute "normal! ".cmd

    " 行頭にスペースがなかったときは行頭と行末をトグル
    if c == virtcol('.')
        if cmd == 'g^'
            normal! g$
        else
            normal! g0
        endif
    endif
endfunction

" }}}

"}}}

" 最小限の設定と最小限のプラグインだけ読み込む {{{
" % vim --cmd "g:linda_pp_startup_with_tiny = 1" で起動した時
" または vi という名前の シンボリックリンク越しに vim を起動した時
if get(g:, 'linda_pp_startup_with_tiny', 0)
            \ || v:progname ==# 'vi'
            \ || ! exists('v:version') || v:version < 702
            \ || ! executable('git')
    finish
endif
"}}}

" neobundle.vim の設定 {{{
" neobundle.vim が無ければインストールする
if ! isdirectory(expand('~/.vim/bundle'))
    echon "Installing neobundle.vim..."
    silent call mkdir(expand('~/.vim/bundle'), 'p')
    silent !git clone https://github.com/Shougo/neobundle.vim $HOME/.vim/bundle/neobundle.vim
    echo "done."
    if v:shell_error
        echoerr "neobundle.vim installation has failed!"
        finish
    endif
endif

if has('vim_starting')
    set rtp+=~/.vim/bundle/neobundle.vim/
endif

let s:meet_neocomplete_requirements = has('lua') && (v:version > 703 || (v:version == 703 && has('patch885')))
let s:enable_tern_for_vim = has('python') && executable('npm')

call neobundle#begin(expand('~/.vim/bundle'))

function! s:cache_bundles()

    " GitHub上のリポジトリ
    NeoBundleFetch 'Shougo/neobundle.vim'
    NeoBundle 'Shougo/vimproc.vim', {
                \ 'build' : {
                \       'windows' : 'echo "Please build vimproc manually."',
                \       'cygwin'  : 'make -f make_cygwin.mak',
                \       'mac'     : 'make -f make_mac.mak',
                \       'unix'    : 'make -f make_unix.mak',
                \   }
                \ }
    NeoBundle 'Shougo/neosnippet'
    NeoBundle 'Shougo/neosnippet-snippets'
    NeoBundle 'rhysd/inu-snippets'
    NeoBundle 'thinca/vim-quickrun'
    NeoBundle 'Shougo/unite-outline'
    NeoBundle 'osyo-manga/unite-quickfix'
    NeoBundle 'rhysd/quickrun-unite-quickfix-outputter'
    NeoBundle 'Shougo/unite-help'
    NeoBundle 'thinca/vim-unite-history'
    NeoBundle 'vim-jp/vimdoc-ja'
    NeoBundle 'jceb/vim-hier'
    NeoBundle 'kana/vim-textobj-user'
    NeoBundle 'thinca/vim-prettyprint'
    NeoBundle 'kana/vim-operator-user'
    NeoBundle 'kana/vim-vspec'
    NeoBundle 'rhysd/accelerated-jk'
    NeoBundle 'kana/vim-smartinput'
    NeoBundle 'kana/vim-niceblock'
    NeoBundle 'thinca/vim-scouter'
    NeoBundle 'h1mesuke/vim-alignta'
    NeoBundle 'rhysd/clever-f.vim', 'dev'
    NeoBundle 'rhysd/unite-zsh-cdr.vim'
    NeoBundle 'rhysd/unite-ruby-require.vim'
    NeoBundle 'mhinz/vim-signify'
    NeoBundle 'kana/vim-submode'
    NeoBundle 'bling/vim-airline'
    NeoBundle 'rhysd/vim-numberstar'
    NeoBundle 'rhysd/migemo-search.vim'
    NeoBundle 'rhysd/vim-vspec-matchers'
    NeoBundle 'ujihisa/unite-colorscheme'
    NeoBundle 'rhysd/unite-locate'
    NeoBundle 'rhysd/conflict-marker.vim'
    NeoBundle 'rhysd/vim-window-adjuster'
    NeoBundle 'Shougo/neomru.vim'
    NeoBundle 'rhysd/committia.vim'
    NeoBundle 'rhysd/vim-dachs'
    NeoBundle 'rhysd/BoostTest-log.vim'

    " カラースキーム
    NeoBundle 'rhysd/wallaby.vim'
    NeoBundle 'chriskempson/tomorrow-theme', {'rtp' : 'vim'}
    NeoBundle 'junegunn/seoul256.vim'
    NeoBundle 'tomasr/molokai'
    NeoBundle 'telamon/vim-color-github'
    NeoBundle 'chriskempson/base16-vim'

    NeoBundle 'altercation/vim-colors-solarized', {'gui' : 1}
    NeoBundle 'rdark', {'gui' : 1}
    NeoBundle 'jonathanfilip/vim-lucius', {'gui' : 1}
    NeoBundle 'vyshane/vydark-vim-color', {'gui' : 1}
    NeoBundle '29decibel/codeschool-vim-theme', {'gui' : 1}

    " For testing
    command! -nargs=1 NeoBundleMyPlugin
                \ NeoBundle <args>, {
                \   'base' : '~/Dev/github.com/rhysd',
                \   'type' : 'nosync',
                \ }

    NeoBundleMyPlugin 'libclang-vim'

    " vim-scripts上のリポジトリ
        " NeoBundle 'Align'

    " その他のgitリポジトリ
        " NeoBundle 'git://git.wincent.com/command-t.git'

    " 読み込みを遅延する
    NeoBundleLazy 'Shougo/unite.vim', {
                \   'autoload' : {
                \     'commands' : [{'name': 'Unite', 'complete' : 'customlist,unite#complete_source'},
                \                   {'name': 'UniteWithBufferDir', 'complete' : 'customlist,unite#complete_source'},
                \                   {'name': 'UniteWithCursorWord', 'complete' : 'customlist,unite#complete_source'},
                \                   {'name': 'UniteWithWithInput', 'complete' : 'customlist,unite#complete_source'}]
                \   }
                \ }

    NeoBundleLazy 'Shougo/vimfiler.vim', {
                \ 'depends' : 'Shougo/unite.vim',
                \ 'autoload' : {
                \     'commands' : ['VimFiler', 'VimFilerCurrentDir',
                \                   'VimFilerBufferDir', 'VimFilerSplit',
                \                   'VimFilerExplorer', 'VimFilerDouble']
                \     }
                \ }

    NeoBundleLazy 'kana/vim-operator-replace', {
                \ 'autoload' : {
                \     'mappings' : '<Plug>(operator-replace)'
                \     }
                \ }

    NeoBundleLazy 'rhysd/vim-operator-trailingspace-killer', {
                \ 'autoload' : {
                \     'mappings' : '<Plug>(operator-trailingspace-killer)'
                \     }
                \ }

    NeoBundleLazy 'rhysd/vim-operator-filled-with-blank', {
                \ 'autoload' : {
                \     'mappings' : '<Plug>(operator-filled-with-blank)'
                \     }
                \ }

    NeoBundleLazy 'rhysd/vim-operator-evalruby', {
                \ 'autoload' : {
                \     'mappings' : '<Plug>(operator-evalruby)'
                \     }
                \ }

    NeoBundleLazy 'rhysd/vim-operator-surround', {
                \ 'depends' : 'tpope/vim-repeat',
                \ 'autoload' : {
                \       'mappings' : '<Plug>(operator-surround-'
                \   }
                \ }

    NeoBundleLazy 'deris/vim-operator-insert', {
                \ 'autoload' : {
                \   'mappings' : [
                \       '<Plug>(operator-insert-i)',
                \       '<Plug>(operator-insert-a)',
                \   ],
                \   },
                \ }

    NeoBundleLazy 'tyru/caw.vim', {
                \ 'autoload' : {
                \     'mappings' :
                \         ['<Plug>(caw', '<Plug>(operator-caw)']
                \     }
                \ }

    NeoBundleLazy 'vim-scripts/ZoomWin', {
                \ 'autoload' : {
                \     'commands' : 'ZoomWin'
                \     }
                \ }

    NeoBundleLazy 'Shougo/vimshell', {
                \ 'autoload' : {
                \     'commands' : ['VimShell', 'VimShellSendString', 'VimShellCurrentDir', 'VimShellInteractive'],
                \     }
                \ }

    NeoBundleLazy 'kana/vim-altr'

    NeoBundleLazy 'vim-jp/vital.vim', {
                \ 'autoload' : {
                \       'commands' : 'Vitalize',
                \   }
                \ }

    NeoBundleLazy 'tyru/open-browser.vim', {
                \ 'autoload' : {
                \     'commands' : ['OpenBrowser', 'OpenBrowserSearch', 'OpenBrowserSmartSearch'],
                \     'mappings' : '<Plug>(openbrowser-',
                \   }
                \ }

    NeoBundleLazy 'tyru/open-browser-github.vim', {
                \ 'depends' : 'tyru/open-browser.vim',
                \ 'autoload' : {
                \       'commands' : ['OpenGithubFile', 'OpenGithubIssue', 'OpenGithubPullReq']
                \   }
                \ }

    NeoBundleLazy 'rhysd/tmpwin.vim'

    NeoBundleLazy 'kannokanno/previm', {
                \ 'depends' : 'tyru/open-browser.vim',
                \ 'autoload' : {
                \     'commands' : 'PrevimOpen',
                \     'filetypes' : 'markdown'
                \   }
                \ }

    NeoBundleLazy 'glidenote/memolist.vim', {
                \ 'depends' : 'Shougo/vimfiler.vim',
                \ 'autoload' : {
                \     'commands' : ['MemoNew', 'MemoList', 'MemoGrep']
                \   }
                \ }

    NeoBundle 'Lokaltog/vim-easymotion', {
                \ 'autoload' : {
                \       'mappings' : '<Plug>(easymotion-',
                \   }
                \ }

    NeoBundleLazy 'kana/vim-textobj-indent', {
                \ 'depends' : 'kana/vim-textobj-user',
                \ 'autoload' : {
                \       'mappings' : [['xo', 'ai'], ['xo', 'aI'], ['xo', 'ii'], ['xo', 'iI']]
                \   }
                \ }

    NeoBundleLazy 'kana/vim-textobj-line', {
                \ 'depends' : 'kana/vim-textobj-user',
                \ 'autoload' : {
                \       'mappings' : [['xo', 'al'], ['xo', 'il']]
                \   }
                \ }

    NeoBundleLazy 'rhysd/vim-textobj-wiw', {
                \ 'depends' : 'kana/vim-textobj-user',
                \ 'autoload' : {
                \       'mappings' : [['xo', 'am'], ['xo', 'im']]
                \   }
                \ }


    NeoBundleLazy 'sgur/vim-textobj-parameter', {
                \ 'depends' : 'kana/vim-textobj-user',
                \ 'autoload' : {
                \       'mappings' : [['xo', 'a,'], ['xo', 'i,']]
                \   }
                \ }

    NeoBundleLazy 'thinca/vim-textobj-between', {
                \ 'depends' : 'kana/vim-textobj-user',
                \ 'autoload' : {
                \       'mappings' : [['xo', 'af'], ['xo', 'if'], ['xo', '<Plug>(textobj-between-']]
                \   }
                \ }

    NeoBundleLazy 'thinca/vim-textobj-comment', {
                \ 'depends' : 'kana/vim-textobj-user',
                \ 'autoload' : {
                \       'mappings' : [['xo', 'ac'], ['xo', 'ic']]
                \   }
                \ }

    NeoBundleLazy 'rhysd/vim-textobj-word-column', {
                \ 'depends' : 'kana/vim-textobj-user',
                \ 'autoload' : {
                \       'mappings' : [['xo', 'av'], ['xo', 'aV'], ['xo', 'iv'], ['xo', 'iV']]
                \   }
                \ }

    NeoBundleLazy 'kana/vim-textobj-entire', {
                \ 'depends' : 'kana/vim-textobj-user',
                \ 'autoload' : {
                \       'mappings' : [['xo', 'ae'], ['xo', 'ie']]
                \   }
                \ }

    NeoBundleLazy 'kana/vim-textobj-fold', {
                \ 'depends' : 'kana/vim-textobj-user',
                \ 'autoload' : {
                \       'mappings' : [['xo', 'az'], ['xo', 'iz']]
                \ }
                \ }

    NeoBundleLazy 'rhysd/vim-textobj-anyblock', {
                \ 'depends' : 'kana/vim-textobj-user',
                \ 'autoload' : {
                \       'mappings' : [['xo', 'ab'], ['xo', 'ib']]
                \   }
                \ }

    NeoBundleLazy 'rhysd/vim-textobj-clang', {
                \ 'depends' : 'kana/vim-textobj-user',
                \ 'autoload' : {
                \       'mappings' : [['xo', 'a;'], ['xo', 'i;']]
                \   }
                \ }

    NeoBundleLazy 'tpope/vim-fugitive', {
                \ 'autoload' : {
                \       'commands' : ['Gstatus', 'Gcommit', 'Gwrite', 'Gdiff', 'Gblame', 'Git', 'Ggrep']
                \   }
                \ }

    NeoBundleLazy 'rbtnn/puyo.vim', {
            \ 'autoload' : {
            \       'commands' : 'Puyo'
            \   }
            \ }

    NeoBundleLazy 'thinca/vim-threes', {
            \ 'autoload' : {
            \       'commands' : 'ThreesStart'
            \   }
            \ }

    NeoBundleLazy 'itchyny/calendar.vim', {
                \ 'autoload' : {
                \       'commands' : {'name' : 'Calendar', 'complete' : 'customlist,calendar#argument#complete'},
                \   }
                \ }

    NeoBundleLazy 'koron/codic-vim', {
                \ 'autoload' : {
                \       'commands' : 'Codic',
                \   }
                \ }

    NeoBundleLazy 'rhysd/unite-codic.vim', {
                \ 'depends' : [
                \       'Shougo/unite.vim',
                \       'koron/codic-vim',
                \   ],
                \ 'autoload' : {
                \       'unite_sources' : 'codic',
                \   },
                \ }

    NeoBundleLazy 'rhysd/wandbox-vim', {
                \ 'autoload' : {
                \       'commands' : [{'name' : 'Wandbox', 'complete' : 'customlist,wandbox#complete_command'}, 'WandboxOptionList']
                \   }
                \ }

    NeoBundleLazy 'rhysd/open-pdf.vim', {
                \ 'autoload' : {
                \     'commands' : ['Pdf', 'PdfRead', 'PdfEdit', 'PdfCacheClean', 'PdfCacheReload'],
                \      'unite_sources' : ['pdf/history', 'pdf/search'],
                \   }
                \ }

    NeoBundleLazy 'thinca/vim-visualstar', {
                \ 'autoload' : {
                \     'mappings' : [['x', '*'], ['x' , '#'], ['x', 'g*'], ['x', 'g#']],
                \   }
                \ }


    NeoBundleLazy 'daisuzu/rainbowcyclone.vim', {
                \   'autoload' : {
                \     'mappings' : '<Plug>(rc_search_'
                \   },
                \ }

    NeoBundleLazy 'cohama/agit.vim', {
                \   'autoload' : {
                \     'commands' : 'Agit'
                \   }
                \ }

    NeoBundleLazy 'mattn/gist-vim', {
                \ 'depends' : 'mattn/webapi-vim',
                \ 'autoload' : {
                \     'commands' : 'Gist',
                \   }
                \ }

    " if_lua プラグイン
    if s:meet_neocomplete_requirements
        NeoBundle 'Shougo/neocomplete.vim'
    else
        NeoBundle 'Shougo/neocomplcache.vim'
    endif

    " GUI オンリーなプラグイン
    NeoBundleLazy 'nathanaelkane/vim-indent-guides', {
                \   'autoload' : {
                \     'filetypes' : ['haskell', 'python']
                \   }
                \ }
    NeoBundleLazy 'tyru/restart.vim', {
                \   'gui' : 1,
                \   'autoload' : {
                \     'commands' : 'Restart'
                \   }
                \ }

    " 特定のファイルタイプで読み込む
    NeoBundleLazy 'rhysd/endwize.vim', {
                \ 'autoload' : {
                \     'filetypes' : ['ruby', 'vim', 'sh', 'zsh', 'c', 'cpp', 'lua', 'dachs']
                \     }
                \ }

    " C++用のプラグイン
    NeoBundleLazy 'vim-jp/cpp-vim', {
                \ 'autoload' : {'filetypes' : 'cpp'}
                \ }
    NeoBundleLazy 'rhysd/unite-n3337', {
                \ 'autoload' : {'unite_sources' : 'n3337'}
                \ }
    NeoBundleLazy 'Rip-Rip/clang_complete', {
                \ 'autoload' : {'filetypes' : ['c', 'cpp']}
                \ }
    NeoBundleLazy 'rhysd/vim-clang-format', {
                \ 'depends' : 'kana/vim-operator-user',
                \ 'autoload' : {'filetypes' : ['c', 'cpp', 'objc']}
                \ }
    NeoBundleLazy 'rhysd/clang-extent-selector.vim', {
                \ 'autoload' : {
                \       'filetypes' : ['c', 'cpp']
                \   }
                \ }
    NeoBundleLazy 'rhysd/clang-type-inspector.vim', {
                \ 'autoload' : {
                \       'filetypes' : ['c', 'cpp']
                \   }
                \ }

    NeoBundleLazy 'sorah/unite-ghq', {
            \ 'autoload' : {
            \       'unite_sources' : 'ghq'
            \   }
            \ }

    " Haskell 用プラグイン
    NeoBundleLazy 'ujihisa/unite-haskellimport', {
                \ 'autoload' : {'filetypes' : 'haskell'}
                \ }
    NeoBundleLazy 'rhysd/vim2hs', {
                \ 'autoload' : {'filetypes' : 'haskell'}
                \ }
    NeoBundleLazy 'rhysd/vim-filetype-haskell', {
                \ 'autoload' : {'filetypes' : 'haskell'}
                \ }
    NeoBundleLazy 'eagletmt/unite-haddock', {
                \ 'autoload' : {'filetypes' : 'haskell'}
                \ }
    NeoBundleLazy 'ujihisa/neco-ghc', {
                \ 'autoload' : {'filetypes' : 'haskell'}
                \ }
    NeoBundleLazy 'eagletmt/ghcmod-vim', {
                \ 'autoload' : {'filetypes' : 'haskell'}
                \ }

    " Ruby 用プラグイン
    NeoBundleLazy 'basyura/unite-rails', {
                \ 'autoload' : {'filetypes' : 'ruby'}
                \ }
    NeoBundleLazy 'rhysd/vim-textobj-ruby', {
                \ 'autoload' : {'filetypes' : 'ruby'}
                \ }
    NeoBundleLazy 'rhysd/neco-ruby-keyword-args', {
                \ 'autoload' : {'filetypes' : 'ruby'}
                \ }
    " NeoBundleLazy 'rhysd/unite-ruby-require.vim', {
    "             \ 'autoload' : {'filetypes' : 'ruby'}
    "             \ }

    " JavaScript 用プラグイン
    NeoBundleLazy 'jiangmiao/simple-javascript-indenter', {
                \ 'autoload' : {'filetypes' : 'javascript'}
                \ }
    NeoBundleLazy 'jelera/vim-javascript-syntax', {
                \ 'autoload' : {'filetypes' : 'javascript'}
                \ }
    if s:enable_tern_for_vim
        NeoBundleLazy 'marijnh/tern_for_vim', {
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
                    \ }
    else
        NeoBundleLazy 'mattn/jscomplete-vim', {
                    \ 'autoload' : {'filetypes' : 'javascript'}
                    \ }
    endif

    " html, sass, scss 用プラグイン
    NeoBundleLazy 'mattn/emmet-vim', {
        \ 'autoload': {
        \     'function_prefix': 'emmet',
        \     'filetypes': ['html', 'haml', 'xhtml', 'liquid', 'css', 'scss', 'sass'],
        \     'mappings' : ['i', '<Plug>(EmmetExpandAbbr)']
        \   }
        \ }
    NeoBundleLazy 'othree/html5.vim', {
                \ 'autoload' : {
                \     'filetypes' : ['html', 'xhtml'],
                \     'commands' : ['HtmlIndentGet']
                \   }
                \ }
    NeoBundleLazy 'tpope/vim-haml', {
                \ 'autoload' : {
                \     'filetypes' : ['haml', 'sass', 'scss'],
                \   }
                \ }

    " Python
    NeoBundleLazy 'davidhalter/jedi-vim', {
            \ 'autoload' : {
            \     'filetypes' : 'python',
            \   }
            \ }
    NeoBundleLazy 'hynek/vim-python-pep8-indent', {
            \ 'autoload' : {
            \     'filetypes' : 'python',
            \   }
            \ }
    NeoBundleLazy 'digitaltoad/vim-jade', {
            \ 'autoload' : {
            \     'filetypes' : 'jade',
            \   }
            \ }

    " Tmux
    NeoBundleLazy 'zaiste/tmux.vim', {
            \ 'autoload' : {'filetypes' : 'tmux'}
            \ }

    " JSON
    NeoBundleLazy 'elzr/vim-json', {
            \ 'autoload' : {'filetypes' : ['json', 'markdown']}
            \ }

    " Go
    NeoBundleLazy 'Blackrush/vim-gocode', {
            \ 'autoload' : {
            \       'filetypes' : ['go', 'markdown'],
            \       'commands' : 'Godoc',
            \   }
            \ }

    NeoBundleLazy 'rhysd/unite-go-import.vim', {
            \ 'autoload' : {
            \     'depends' : ['Shougo/unite.vim', 'Blackrush/vim-gocode'],
            \     'unite_sources' : 'go/import',
            \   }
            \ }

    NeoBundleLazy 'dgryski/vim-godef', {
            \ 'autoload' : {
            \     'filetypes' : 'go'
            \   }
            \ }

    NeoBundleLazy 'rhysd/vim-go-impl', {
            \ 'autoload' : {
            \     'filetypes' : 'go'
            \   }
            \ }

    " LLVM IR
    NeoBundle 'rhysd/vim-llvm'

    " TweetVim
    NeoBundleLazy 'basyura/twibill.vim'
    NeoBundleLazy 'yomi322/neco-tweetvim'
    NeoBundleLazy 'rhysd/tweetvim-advanced-filter'
    NeoBundleLazy 'basyura/TweetVim', 'dev', {
                \ 'depends' :
                \     ['basyura/twibill.vim',
                \      'tyru/open-browser.vim',
                \      'yomi322/neco-tweetvim',
                \      'rhysd/tweetvim-advanced-filter'],
                \ 'autoload' : {
                \     'commands' :
                \         ['TweetVimHomeTimeline',
                \          'TweetVimMentions',
                \          'TweetVimSay',
                \          'TweetVimUserTimeline',
                \          'TweetVimUserStream']
                \     }
                \ }

    " 書き込み権限の無いファイルを編集しようとした時
    NeoBundleLazy 'sudo.vim'

    NeoBundleCheck
    NeoBundleSaveCache
endfunction

" ReadOnly のファイルを編集しようとしたときに sudo.vim を遅延読み込み
Autocmd FileChangedRO * NeoBundleSource sudo.vim
Autocmd FileChangedRO * execute "command! W SudoWrite" expand('%')

if neobundle#has_cache()
    NeoBundleLoadCache
else
    call s:cache_bundles()
endif

call neobundle#end()
filetype plugin indent on     " required!

Autocmd BufWritePost *vimrc,*gvimrc NeoBundleClearCache

" カーソル行で NeoBundle されたプラグインをブラウザで表示
function! s:browse_neobundle_home(bundle_name)
    if match(a:bundle_name, '/') == -1
        let url = 'http://www.google.jp/search?q='.a:bundle_name
    else
        let url = 'https://github.com/'.a:bundle_name
    endif
    execute 'OpenBrowser' url
endfunction
command! -nargs=1 BrowseNeoBundleHome call <SID>browse_neobundle_home(<q-args>)

" NeoBundle のキーマップ{{{
" すべて更新するときは基本的に Unite で非同期に実行
nnoremap <silent><Leader>nbu :<C-u>NeoBundleUpdate<CR>
nnoremap <silent><Leader>nbc :<C-u>NeoBundleClean<CR>
nnoremap <silent><Leader>nbi :<C-u>NeoBundleInstall<CR>
nnoremap <silent><Leader>nbl :<C-u>Unite output<CR>NeoBundleList<CR>
nnoremap <silent><Leader>nbd :<C-u>NeoBundleDocs<CR>
nnoremap <silent><Leader>nbh :<C-u>execute 'BrowseNeoBundleHome' matchstr(getline('.'), '\%[Neo]Bundle\%[Lazy]\s\+[''"]\zs.\+\ze[''"]')<CR>
" }}}

" }}}

" Git helpers {{{

" git のルートディレクトリを返す
function! s:git_root_dir()
    if(system('git rev-parse --is-inside-work-tree') ==# "true\n")
        return system('git rev-parse --show-cdup')
    else
        echoerr 'current directory is outside git working tree'
    endif
endfunction

" git add 用マッピング {{{
function! s:git_add(fname)
    if ! filereadable(a:fname)
        echoerr 'file cannot be opened'
        return
    endif
    execute 'lcd' fnamemodify(a:fname, ':h')
    let result = system('git add '.a:fname)
    if v:shell_error
        echoerr 'failed to add: '.result
    else
        echo fnamemodify(a:fname, ':t') . ' is added:'
    endif
endfunction
command! -nargs=0 GitAddThisFile call <SID>git_add(expand('%:p'))
nnoremap <silent><Leader>ga :<C-u>GitAddThisFile<CR>
"}}}

" git blame 用 {{{
function! s:git_blame(fname, ...)
    execute 'lcd' fnamemodify(a:fname, ':p:h')
    let range = (a:0==0 ? line('.') : a:1.','.a:2)
    let errfmt = &errorformat
    set errorformat=.*
    cgetexpr system('git blame -L '.range.' '.fnamemodify(a:fname, ':p'))
    let &errorformat = errfmt
    Unite quickfix -no-start-insert
endfunction
command! -nargs=0 GitBlameThisLine call <SID>git_blame(expand('%'))
command! -range GitBlameRange call <SID>git_blame(expand('%'), <line1>, <line2>)
nnoremap <silent><Leader>gb :<C-u>GitBlameThisLine<CR>
vnoremap <silent><Leader>gb :GitBlameRange<CR>
"}}}

" git push 用
function! s:git_push(args)
    execute "QuickRun sh -cmd sh -src 'git push ".a:args."' -runner vimproc"
endfunction
command! -nargs=* GitPush call <SID>git_push(<q-args>)
nnoremap <Leader>gp :<C-u>GitPush<CR>

" git commit ではインサートモードに入る
Autocmd VimEnter COMMIT_EDITMSG if getline(1) == '' | execute 1 | startinsert | endif

function! s:hubrowse(...)
    if !executable('hub')
        echoerr "'hub' command is not found"
        return
    endif

    let dir = expand('%:p:h')
    if a:0 > 1
        let repo = shellescape(a:1)
    else
        let repo = '--'
    endif

    let subcmd = a:000[-1]

    echom system(printf('cd %s && hub browse %s %s', shellescape(dir), repo, shellescape(subcmd)))
endfunction

command! -nargs=+ Hubrowse call <SID>hubrowse(<f-args>)
command! -nargs=* GitIssue call call("<SID>hubrowse", split("<args> issues"))
"}}}

" 他の helper {{{
" 本体に同梱されている matchit.vim のロードと matchpair の追加
function! s:matchit(...)
    if !exists('s:matchit_loaded')
        runtime macros/matchit.vim
        let s:matchit_loaded = 1
    endif
    let default_pairs = [&matchpairs]
    let b:match_words = get(b:, 'match_words', '') . ',' . join(default_pairs, ',') . ',' . join(a:000, ',')
endfunction

" エラー表示
function! EchoError(...)
    echohl Error
    execute 'echomsg' join(map(copy(a:000), 'string(v:val)'), ' ')
    echohl None
endfunction
command! -nargs=+ EchoError call EchoError(<f-args>)
"}}}

" 追加のハイライト {{{
let s:zenkaku_no_highlight_filetypes = []
" 全角スペース
Autocmd ColorScheme * highlight link ZenkakuSpace Error
Autocmd VimEnter,WinEnter * if index(s:zenkaku_no_highlight_filetypes, &filetype) == -1 | syntax match ZenkakuSpace containedin=ALL /　/ | endif
" }}}

" カラースキーム {{{
" シンタックスハイライト
syntax enable
if !has('gui_running')
    if &t_Co < 256
        colorscheme default
    else
        try
            colorscheme wallaby
        catch
            colorscheme desert
        endtry
    endif
endif

" seoul256 バックグラウンドカラーの明るさ
let g:seoul256_background = 233
" }}}

" Ruby {{{
AutocmdFT ruby SetIndent 2
AutocmdFT ruby inoremap <buffer><C-s> self.
AutocmdFT ruby inoremap <buffer>;; ::
AutocmdFT ruby nnoremap <buffer>[unite]r :<C-u>Unite ruby/require<CR>
AutocmdFT ruby call s:matchit()
Autocmd BufRead Guardfile setlocal filetype=ruby

let s:ruby_template = [ '#!/usr/bin/env ruby', '# encoding: utf-8', '', '' ]
Autocmd BufNewFile *.rb call append(0, s:ruby_template) | normal! G

function! s:start_irb()
    VimShell -split-command=vsplit
    VimShellSendString irb
    startinsert
endfunction
command! Irb call <SID>start_irb()

function! s:toggle_binding_pry()
    if getline('.') =~# '^\s*binding\.pry\s*$'
        normal! "_ddk
    else
        normal! obinding.pry
    endif
endfunction
AutocmdFT ruby nnoremap <buffer><silent><Leader>p :<C-u>call <SID>toggle_binding_pry()<CR>

function! s:exec_with_vimshell(cmd, ...)
    let cmdline = a:cmd . ' ' . expand('%:p') . ' ' . join(a:000)
    VimShell -split-command=vsplit
    execute 'VimShellSendString' cmdline
endfunction
AutocmdFT ruby nnoremap <buffer><silent><Leader>pr :<C-u>call <SID>exec_with_vimshell('ruby')<CR>

function! s:start_pry()
    VimShell -split-command=vsplit
    VimShellSendString pry -d coolline
endfunction
command! Pry call <SID>start_pry()
"}}}

" C++ {{{

" C++ ラベル字下げ設定
set cinoptions& cinoptions+=:0,g0,N-1,m1

" -> decltype(expr) の補完
function! s:open_online_cpp_doc()
    let l = getline('.')

    if l =~# '^\s*#\s*include\s\+<.\+>'
        let header = matchstr(l, '^\s*#\s*include\s\+<\zs.\+\ze>')
        if header =~# '^boost'
            execute 'OpenBrowser' 'http://www.google.com/cse?cx=011577717147771266991:jigzgqluebe&q='.matchstr(header, 'boost/\zs[^/>]\+\ze')
        else
            execute 'OpenBrowser' 'http://en.cppreference.com/mwiki/index.php?title=Special:Search&search='.matchstr(header, '\zs[^/>]\+\ze')
        endif
    else
        let cword = expand('<cword>')
        if cword ==# ''
            return
        endif
        let line_head = getline('.')[:col('.')-1]
        if line_head =~# 'boost::[[:alnum:]:]*$'
            execute 'OpenBrowser' 'http://www.google.com/cse?cx=011577717147771266991:jigzgqluebe&q='.cword
        elseif line_head =~# 'std::[[:alnum:]:]*$'
            execute 'OpenBrowser' 'http://en.cppreference.com/mwiki/index.php?title=Special:Search&search='.cword
        else
            normal! K
        endif
    endif
endfunction

AutocmdFT cpp nnoremap <silent><buffer>K :<C-u>call <SID>open_online_cpp_doc()<CR>
AutocmdFT cpp setlocal matchpairs+=<:>
AutocmdFT cpp inoremap <buffer>,  ,<Space>
AutocmdFT cpp inoremap <expr> e getline('.')[col('.') - 6:col('.') - 2] ==# 'const' ? 'expr ' : 'e'

let g:c_syntax_for_h = 1
" }}}

" Haskell {{{
AutocmdFT haskell inoremap <buffer>;; ::
function! s:start_ghci()
    VimShell -split-command=vsplit
    VimShellSendString ghci
    startinsert
endfunction
command! Ghci call <SID>start_ghci()
"}}}

" Vim script "{{{
" gf を拡張し，autoload 関数を開けるように対応
function! s:jump_to_autoload_function_definition()
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
AutocmdFT vim call <SID>matchit()
AutocmdFT vim nnoremap <silent><buffer>gf :<C-u>call <SID>jump_to_autoload_function_definition()<CR>
AutocmdFT vim nnoremap <silent><buffer>K :<C-u>call <SID>smart_help(expand('<cword>'))<CR>
"}}}

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
AutocmdFT haml SetIndent 2
AutocmdFT javascript nnoremap <buffer><silent><Leader>no :<C-u>VimShellInteractive node<CR>
Autocmd BufRead,BufNew,BufNewFile *.ejs setlocal ft=html

" 保存時に html 自動生成
function! s:generate_html()
    if &filetype ==# 'haml' && executable('haml')
        let html = expand('%:p:r') . '.html'
        let cmdline = join(['haml', expand('%'), '>', html], ' ')
        call vimproc#system_bg(cmdline)
    endif
endfunction
Autocmd BufWritePost *.haml call <SID>generate_html()
"}}}

" Markdown {{{
AutocmdFT markdown nnoremap <buffer><silent><Leader>= :<C-u>call append('.', repeat('=', strdisplaywidth(getline('.'))))<CR>
AutocmdFT markdown nnoremap <buffer><silent><Leader>- :<C-u>call append('.', repeat('-', strdisplaywidth(getline('.'))))<CR>
let g:markdown_fenced_languages = [
            \  'cpp',
            \  'ruby',
            \  'vim',
            \  'd',
            \  'go',
            \  'haskell',
            \  'json',
            \ ]
"}}}

" Dachs {{{
" For Readme
function! s:bold(...)
    for k in a:000
        execute '%s/\%(#[^#]*\)\@<!\<' . k . '\>/<b>&<\/b>/geI'
    endfor
endfunction
function! s:to_readme_embdable_html()
    if &filetype !=# 'dachs'
        echoerr 'This command is for Dachs.'
        return
    endif

    %s/&/\&amp;/geI
    %s/</\&lt;/geI
    %s/>/\&gt;/geI

    call s:bold('end', 'var', 'do', 'as', 'if', 'unless', 'then', 'else', 'elseif', 'func', 'proc', 'ret', 'case', 'when', 'for', 'in', 'let', 'ensure', 'begin')
    %s/#[^#]*\%(#\|\_$\)/<i>&<\/i>/geI

    call append(0, '<pre>')
    call append(line('$'), '</pre>')

    setlocal filetype=html
endfunction
command -nargs=0 ToReadmeEmbdableHTML call <SID>to_readme_embdable_html()
" }}}

" CMake {{{
function! s:cmake()
    let project_root = unite#util#path2project_directory(expand('%:p'))
    if empty(project_root)
        echomsg "Project directory is not found."
        return
    endif

    if ! filereadable(project_root.'/CMakeLists.txt')
        echomsg "CMakeLists.txt is not found in root directory of the project."
        return
    endif

    execute 'QuickRun sh -src "cd '.shellescape(project_root).' && cmake ."'
endfunction

command! -nargs=0 CMake call <SID>cmake()
nnoremap <Leader>cm :<C-u>CMake<CR>
"}}}

" JSON {{{
" 自動的にオブジェクトのキーをクォートで囲む
function! s:json_colon()
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
    call setline('.', prefix . '"' . key . '" : ')
    let diff = len(getline('.')) - len(current_line)
    execute 'normal!' (diff > 0 ? diff . 'l' : -diff . 'h')
endfunction

AutocmdFT json inoremap <buffer>: :<C-o>:call <SID>json_colon()<CR>
AutocmdFT json inoremap <buffer><C-j> <End>,<CR>
" }}}

" Python {{{
function! s:python_settings()
    setlocal noautoindent nosmartindent nocindent
endfunction
AutocmdFT python call <SID>python_settings()
"}}}

" Go {{{
function! s:golang_settings()
    " Godoc でカーソル下のワードを調べる
    nnoremap <buffer><silent>K :<C-u>execute 'Godoc' expand('<cword>')<CR>
    "   Note: 'fmt.Printf' -> 'fmt Printf'
    vnoremap <buffer><silent>K y:<C-u>execute 'Godoc' substitute(getreg('+'), '\.', ' ', 'g')<CR>
    " カーソル下のワードをインポート
    nnoremap <buffer><silent>:gi :<C-u>execute 'Import' expand('<cword>')<CR>
    " インポートをやめる
    nnoremap <buffer>:gd :<C-u>Drop<Space>
    " フォーマット
    nnoremap <buffer>:gf :<C-u>Fmt<CR>
    " インサートモード中にインポート
    inoremap <buffer><silent><C-g>i <C-o>:<C-u>execute 'Import' matchstr(getline('.')[:col('.')-1], '\h\w*\ze\W*$')<CR><Right>
    " ハードタブ推奨
    setlocal noexpandtab
    let g:go_fmt_autofmt = 1
    nnoremap <buffer><Space>i :<C-u>Unite go/import<CR>
    let g:godef_split = 0
    let g:godef_same_file_in_same_window = 1
endfunction

AutocmdFT go call <SID>golang_settings()
AutocmdFT godoc nnoremap<buffer>q :<C-u>quit<CR>
AutocmdFT godoc nnoremap<buffer>d <C-d>
AutocmdFT godoc nnoremap<buffer>u <C-u>
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
let g:neocomplete#min_keyword_length = 3
let g:neocomplete#sources#syntax#min_keyword_length = 3
"補完を開始する入力文字長
let g:neocomplete#auto_completion_start_length = 2
"日本語を収集しないようにする
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'
" ctags は自分の用意したものを使う
if executable('/usr/local/bin/ctags')
    let g:neocomplete#ctags_command = '/usr/local/bin/ctags'
elseif executable('/usr/bin/ctags')
    let g:neocomplete#ctags_command = '/usr/bin/gctags'
endif
" Ruby の外部ファイルの拡張子
let g:neocomplete#sources#file_include#exts
            \ = get(g:, 'neocomplete#sources#file_include#exts', {})
let g:neocomplete#sources#file_include#exts.ruby = ['', 'rb']
"リスト表示
let g:neocomplete#max_list = 300
" 辞書定義
let g:neocomplete#sources#dictionary#dictionaries = {
            \ 'default' : '',
            \ 'vimshell' : expand('~/.vimshell/command-history'),
            \ }
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
let g:neocomplete#sources#include#paths.cpp  = '.,/usr/local/include,/usr/local/opt/gcc49/lib/gcc/x86_64-apple-darwin13.1.0/4.9.0/include/c++,/usr/include'
let g:neocomplete#sources#include#paths.c    = '.,/usr/include'
let g:neocomplete#sources#include#paths.perl = '.,/System/Library/Perl,/Users/rhayasd/Programs'
let g:neocomplete#sources#include#paths.ruby = expand('~/.rbenv/versions/2.0.0-p195/lib/ruby/2.0.0')
"インクルード文のパターンを指定
let g:neocomplete#sources#include#patterns = { 'c' : '^\s*#\s*include', 'cpp' : '^\s*#\s*include', 'ruby' : '^\s*require', 'perl' : '^\s*use', }
"インクルード先のファイル名の解析パターン
let g:neocomplete#filename#include#exprs = {
            \ 'ruby' : "substitute(substitute(v:fname,'::','/','g'),'$','.rb','')"
            \ }
" オムニ補完を有効にする(ruby のオムニ補完は挙動が怪しいので off)
AutocmdFT python setlocal omnifunc=pythoncomplete#Complete
AutocmdFT html   setlocal omnifunc=htmlcomplete#CompleteTags
AutocmdFT css    setlocal omnifunc=csscomplete#CompleteCss
AutocmdFT xml    setlocal omnifunc=xmlcomplete#CompleteTags
AutocmdFT php    setlocal omnifunc=phpcomplete#CompletePHP
AutocmdFT c      setlocal omnifunc=ccomplete#Complete
" オムニ補完を実行するパターン
if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.c   = '\%(\.\|->\)\h\w*'
let g:neocomplete#sources#omni#input_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.javascript = '\%(\h\w*\|[^. \t]\.\w*\)'
" neocomplete 補完用関数
let g:neocomplete#sources#vim#complete_functions = {
    \ 'Unite' : 'unite#complete_source',
    \ 'VimShellExecute' : 'vimshell#vimshell_execute_complete',
    \ 'VimShellInteractive' : 'vimshell#vimshell_execute_complete',
    \ 'VimShellTerminal' : 'vimshell#vimshell_execute_complete',
    \ 'VimShell' : 'vimshell#complete',
    \ 'VimFiler' : 'vimfiler#complete',
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
    let g:neocomplete#sources#omni#functions.coffee = 'tern#Complete'
    AutocmdFT javascript setlocal omnifunc=tern#Complete
else
    let g:neocomplete#sources#omni#functions.javascript = 'jscomplete#CompleteJS'
    AutocmdFT javascript setlocal omnifunc=jscomplete#CompleteJS
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
else
" neocomplcache.vim {{{
"AutoComplPopを無効にする
let g:acp_enableAtStartup = 0
"vim起動時に有効化
let g:neocomplcache_enable_at_startup = 1
"smart_caseを有効にする．大文字が入力されるまで大文字小文字の区別をなくす
let g:neocomplcache_enable_smart_case = 1
"_を区切りとした補完を有効にする
let g:neocomplcache_enable_underbar_completion = 1
"シンタックスをキャッシュするときの最小文字長を3に
let g:neocomplcache_min_syntax_length = 3
"日本語を収集しないようにする
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'
"リスト表示
let g:neocomplcache_max_list = 300
let g:neocomplcache_max_keyword_width = 20
" 辞書定義
let g:neocomplcache_dictionary_filetype_lists = {
            \ 'default' : '',
            \ 'vimshell' : expand('~/.vimshell/command-history'),
            \ }
"区切り文字パターンの定義
if !exists('g:neocomplcache_delimiter_patterns')
    let g:neocomplcache_delimiter_patterns = {}
endif
let g:neocomplcache_delimiter_patterns.vim = ['#']
let g:neocomplcache_delimiter_patterns.cpp = ['::']
"インクルードパスの指定
if !exists('g:neocomplcache_include_paths')
    let g:neocomplcache_include_paths = {}
endif
let g:neocomplcache_include_paths.cpp  = '.,/usr/local/include,/usr/local/opt/gcc49/lib/gcc/x86_64-apple-darwin13.1.0/4.9.0/include/c++,/usr/include'
let g:neocomplcache_include_paths.c    = '.,/usr/include'
let g:neocomplcache_include_paths.perl = '.,/System/Library/Perl,/Users/rhayasd/Programs'
let g:neocomplcache_include_paths.ruby = expand('~/.rbenv/versions/2.0.0-p195/lib/ruby/2.0.0')
"インクルード文のパターンを指定
let g:neocomplcache_include_patterns = { 'cpp' : '^\s*#\s*include', 'ruby' : '^\s*require', 'perl' : '^\s*use', }
"インクルード先のファイル名の解析パターン
let g:neocomplcache_include_exprs = {
            \ 'ruby' : "substitute(substitute(v:fname,'::','/','g'),'$','.rb','')"
            \ }
" Enable omni completion.
AutocmdFT python     setlocal omnifunc=pythoncomplete#Complete
AutocmdFT javascript setlocal omnifunc=javascriptcomplete#CompleteJS
AutocmdFT html       setlocal omnifunc=htmlcomplete#CompleteTags
AutocmdFT css        setlocal omnifunc=csscomplete#CompleteCss
AutocmdFT xml        setlocal omnifunc=xmlcomplete#CompleteTags
AutocmdFT php        setlocal omnifunc=phpcomplete#CompletePHP
AutocmdFT c          setlocal omnifunc=ccomplete#Complete
" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
    let g:neocomplcache_omni_patterns = {}
endif
    " let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c   = '\%(\.\|->\)\h\w*'
let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'
" neocomplcache 補完用関数
let g:neocomplcache_vim_completefuncs = {
    \ 'Unite' : 'unite#complete_source',
    \ 'VimShellExecute' : 'vimshell#vimshell_execute_complete',
    \ 'VimShellInteractive' : 'vimshell#vimshell_execute_complete',
    \ 'VimShellTerminal' : 'vimshell#vimshell_execute_complete',
    \ 'VimShell' : 'vimshell#complete',
    \ 'VimFiler' : 'vimfiler#complete',
    \}
"ctagsへのパス
if executable('/usr/local/bin/ctags')
    let g:neocomplcache_ctags_program = '/usr/local/bin/ctags'
elseif executable('/usr/bin/ctags')
    let g:neocomplcache_ctags_program = '/usr/bin/ctags'
endif

"neocomplcacheのマッピング
inoremap <expr><C-g> neocomplcache#undo_completion()
inoremap <expr><C-s> neocomplcache#complete_common_string()
" <CR>: close popup and save indent.
" <Tab>: completion
inoremap <expr><Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
"<C-h>, <BS>: close popup and delete backword char.
                     " inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
                     " inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y> neocomplcache#close_popup()
" HACK: This hack needs because of using both vim-smartinput and neocomplcache
" when <CR> is typed.
"    A user types <CR> ->
"    smart_close_popup() is called when pumvisible() ->
"    <Plug>(physical_key_return) hooked by vim-smartinput is used
imap <expr><CR> (pumvisible() ? neocomplcache#smart_close_popup() : "")."\<Plug>(physical_key_return)"
" コマンドラインウィンドウでは Tab の挙動が変わるのでワークアラウンド
Autocmd CmdwinEnter * inoremap <silent><buffer><Tab> <C-n>
Autocmd CmdwinEnter * inoremap <expr><buffer><CR> (pumvisible() ? neocomplcache#smart_close_popup() : "")."\<CR>"
Autocmd CmdwinEnter * inoremap <silent><buffer><expr><C-h> col('.') == 1 ?
                                    \ "\<ESC>:quit\<CR>" : neocomplcache#cancel_popup()."\<C-h>"
Autocmd CmdwinEnter * inoremap <silent><buffer><expr><BS> col('.') == 1 ?
                                    \ "\<ESC>:quit\<CR>" : neocomplcache#cancel_popup()."\<BS>"
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
" C++ と Python と D の標準のスニペットを読み込まない
let g:neosnippet#disable_runtime_snippets = {'cpp' : 1, 'python' : 1, 'd' : 1}
"}}}

" unite.vim {{{
let s:bundle = neobundle#get("unite.vim")
function! s:bundle.hooks.on_source(bundle)
    " 無指定にすることで高速化
    let g:unite_source_file_mru_filename_format = ''
    " most recently used のリストサイズ
    let g:unite_source_file_mru_limit = 100
    " unite-grep で使うコマンド
    let g:unite_source_grep_default_opts = "-Hn --color=never"
    " the silver searcher を unite-grep のバックエンドにする
    if executable('ag')
        let g:unite_source_grep_command = 'ag'
        let g:unite_source_grep_default_opts = '--nocolor --nogroup --column'
        let g:unite_source_grep_recursive_opt = ''
    endif

    " Git リポジトリのすべてのファイルを開くアクション {{{
    let git_repo = { 'description' : 'all file in git repository' }
    function! git_repo.func(candidate)
        if(system('git rev-parse --is-inside-work-tree') ==# "true\n" )
            execute 'args'
                    \ join( filter(split(system('git ls-files `git rev-parse --show-cdup`'), '\n')
                            \ , 'empty(v:val) || isdirectory(v:val) || filereadable(v:val)') )
        else
            echoerr 'Not a git repository!'
        endif
    endfunction

    call unite#custom#action('file', 'git_repo_files', git_repo)
    " }}}

    " ファイルなら開き，ディレクトリなら VimFiler に渡す {{{
    let open_or_vimfiler = {
                \ 'description' : 'open a file or open a directory with vimfiler',
                \ 'is_selectable' : 1,
                \ }
    function! open_or_vimfiler.func(candidates)
        for candidate in a:candidates
            if candidate.kind ==# 'directory'
                execute 'VimFiler' candidate.action__path
                return
            endif
        endfor
        execute 'args' join(map(a:candidates, 'v:val.action__path'), ' ')
    endfunction
    call unite#custom#action('file', 'open_or_vimfiler', open_or_vimfiler)
    "}}}

    " Finder for Mac
    if has('mac')
        let finder = { 'description' : 'open with Finder.app' }
        function! finder.func(candidate)
            if a:candidate.kind ==# 'directory'
                call unite#util#system('open -a Finder '.a:candidate.action__path)
            endif
        endfunction
        call unite#custom#action('directory', 'finder', finder)
    endif

    call unite#custom#profile('source/quickfix,source/outline,source/line,source/grep', 'context', {'prompt_direction' : 'top'})
    call unite#custom#profile('source/ghq', 'context', {'default_action' : 'vimfiler'})

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
nnoremap <silent>[unite]<Space>   :<C-u>UniteWithBufferDir -buffer-name=files -vertical file directory file/new<CR>
"最近使用したファイル
nnoremap <silent>[unite]m         :<C-u>Unite file_mru directory_mru zsh-cdr file/new<CR>
"指定したディレクトリ以下を再帰的に開く
nnoremap <silent>[unite]R       :<C-u>UniteWithBufferDir -no-start-insert file_rec/async -auto-resize<CR>
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
" Unite ソース一覧
nnoremap <silent>[unite]s         :<C-u>Unite source -vertical<CR>
" NeoBundle
nnoremap <silent>[unite]nb        :<C-u>Unite neobundle/update:all -auto-quit -keep-focus -log<CR>
" Haskell Import
AutocmdFT haskell nnoremap <buffer>[unite]hd :<C-u>Unite haddock<CR>
AutocmdFT haskell nnoremap <buffer>[unite]ho :<C-u>Unite hoogle<CR>
AutocmdFT haskell nnoremap <buffer><expr>[unite]hi
                    \        empty(expand("<cWORD>")) ? ":\<C-u>Unite haskellimport\<CR>"
                    \                                 :":\<C-u>UniteWithCursorWord haskellimport\<CR>"
" Git のルートディレクトリを開く
nnoremap <silent><expr>[unite]fg  ":\<C-u>Unite file -input=".fnamemodify(<SID>git_root_dir(),":p")
" alignta (visual)
vnoremap <silent>[unite]aa        :<C-u>Unite alignta:arguments<CR>
vnoremap <silent>[unite]ao        :<C-u>Unite alignta:options<CR>
" C++ インクルードファイル
AutocmdFT cpp nnoremap <buffer>[unite]i :<C-u>Unite file_include -vertical<CR>
" help(項目が多いので，検索語を入力してから絞り込む)
nnoremap <silent>[unite]hh        :<C-u>UniteWithInput help -vertical<CR>
" 履歴
nnoremap <silent>[unite]hc        :<C-u>Unite -buffer-name=lines history/command -start-insert<CR>
nnoremap <silent>[unite]hs        :<C-u>Unite -buffer-name=lines history/search<CR>
nnoremap <silent>[unite]hy        :<C-u>Unite -buffer-name=lines history/yank<CR>
" プロジェクトのファイル一覧
nnoremap <silent>[unite]p         :<C-u>Unite file_rec:! file/new<CR>
" unite-lines ファイル内インクリメンタル検索
nnoremap <silent><expr> [unite]L line('$') > 5000 ?
            \ ":\<C-u>Unite -buffer-name=search -no-split -start-insert line/fast\<CR>" :
            \ ":\<C-u>Unite -buffer-name=search -start-insert line:all\<CR>"
" カラースキーム
nnoremap [unite]C :<C-u>Unite -auto-preview colorscheme<CR>
" locate
nnoremap <silent>[unite]l :<C-u>UniteWithInput locate<CR>
" 検索
nnoremap <silent>[unite]/ :<C-u>execute 'Unite grep:'.expand('%:p').' -input='.escape(substitute(@/, '^\\v', '', ''), ' \')<CR>
" ghq
nnoremap <silent>[unite]gg :<C-u>Unite -start-insert -default-action=vimfiler ghq directory_mru<CR>
" }}}

" }}}

" unite-rails "{{{
function! s:rails_mvc_name()
    let full_path = expand('%:p')
    if  full_path !~# '\/app\/'
        echoerr 'not rails MVC files'
    endif

    " controllers
    let base_name = expand('%:r')
    if base_name =~# '\w\+_controller'
        if  full_path !~# '\/controllers\/'
            echoerr 'not rails MVC files'
        endif
        return matchstr(base_name, '\w\+\ze_controller')
    endif

    " views
    if expand('%:e:e') == 'html.erb'
        return fnamemodify(full_path, ':h:t')
    endif

    " models
    if fnamemodify(full_path, ':h:t') == 'models'
        return base_name
    endif

    echoerr 'not rails MVC files'
endfunction

" unite-rails コマンド {{{
command! -nargs=0 RModels      Unite rails/model -no-start-insert
command! -nargs=0 RControllers Unite rails/controller -no-start-insert
command! -nargs=0 RViews       Unite rails/view -no-start-insert
command! -nargs=0 RMVC         Unite rails/model rails/controller rails/view
command! -nargs=0 RHelpers     Unite rails/helpers -no-start-insert
command! -nargs=0 RMailers     Unite rails/mailers -no-start-insert
command! -nargs=0 RLib         Unite rails/lib -no-start-insert
command! -nargs=0 RDb          Unite rails/db -no-start-insert
command! -nargs=0 RConfig      Unite rails/config -no-start-insert
command! -nargs=0 RLog         Unite rails/log -no-start-insert
command! -nargs=0 RJapascripts Unite rails/javascripts -no-start-insert
command! -nargs=0 RStylesheets Unite rails/stylesheets -no-start-insert
command! -nargs=0 RBundle      Unite rails/bundle -no-start-insert
command! -nargs=0 RGems        Unite rails/bundled_gem -no-start-insert
command! -nargs=0 R            execute 'Unite rails/model rails/controller rails/view -no-start-insert -input=' . s:rails_mvc_name()
"}}}
"}}}

" unite-n3337 "{{{
let g:unite_n3337_pdf = $HOME.'/Documents/C++/n3337.pdf'
AutocmdFT cpp nnoremap <buffer>[unite]n :<C-u>Unite n3337<CR>
"}}}

" VimShellの設定 {{{
" 実行キーマッピング
nnoremap <silent><Leader>vs :<C-u>VimShell -split-command=vsplit<CR>
nnoremap <Leader>vc :<C-u>VimShellSendString<Space>

let s:bundle = neobundle#get("vimshell")
function! s:bundle.hooks.on_source(bundle)
    " プロンプト
    let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
    let g:vimshell_right_prompt = 'strftime("%Y/%m/%d %H:%M")'
    let g:vimshell_prompt = "(U'w'){ "
    " let g:vimshell_prompt = "(U^w^){ "
    " executable suffix
    let g:vimshell_execute_file_list = { 'pdf' : 'open', 'mp3' : 'open',
                                       \ 'jpg' : 'open', 'png' : 'open',
                                       \ }
    " zsh 履歴も利用する
    if filereadable(expand('~/.zsh/zsh_history'))
        let g:vimshell_external_history_path = expand('~/.zsh/zsh_history')
    endif

    " VimShell のキーマッピング {{{
    " コマンド履歴の移動
    " バッファ移動の <C-n> <C-p> が潰されているので再マッピング
    AutocmdFT vimshell nnoremap <buffer><silent><C-n> :<C-u>bn<CR>
    AutocmdFT vimshell nnoremap <buffer><silent><C-p> :<C-u>bp<CR>
    AutocmdFT vimshell nmap <buffer><silent>gn <Plug>(vimshell_next_prompt)
    AutocmdFT vimshell nmap <buffer><silent>gp <Plug>(vimshell_previous_prompt)
    " VimFiler 連携
    AutocmdFT vimshell nnoremap <buffer><silent><Leader>ff :<C-u>VimFilerCurrentDir<CR>
    AutocmdFT vimshell inoremap <buffer><silent><C-s> <Esc>:<C-u>VimFilerCurrentDir<CR>
    " 親ディレクトリへ移動
    AutocmdFT vimshell imap <buffer><silent><C-j> <C-u>..<Plug>(vimshell_enter)
    " popd
    AutocmdFT vimshell imap <buffer><silent><C-p> <C-u>popd<Plug>(vimshell_enter)
    " git status
    AutocmdFT vimshell imap <buffer><silent><C-q> <C-u>git status -sb<Plug>(vimshell_enter)
    " zsh や bash の <C-d> っぽい挙動
    AutocmdFT vimshell imap <buffer><silent><expr><C-d> vimshell#get_cur_text()=='' ? "\<Esc>\<Plug>(vimshell_exit)" : "\<Del>"
    " 最新のプロンプトに移動
    AutocmdFT vimshell nnoremap <buffer>a GA
    " }}}
endfunction
unlet s:bundle

" }}}

" vim-quickrunの設定 {{{
"<Leader>r を使わない
let g:quickrun_no_default_key_mappings = 1
" quickrun_configの初期化
let g:quickrun_config = get(g:, 'quickrun_config', {})
"QuickRun 結果の開き方
let g:quickrun_config._ = {
            \ 'outputter' : 'unite_quickfix',
            \ 'split' : 'rightbelow 10sp',
            \ 'hook/hier_update/enable' : 1,
            \ 'runner/vimproc/updatetime' : 500,
            \ }
"C++
let g:quickrun_config.cpp = {
            \ 'command' : 'clang++',
            \ 'cmdopt' : '-std=c++1y -Wall -Wextra -O2',
            \ 'hook/quickrunex/enable' : 1,
            \ }
let g:quickrun_config['cpp/llvm'] = {
            \ 'type' : 'cpp/clang++',
            \ 'exec' : '%c %o -emit-llvm -S %s -o -',
            \ }
let g:quickrun_config['c/llvm'] = {
            \ 'type' : 'c/clang',
            \ 'exec' : '%c %o -emit-llvm -S %s -o -',
            \ }
" プリプロセスのみ
let g:quickrun_config['cpp/preprocess/g++'] = { 'type' : 'cpp/g++', 'exec' : '%c -P -E %s' }
let g:quickrun_config['cpp/preprocess/clang++'] = { 'type' : 'cpp/clang++', 'exec' : '%c -P -E %s' }
let g:quickrun_config['cpp/preprocess'] = { 'type' : 'cpp', 'exec' : '%c -P -E %s' }
"outputter
let g:quickrun_unite_quickfix_outputter_unite_context = { 'no_empty' : 1 }
" runner vimproc における polling 間隔
let g:quickrun_config['_']['runner/vimproc/updatetime'] = 500
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
            \   'exec' : ['%c %o %s:p', '%s:p:r %a'],
            \ }

let g:quickrun_config['dachs/llvm'] = {
            \   'type' : 'dachs',
            \   'cmdopt' : '--emit-llvm',
            \   'exec' : '%c %o %s:p',
            \ }


" シンタックスチェック
let g:quickrun_config['syntax/cpp/g++'] = {
            \ 'runner' : 'vimproc',
            \ 'outputter' : 'quickfix',
            \ 'command' : 'g++',
            \ 'cmdopt' : '-std=c++1y -Wall -Wextra -O2',
            \ 'exec' : '%c %o -fsyntax-only %s:p'
            \ }

let g:quickrun_config['syntax/ruby'] = {
            \ 'runner' : 'vimproc',
            \ 'outputter' : 'quickfix',
            \ 'command' : 'ruby',
            \ 'exec' : '%c -c %s:p %o',
            \ }
Autocmd BufWritePost *.rb QuickRun -type syntax/ruby

if executable('jshint')
    let g:quickrun_config['syntax/javascript'] = {
                \ 'command' : 'jshint',
                \ 'outputter' : 'quickfix',
                \ 'exec'    : '%c %o %s:p',
                \ 'runner' : 'vimproc',
                \ 'errorformat' : '%f: line %l\, col %c\, %m',
                \ }
    Autocmd BufWritePost *.js QuickRun -type syntax/javascript
endif

let g:quickrun_config['syntax/haml'] = {
            \ 'runner' : 'vimproc',
            \ 'command' : 'haml',
            \ 'outputter' : 'quickfix',
            \ 'exec'    : '%c -c %o %s:p',
            \ 'errorformat' : 'Haml error on line %l: %m,Syntax error on line %l: %m,%-G%.%#',
            \ }
Autocmd BufWritePost *.haml QuickRun -type syntax/haml

if executable('pyflakes')
    let g:quickrun_config['syntax/python'] = {
                \ 'command' : 'pyflakes',
                \ 'exec' : '%c %o %s:p',
                \ 'outputter' : 'quickfix',
                \ 'runner' : 'vimproc',
                \ 'errorformat' : '%f:%l:%m',
                \ }
    Autocmd BufWritePost *.py QuickRun -type syntax/python
endif

if executable('go')
    let g:quickrun_config['syntax/go'] = {
                \ 'command' : 'go',
                \ 'exec' : '%c vet %o %s:p',
                \ 'outputter' : 'quickfix',
                \ 'runner' : 'vimproc',
                \ 'errorformat' : '%Evet: %.%\+: %f:%l:%c: %m,%W%f:%l: %m,%-G%.%#',
                \ }
    Autocmd BufWritePost *.go QuickRun -type syntax/go
endif

"QuickRunのキーマップ {{{
nnoremap <Leader>q  <Nop>
nnoremap <silent><Leader>qr :<C-u>QuickRun<CR>
vnoremap <silent><Leader>qr :QuickRun<CR>
nnoremap <silent><Leader>qR :<C-u>QuickRun<Space>
" clang で実行する
let g:quickrun_config['cpp/clang'] = { 'command' : 'clang++', 'cmdopt' : '-stdlib=libc++ -std=c++11 -Wall -Wextra -O2' }
AutocmdFT cpp nnoremap <silent><buffer><Leader>qc :<C-u>QuickRun -type cpp/clang<CR>
" }}}
" }}}

" accelerated-jk "{{{
let g:accelerated_jk_enable_deceleration = 1
nmap j <Plug>(accelerated_jk_gj)
nmap k <Plug>(accelerated_jk_gk)
"}}}

" open-pdf.vim の設定 "{{{
let g:pdf_convert_on_edit = 1
let g:pdf_convert_on_read = 1

if !exists('g:pdf_hooks')
    let g:pdf_hooks = {}
endif
function! g:pdf_hooks.on_opened()
    setlocal nowrap nonumber nolist
endfunction

Autocmd BufRead,BufNew *.pdf NeoBundleSource open-pdf.vim

"}}}

" Hier.vim {{{
nnoremap <silent><Esc><Esc> :<C-u>nohlsearch<CR>:HierClear<CR>
" }}}

" VimFilerの設定 {{{

" VimFiler の読み込みを遅延しつつデフォルトのファイラに設定 {{{
augroup LoadVimFiler
    autocmd!
    autocmd BufEnter,BufCreate,BufWinEnter * call <SID>load_vimfiler(expand('<amatch>'))
augroup END

" :edit {dir} や unite.vim などでディレクトリを開こうとした場合
function! s:load_vimfiler(path)
    if exists('g:loaded_vimfiler')
        autocmd! LoadVimFiler
        return
    endif

    let path = a:path
    " for ':edit ~'
    if fnamemodify(path, ':t') ==# '~'
        let path = expand('~')
    endif

    if isdirectory(path)
        NeoBundleSource vimfiler
    endif

    autocmd! LoadVimFiler
endfunction

" 起動時にディレクトリを指定した場合
for arg in argv()
    if isdirectory(getcwd().'/'.arg)
        NeoBundleSource vimfiler.vim
        autocmd! LoadVimFiler
        break
    endif
endfor
"}}}

let g:loaded_netrwPlugin = 1
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_safe_mode_by_default = 0
let g:vimfiler_split_command = 'vertical rightbelow vsplit'
let g:vimfiler_execute_file_list = { '_' : 'vim', 'pdf' : 'open', 'mp3' : 'open', 'jpg' : 'open',
                                   \ 'png' : 'open',
                                   \ }
let g:vimfiler_split_rule = 'botright'

" vimfiler.vim のキーマップ {{{
" smart s mapping for edit or cd
AutocmdFT vimfiler nmap <buffer><silent><expr> l vimfiler#smart_cursor_map(
            \ "\<Plug>(vimfiler_cd_file)",
            \ "\<Plug>(vimfiler_edit_file)")
" jump to VimShell
AutocmdFT vimfiler nnoremap <buffer><silent><Leader>vs
            \ :<C-u>VimShellCurrentDir<CR>
" 'a'nother
AutocmdFT vimfiler nmap <buffer><silent>a <Plug>(vimfiler_switch_to_another_vimfiler)
" unite.vim に合わせる
AutocmdFT vimfiler nmap <buffer><silent><Tab> <Plug>(vimfiler_choose_action)
" <Space> の代わりに u を unite.vim のプレフィクスに使う
AutocmdFT vimfiler nmap <buffer><silent>u [unite]
" unite.vim の file_mru との連携
AutocmdFT vimfiler nnoremap <buffer><silent><C-h> :<C-u>Unite file_mru directory_mru<CR>
" unite.vim の file との連携
AutocmdFT vimfiler
            \ nnoremap <buffer><silent>/
            \ :<C-u>execute 'Unite' 'file:'.vimfiler#get_current_vimfiler().current_dir '-default-action=open_or_vimfiler'<CR>
" git リポジトリに登録されたすべてのファイルを開く
AutocmdFT vimfiler nnoremap <buffer><expr>ga vimfiler#do_action('git_repo_files')

nnoremap <Leader>f                <Nop>
nnoremap <Leader>ff               :<C-u>VimFiler<CR>
nnoremap <Leader>fs               :<C-u>VimFilerSplit<CR>
nnoremap <Leader><Leader>         :<C-u>VimFiler<CR>
nnoremap <Leader>fq               :<C-u>VimFiler -no-quit<CR>
nnoremap <Leader>fh               :<C-u>VimFiler ~<CR>
nnoremap <Leader>fc               :<C-u>VimFilerCurrentDir<CR>
nnoremap <Leader>fb               :<C-u>VimFilerBufferDir<CR>
nnoremap <silent><expr><Leader>fg ":\<C-u>VimFiler " . <SID>git_root_dir() . '\<CR>'
nnoremap <silent><expr><Leader>fe ":\<C-u>VimFilerExplorer " . <SID>git_root_dir() . '\<CR>'
nnoremap <Leader>fd               :<C-u>VimFilerDouble -tab<CR>
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
            \   'filetype' : ['cpp'],
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
            \   'filetype' : ['cpp'],
            \   })
" detail:: の補完
call smartinput#define_rule({
            \   'at'       : '\%(\s\|::\)d;\%#',
            \   'char'     : ';',
            \   'input'    : '<BS>etail::',
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
            \   'input' : "<CR><C-r>=endwize#crend()<CR>",
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
nmap <Leader>cc <Plug>(caw:i:toggle)
" 行末尾コメント
nmap <Leader>ca <Plug>(caw:a:toggle)
" ブロックコメント
nmap <Leader>cb <Plug>(caw:wrap:toggle)
" 改行後コメント
nmap <Leader>co <Plug>(caw:jump:comment-next)
nmap <Leader>cO <Plug>(caw:jump:comment-prev)
" caw 用オペレータ
let s:bundle = neobundle#get("caw.vim")
function! s:bundle.hooks.on_source(bundle)
    function! s:op_caw_commentout(motion_wise)
        if a:motion_wise ==# 'char'
            execute 'normal' "`[v`]\<Plug>(caw:wrap:toggle)"
        else
            execute "normal" "`[V`]\<Plug>(caw:i:toggle)"
        endif
    endfunction
    call operator#user#define('caw', s:SID.'op_caw_commentout')
endfunction
unlet s:bundle
map <Leader>c <Plug>(operator-caw)
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
" operator-filled-with-blank
map <silent><Leader>b <Plug>(operator-filled-with-blank)
" vim-operator-evalruby
if executable($HOME.'/.rbenv/shims/ruby')
    let g:operator_evalruby_command = $HOME . '/.rbenv/shims/ruby'
endif
map <silent><Leader>x <Plug>(operator-evalruby)
" vim-clang-format
let g:clang_format#style_options = {
            \ 'AccessModifierOffset' : -4,
            \ 'AllowShortIfStatementsOnASingleLine' : 'true',
            \ 'AlwaysBreakTemplateDeclarations' : 'true',
            \ 'Standard' : 'C++11',
            \ 'BreakBeforeBraces' : 'Stroustrup',
            \ }
AutocmdFT c,cpp map <buffer><Leader>x <Plug>(operator-clang-format)
" vim-operator-surround {{{
let g:operator#surround#blocks =
            \ {
            \   '-' : [
            \       { 'block' : ['(', ')'], 'motionwise' : ['char', 'line', 'block'], 'keys' : ['p'] },
            \       { 'block' : ['[', ']'], 'motionwise' : ['char', 'line', 'block'], 'keys' : ['c'] },
            \       { 'block' : ['{', '}'], 'motionwise' : ['char', 'line', 'block'], 'keys' : ['b'] },
            \       { 'block' : ['<', '>'], 'motionwise' : ['char', 'line', 'block'], 'keys' : ['a'] },
            \       { 'block' : ['"', '"'], 'motionwise' : ['char', 'line', 'block'], 'keys' : ['q'] },
            \       { 'block' : ["'", "'"], 'motionwise' : ['char', 'line', 'block'], 'keys' : ["s"] },
            \   ]
            \ }
map <silent>gy <Plug>(operator-surround-append)
map <silent>gd <Plug>(operator-surround-delete)
map <silent>gc <Plug>(operator-surround-replace)
nmap <silent>gdd <Plug>(operator-surround-delete)<Plug>(textobj-anyblock-a)
nmap <silent>gcc <Plug>(operator-surround-replace)<Plug>(textobj-anyblock-a)
nmap <silent>gdb <Plug>(operator-surround-delete)<Plug>(textobj-between-a)
nmap <silent>gcb <Plug>(operator-surround-replace)<Plug>(textobj-between-a)
"}}}
" vim-operator-insert
map <silent><Leader>i <Plug>(operator-insert-i)
map <silent><Leader>a <Plug>(operator-insert-a)
"}}}

" ghcmod-vim {{{
AutocmdFT haskell nnoremap <buffer><C-t> :<C-u>GhcModType<CR>
AutocmdFT haskell let &l:statusline = '%{empty(getqflist()) ? "[No Errors] " : "[Errors Found] "}'
                                            \ . (empty(&l:statusline) ? &statusline : &l:statusline)
AutocmdFT haskell nnoremap <buffer><silent><Esc><Esc> :<C-u>nohlsearch<CR>:HierClear<CR>:GhcModTypeClear<CR>
AutocmdFT haskell nnoremap <buffer><Leader>ge :<C-u>GhcModExpand<CR>
Autocmd BufWritePost *.hs GhcModCheckAndLintAsync
let g:ghcmod_open_quickfix_function = s:SID . 'open_quickfix_with_unite'
function! s:open_quickfix_with_unite()
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
let g:neosnippet#snippets_directory=$HOME.'/.vim/bundle/inu-snippets/snippets'
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
      \ ["Align first spaces", '0 \s/1' ],
      \]

let g:unite_source_alignta_preset_options = [
      \ ["Justify Left",             '<<' ],
      \ ["Justify Center",           '||' ],
      \ ["Justify Right",            '>>' ],
      \ ["Justify None",             '==' ],
      \ ["Shift Left",               '<-' ],
      \ ["Shift Right",              '->' ],
      \ ["Shift Left  [Tab]",        '<--'],
      \ ["Shift Right [Tab]",        '-->'],
      \ ["Margin 0:0",               '0'  ],
      \ ["Margin 0:1",               '01' ],
      \ ["Margin 1:0",               '10' ],
      \ ["Margin 1:1",               '1'  ],
      \ [" : (key: val)",            '01 :'],
      \ [" , (ruby array #comment)", ',\zs 0:1 #'],
      \ ["Not space",                '\S\+'],
      \]

" }}}

" endwize.vim "{{{
" 自動挿入された end の末尾に情報を付け加える e.g. end # if hoge

let g:endwize_add_verbose_info_filetypes = ['c', 'cpp']
AutocmdFT dachs
    \ let b:endwize_addition = '\=submatch(0)=="let" ? "in" : "end"' |
    \ let b:endwize_words = 'func,proc,if,unless,case,for,do,let' |
    \ let b:endwize_pattern = '^\s*\%(in\s\+\)\=\zs\%(func\|proc\|if\|unless\|case\|for\)\>\%(.*[^.:@$]\<end\>\)\@!\|\<do\ze\%(\s*|.*|\|\<let\>\%(.*[^.:@$]\<in\>\)\@!\)\=\s*$' |
    \ let b:endwize_syngroups = 'dachsConditional,dachsControl,dachsFuncDefine,dachsRepeat' |
    \ let b:endwize_comment = '#'
"}}}

" open-browser.vim "{{{
nmap <Leader>o <Plug>(openbrowser-smart-search)
xmap <Leader>o <Plug>(openbrowser-smart-search)
nnoremap <Leader>O :<C-u>OpenGithubFile<CR>
vnoremap <Leader>O :OpenGithubFile<CR>
"}}}

" vim-vspec {{{
" filetype definition
Autocmd BufRead,BufNew,BufNewFile *_spec.vim setlocal ft=vim.vspec

function! s:vspec(file, opts)
    if ! isdirectory($HOME.'/.vim/bundle/vim-vspec')
        echoerr "Error: vspec is not found."
    endif

    let args = ' '
    if isdirectory($HOME.'/.vim/bundle/vim-vspec-matchers')
        let args .= '$HOME/.vim/bundle/vim-vspec-matchers '
    endif

    execute 'QuickRun' 'sh' '-src' '''PATH=/usr/local/bin:$PATH $HOME/.vim/bundle/vim-vspec/bin/vspec $HOME/.vim/bundle/vim-vspec '.args.a:opts.' '.a:file.''''
endfunction
command! -nargs=* Vspec call <SID>vspec(expand('%:p'), <q-args>)

if executable('vim-flavor')
    function! s:flavor()
        let t = fnamemodify(finddir('t', '.;'), ':h')
        if t == ''
            echoerr "a directory named 't' is not found"
            return
        endif
        execute 'QuickRun' 'sh' '-src' '''PATH=/usr/local/bin:$PATH cd '.t.' && vim-flavor test'''
    endfunction
    command! -nargs=0 Flavor call <SID>flavor()
endif

let g:quickrun_config['vim.vspec'] = {
        \ 'exec' : 'PATH=/usr/local/bin:$PATH %c %o',
        \ 'cmdopt' :  '-u NONE -i NONE -N -e -s -S'
        \ . ' %{' . s:SID.'vspec_helper([getcwd(), isdirectory($HOME."/.vim/bundle/vim-vspec-matchers") ? $HOME."/.vim/bundle/vim-vspec-matchers" : ""], expand("%"))}',
        \ 'command' : 'vim',
        \ }
function! s:vspec_helper(paths, target)
    let vspec_path = matchstr(split(&runtimepath, ','), 'vspec')
    let paths  = map([vspec_path] + copy(a:paths)
        \ , '"''".substitute(v:val, "\\", "/", "g")."''"')
    let target = substitute(a:target, "\\", "/", "g")
    let lines =
        \ ['function! s:main()'
        \ , '  let standard_paths = split(&runtimepath, ",")[1:-2]'
        \ , '  let non_standard_paths = [' . join(reverse(paths), ",") . ']'
        \ , '  let all_paths = copy(standard_paths)'
        \ , '  for i in non_standard_paths'
        \ , '    let all_paths = [i] + all_paths + [i . "/after"]'
        \ , '  endfor'
        \ , '  let &runtimepath = join(all_paths, ",")'
        \ , '  1 verbose call vspec#test("' . target . '")'
        \ , '  qall!'
        \ , 'endfunction'
        \ , 'call s:main()']
    let temp = tempname()
    call writefile(lines, temp)
    return temp
endfunction
" }}}

" TweetVim "{{{
nnoremap <silent><Leader>tw :<C-u>TweetVimUserStream<CR>
nnoremap <silent><Leader>th :<C-u>TweetVimHomeTimeline<CR>
nnoremap <silent><Leader>tm :<C-u>TweetVimMentions<CR>
nnoremap <silent><Leader>ts :<C-u>TweetVimSay<CR>
nnoremap <silent><Leader>tu :<C-u>TweetVimUserTimeline<Space>
let s:zenkaku_no_highlight_filetypes += ['tweetvim', 'tweetvim_say']

" TweetVim 読み込み時に設定する
let s:bundle = neobundle#get("TweetVim")
function! s:bundle.hooks.on_source(bundle)
    " TweetVim
    if has('gui_running')
        let g:tweetvim_display_icon = 1
    endif
    let g:tweetvim_tweet_per_page = 60
    let g:tweetvim_async_post = 1
    let g:tweetvim_expand_t_co = 1

    command -nargs=1 TweetVimFavorites call tweetvim#timeline('favorites', <q-args>)

    " 行番号いらない
    AutocmdFT tweetvim     setlocal nonumber
    " マッピング
    " 挿入・通常モードで閉じる
    AutocmdFT tweetvim_say nnoremap <buffer><silent><C-g>    :<C-u>q!<CR>
    AutocmdFT tweetvim_say inoremap <buffer><silent><C-g>    <C-o>:<C-u>q!<CR><Esc>
    " ツイート履歴を <C-l> に
    AutocmdFT tweetvim_say inoremap <buffer><silent><C-l>    <C-o>:<C-u>call unite#sources#tweetvim_tweet_history#start()<CR>
    " <Tab> は補完で使う
    AutocmdFT tweetvim_say iunmap   <buffer><Tab>
    " 各種アクション
    AutocmdFT tweetvim     nnoremap <buffer><Leader>s        :<C-u>TweetVimSay<CR>
    AutocmdFT tweetvim     nmap     <buffer>c                <Plug>(tweetvim_action_in_reply_to)
    AutocmdFT tweetvim     nnoremap <buffer>t                :<C-u>Unite tweetvim -no-start-insert -quick-match<CR>
    AutocmdFT tweetvim     nmap     <buffer><Leader>F        <Plug>(tweetvim_action_remove_favorite)
    AutocmdFT tweetvim     nmap     <buffer><Leader>d        <Plug>(tweetvim_action_remove_status)
    " リロード後はカーソルを画面の中央に
    AutocmdFT tweetvim     nmap     <buffer><Tab>            <Plug>(tweetvim_action_reload)
    AutocmdFT tweetvim     nmap     <buffer><silent>gg       gg<Plug>(tweetvim_action_reload)
    " ページ移動を ff/bb から f/b に
    AutocmdFT tweetvim     nmap     <buffer>f                <Plug>(tweetvim_action_page_next)
    AutocmdFT tweetvim     nmap     <buffer>b                <Plug>(tweetvim_action_page_previous)
    " favstar や web UI で表示
    AutocmdFT tweetvim     nnoremap <buffer><Leader><Leader> :<C-u>call <SID>tweetvim_favstar()<CR>
    AutocmdFT tweetvim     nnoremap <buffer><Leader>u        :<C-u>call <SID>tweetvim_open_home()<CR>
    AutocmdFT tweetvim     nnoremap <buffer><Space><Space>   :<C-u>OpenBrowser https://twitter.com/i/connect<CR>
    " 縦移動
    AutocmdFT tweetvim     nnoremap <buffer><silent>j        :<C-u>call <SID>tweetvim_vertical_move("j")<CR>zz
    AutocmdFT tweetvim     nnoremap <buffer><silent>k        :<C-u>call <SID>tweetvim_vertical_move("k")<CR>zz
    " タイムライン各種
    AutocmdFT tweetvim     nnoremap <silent><buffer>gm       :<C-u>TweetVimMentions<CR>
    AutocmdFT tweetvim     nnoremap <silent><buffer>gh       :<C-u>TweetVimHomeTimeline<CR>
    AutocmdFT tweetvim     nnoremap <silent><buffer>gu       :<C-u>TweetVimUserTimeline<Space>
    AutocmdFT tweetvim     nnoremap <silent><buffer>gp       :<C-u>TweetVimUserTimeline Linda_pp<CR>
    AutocmdFT tweetvim     nnoremap <silent><buffer>gf       :<C-u>call <SID>open_favstar('')<CR>
    " 不要なマップを除去
    AutocmdFT tweetvim     nunmap   <buffer>ff
    AutocmdFT tweetvim     nunmap   <buffer>bb
    " 自動更新
    AutocmdFT tweetvim     nnoremap <buffer><Leader>au :<C-u>TweetVimAutoUpdate<CR>
    AutocmdFT tweetvim     nnoremap <buffer><Leader>as :<C-u>TweetVimStopAutoUpdate<CR>

    " セパレータを飛ばして移動する
    function! s:tweetvim_vertical_move(cmd)
        execute "normal! ".a:cmd
        let end = line('$')
        while getline('.') =~# '^[-~]\+$' && line('.') != end
            execute "normal! ".a:cmd
        endwhile
        " 一番上/下まで来たら次のページに進む
        let line = line('.')
        if line == end
            call feedkeys("\<Plug>(tweetvim_action_page_next)")
        elseif line == 1
            call feedkeys("\<Plug>(tweetvim_action_page_previous)")
        endif
    endfunction

    function! s:tweetvim_favstar()
        let screen_name = matchstr(getline('.'),'^\s\zs\w\+')
        let route = empty(screen_name) ? 'me' : 'users/'.screen_name

        execute "OpenBrowser http://ja.favstar.fm/".route
    endfunction

    function! s:open_favstar(user)
        if empty(a:user)
            OpenBrowser http://ja.favstar.fm/me
        else
            execute "OpenBrowser http://ja.favstar.fm/users/" . a:user
        endif
    endfunction
    command! OpenFavstar call <SID>open_favstar(expand('<cword>'))

    function! s:tweetvim_open_home()
        let username = expand('<cword>')
        if username =~# '^[a-zA-Z0-9_]\+$'
            execute "OpenBrowser https://twitter.com/" . username
        endif
    endfunction

    " 自動更新 {{{
    let s:tweetvim_update_interval_seconds = 60
    let s:tweetvim_timestamp = localtime()
    function! s:tweetvim_autoupdate()
        let current = localtime()
        if current - s:tweetvim_timestamp > s:tweetvim_update_interval_seconds
            call feedkeys("\<Plug>(tweetvim_action_reload)")
            let s:tweetvim_timestamp = current
        endif
        call feedkeys(mode() ==# 'i' ? "\<C-g>\<Esc>" : "g\<Esc>", 'n')
    endfunction

    function! s:tweetvim_setup_autoupdate()
        augroup vimrc-tweetvim-autoupdate
            autocmd!
            autocmd CursorHold * call <SID>tweetvim_autoupdate()
        augroup END
    endfunction
    command! -nargs=0 TweetVimAutoUpdate call <SID>tweetvim_setup_autoupdate()
    command! -nargs=0 TweetVimStopAutoUpdate autocmd! vimrc-tweetvim-autoupdate
    "}}}

    if filereadable($HOME.'/.tweetvimrc')
        source $HOME/.tweetvimrc
    endif

endfunction
unlet s:bundle
"}}}

" RainbowCyclone.vim "{{{
nmap c/ <Plug>(rc_search_forward)
nmap c? <Plug>(rc_search_backward)
nmap c* <Plug>(rc_search_forward_with_cursor)
nmap c# <Plug>(rc_search_backward_with_cursor)
nmap cn <Plug>(rc_search_forward_with_last_pattern)
nmap cN <Plug>(rc_search_backward_with_last_pattern)
nnoremap cr :<C-u>RCReset<CR>
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

" tmpwin.vim {{{
nnoremap <silent><Leader>tt :<C-u>call tmpwin#toggle({'open_post' : ['normal! gg', 'setl nohidden']}, 'TweetVimHomeTimeline')<CR>
"}}}

" submode.vim {{{
let g:submode_keep_leaving_key = 1
" タブ移動
call submode#enter_with('changetab', 'n', '', 'gt', 'gt')
call submode#enter_with('changetab', 'n', '', 'gT', 'gT')
call submode#map('changetab', 'n', '', 't', 'gt')
call submode#map('changetab', 'n', '', 'T', 'gT')
" 時系列 undo/redo
call submode#enter_with('undo/redo', 'n', '', 'g-', 'g-')
call submode#enter_with('undo/redo', 'n', '', 'g+', 'g+')
call submode#map('undo/redo', 'n', '', '-', 'g-')
call submode#map('undo/redo', 'n', '', '+', 'g+')
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
" move to next/previous fold
call submode#enter_with('move-to-fold', 'n', '', 'zj', 'zj')
call submode#enter_with('move-to-fold', 'n', '', 'zk', 'zk')
call submode#map('move-to-fold', 'n', '', 'j', 'zj')
call submode#map('move-to-fold', 'n', '', 'k', 'zk')
" 上下移動
call submode#enter_with('updown-move', 'nv', '', '<C-d>', '<C-d>')
call submode#enter_with('updown-move', 'nv', '', '<C-u>', '<C-u>')
call submode#enter_with('updown-move', 'nv', '', '<C-f>', '<C-f>')
call submode#enter_with('updown-move', 'nv', '', '<C-b>', '<C-b>')
call submode#map('updown-move', 'nv', '', 'd', '<C-d>')
call submode#map('updown-move', 'nv', '', 'u', '<C-u>')
call submode#map('updown-move', 'nv', '', 'f', '<C-f>')
call submode#map('updown-move', 'nv', '', 'b', '<C-b>')
call submode#map('updown-move', 'nv', '', '<C-d>', '<C-d>')
call submode#map('updown-move', 'nv', '', '<C-u>', '<C-u>')
call submode#map('updown-move', 'nv', '', '<C-f>', '<C-f>')
call submode#map('updown-move', 'nv', '', '<C-b>', '<C-b>')
" vim-altr
call submode#enter_with('altr', 'n', 's', 'sa', ':<C-u>call altr#forward()<CR>')
call submode#enter_with('altr', 'n', 's', 'sA', ':<C-u>call altr#back()<CR>')
call submode#map('altr', 'n', 'r', 'a', 'sa')
call submode#map('altr', 'n', 'r', 'A', 'sA')
" }}}

" vim-altr {{{
nnoremap <silent><C-w>a :<C-u>call altr#forward()<CR>
nnoremap <silent><C-w>A :<C-u>call altr#back()<CR>

let s:bundle = neobundle#get("vim-altr")
function! s:bundle.hooks.on_source(bundle)
    " for vimrc
    if has('mac')
        call altr#define('.vimrc', '.gvimrc', '.mac.vimrc', '.mac.gvimrc')
    elseif has('win32') || has('win64')
        call altr#define('_vimrc', '_gvimrc')
    elseif has('unix')
        call altr#define('.vimrc', '.gvimrc', '.linux.vimrc', '.linux.gvimrc')
    endif
    call altr#define('dotfiles/vimrc', 'dotfiles/gvimrc',
                \    'dotfiles/mac.vimrc', 'dotfiles/mac.gvimrc',
                \    'dotfiles/linux.vimrc', 'dotfiles/linux.gvimrc')
    " ruby TDD
    call altr#define('%.rb', 'spec/%_spec.rb')
    " Rails TDD
    call altr#define('app/models/%.rb', 'spec/models/%_spec.rb', 'spec/factories/%s.rb')
    call altr#define('app/controllers/%.rb', 'spec/controllers/%_spec.rb')
    call altr#define('app/helpers/%.rb', 'spec/helpers/%_spec.rb')
endfunction
unlet s:bundle
" }}}

" vim-airline "{{{
if ! has('gui_running')
    let g:airline_theme = 'wombat'
endif
let g:airline#extensions#whitespace#enabled = 0
"}}}

" previm {{{
AutocmdFT markdown nnoremap <buffer><Leader>p :<C-u>PrevimOpen<CR>
Autocmd BufWritePost *.md,*.markdown call previm#refresh()
let g:previm_enable_realtime = 0
"}}}

" memolist.vim "{{{
nnoremap <Leader>mn :<C-u>MemoNew<CR>
nnoremap <silent><Leader>ml :<C-u>call <SID>memolist()<CR>
nnoremap <Leader>mg :<C-u>execute 'Unite' 'grep:'.g:memolist_path '-auto-preview'<CR>

if isdirectory(expand('~/Dropbox/memo'))
    let g:memolist_path = expand('~/Dropbox/memo')
else
    if isdirectory(expand('~/.vim/memo'))
        call mkdir(expand('~/.vim/memo'), 'p')
    endif
    let g:memolist_path = expand('~/.vim/memo')
endif

let g:memolist_memo_suffix = 'md'
let g:memolist_unite = 1
let g:memolist_unite_option = '-auto-preview -no-start-insert'

function! s:memolist()
    " delete swap files because they make unite auto preview hung up
    for swap in glob(g:memolist_path.'/.*.sw?', 1, 1)
        if swap !~# '^\.\+$' && filereadable(swap)
            call delete(swap)
        endif
    endfor

    MemoList
endfunction
"}}}

" vim-numberstar {{{
nnoremap <silent><expr>*  numberstar#key('*')
nnoremap <silent><expr>#  numberstar#key('#')
nnoremap <silent><expr>g* numberstar#key('g*')
nnoremap <silent><expr>#* numberstar#key('#*')
" }}}

" migemo-search.vim {{{
if executable('cmigemo')
    cnoremap <expr><CR> getcmdtype() =~# '^[/?]$' ? migemosearch#replace_search_word()."\<CR>zv" : "\<CR>"
endif
"}}}

" vim-fugitive {{{
nnoremap <Leader>gs :<C-u>Gstatus<CR>
nnoremap <Leader>gC :<C-u>Gcommit -v<CR>
function! s:fugitive_commit()
    ZoomWin
    Gcommit -v
    silent only
    if getline('.') == ''
        startinsert
    endif
endfunction
nnoremap <Leader>gc :<C-u>call <SID>fugitive_commit()<CR>
nnoremap <Leader>gl :<C-u>QuickRun sh -src 'git log --graph --oneline'<CR>
nnoremap <Leader>ga :<C-u>Gwrite<CR>
nnoremap <Leader>gd :<C-u>Gdiff<CR>
nnoremap <Leader>gb :<C-u>Gblame<CR>

let s:bundle = neobundle#get("vim-fugitive")
function! s:bundle.hooks.on_post_source(bundle)
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
map : <Plug>(easymotion-s2)
" }}}

" ぷよ.vim {{{
let g:puyo#updatetime = 500
"}}}

" wandbox-vim {{{
let g:wandbox#echo_command = 'echomsg'
let g:wandbox#default_compiler = get(g:, 'wandbox#default_compiler', {'cpp' : 'gcc-head,clang-head', 'ruby' : 'mruby'})
noremap <Leader>wb :<C-u>Wandbox<CR>
"}}}

" vim-signify "{{{
let g:signify_vcs_list = ['git', 'svn']
let g:signify_update_on_bufenter = 0
let g:signify_update_on_focusgained = 0
let g:signify_cursorhold_normal = 0
let g:signify_cursorhold_insert = 0
"}}}

" tern_for_vim {{{
let s:hooks = neobundle#get_hooks('tern_for_vim')
function! s:hooks.on_source(bundle)
    call s:setup_tern()
endfunction
unlet s:hooks
function! s:setup_tern()
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

" calendar.vim {{{
let g:calendar_google_calendar = 1
let g:calendar_date_endian = 'big'
let g:calendar_first_day = 'sun_day'

" カーソルライン表示設定を打ち消す
AutocmdFT puyo,calendar Autocmd CursorHold,CursorHoldI,WinEnter <buffer> setlocal nocursorline

AutocmdFT calendar nmap <buffer>l w
AutocmdFT calendar nmap <buffer>h b

nnoremap <silent><Leader>cw :<C-u>Calendar -view=week -split=horizontal -height=18<CR>

if ! has('gui_running')
    let g:calendar_frame = 'default'
endif
" }}}

" IndentGuide {{{
let s:bundle = neobundle#get("vim-indent-guides")
function! s:bundle.hooks.on_post_source(bundle)
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

function! s:jedi_settings()
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

" clang-type-inspector.vim {{{
AutocmdFT cpp nmap <Leader>t <Plug>(clang-inspect-type-at-cursor)
let g:clang_type_inspector#automatic_inspection = 0
" }}}

" committia.vim {{{
let g:committia_hooks = {}
function! g:committia_hooks.edit_open(info)
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
func s:show_on_web(...)
    let after_post = g:gist_open_browser_after_post
    let g:gist_open_browser_after_post = 0
    if a:0 == 1
        let color = g:colors_name
        execute 'colorscheme' a:1
    end

    try
        noautocmd TOhtml
        Gist -a -c

        let url = getreg('*')
        if stridx(url, 'https://gist.github.com') != 0
            throw "URL is not copied"
        endif
        let raw_url = substitute(url, 'gist\.github\.com', 'rawgit.com/anonymous', '') . '/raw/' . expand('%')
        bdelete!

        execute 'OpenBrowser' raw_url

    finally
        if exists('color')
            execute 'colorscheme' color
        endif
        let g:gist_open_browser_after_post = after_post
    endtry
endfunc
command! -nargs=? ShowOnWeb call <SID>show_on_web(<f-args>)
" }}}

" プラットフォーム依存な設定をロードする "{{{
function! SourceIfExist(path)
    if filereadable(a:path)
        execute 'source' a:path
    endif
endfunction

if has('mac')
    call SourceIfExist($HOME."/.mac.vimrc")
elseif has('unix')
    call SourceIfExist($HOME.'/.linux.vimrc')
elseif has('win32') || has('win64')
    call SourceIfExist($HOME.'/_windows.vimrc')
endif

call SourceIfExist($HOME.'/.local.vimrc')
"}}}

" vim: set ft=vim fdm=marker ff=unix fileencoding=utf-8:
