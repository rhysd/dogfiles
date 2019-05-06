scriptencoding utf-8

" 必須な基本設定

let s:on_nyaovim = exists('g:nyaovim_version')

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
Autocmd VimEnter,WinEnter init.vim,nvimrc syn keyword myVimAutocmd Autocmd AutocmdFT contained containedin=vimIsCommand
Autocmd ColorScheme * highlight def link myVimAutocmd vimAutoCmd

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
"バックスペースでなんでも消せるように
set backspace=indent,eol,start
" 改行時にコメントしない
set formatoptions-=r
set formatoptions-=o
" 8進数インクリメントをオフにする
set nrformats-=octal
"ファイル切替時にファイルを隠す
set hidden
"日本語ヘルプを優先的に検索
set helplang=ja,en
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
set noswapfile
" 編集履歴を保存して終了する
if !isdirectory($HOME . '/.nvim/undo')
    call mkdir($HOME . '/.nvim/undo', 'p')
endif
set undodir=~/.nvim/undo
set undofile
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
set breakindent
" 拡張補完メニュー
set wildmenu
set wildoptions+=pum

" 一定時間カーソルを移動しないとカーソルラインを表示（ただし，ウィンドウ移動時
" はなぜか切り替わらない
" http://d.hatena.ne.jp/thinca/20090530/1243615055
Autocmd CursorMoved,CursorMovedI,WinLeave * setlocal nocursorline
Autocmd CursorHold,CursorHoldI,WinEnter * setlocal cursorline

" git config file
Autocmd BufRead,BufNew,BufNewFile gitconfig setlocal ft=gitconfig
" Ruby の guard 用ファイル
Autocmd BufRead,BufNew,BufNewFile Guardfile setlocal ft=ruby

" カーソル位置の復元
Autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
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
            silent! call system('chmod a+x ' . shellescape(file))
        endif
    endfunction
endif

augroup InitialMessage
    autocmd!
    " 起動時メッセージ．ｲﾇｩ…
    autocmd VimEnter * echo "(U^w^) enjoy nvimming!"
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
    let target_filetype = ['ref', 'unite', 'vimfiler']
    let target_buftype  = ['help', 'quickfix', 'terminal', 'nofile']
    let bufnr = winbufnr(a:winnr)
    return index(target_filetype, getbufvar(bufnr, '&filetype')) >= 0 ||
                \ index(target_buftype, getbufvar(bufnr, '&buftype')) >= 0
endfunction

nnoremap <silent><C-q> :<C-u>call <SID>close_windows_like('s:is_target_window(winnr)')<CR>
"}}}

" エンコーディング指定オープン
command! -bang -complete=file -nargs=? Utf8 edit<bang> ++enc=utf-8 <args>
command! -bang -complete=file -nargs=? Sjis edit<bang> ++enc=cp932 <args>
command! -bang -complete=file -nargs=? Euc edit<bang> ++enc=eucjp <args>

" 縦幅と横幅を見て help の開き方を決める
command! -nargs=* -complete=help Help call <SID>smart_help(<q-args>)
set keywordprg=:Help
nnoremap <silent><Leader>h :<C-u>Help<Space><C-l>
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

command! -nargs=0 Nvimrc call <SID>edit_config()
function! s:edit_config() abort
    let argv = printf('%s %s ', $MYVIMRC, $MYGVIMRC)
    let nyaovimrc = expand('~/.config/nyaovim/nyaovimrc.html')
    if filereadable(nyaovimrc)
        let argv .= nyaovimrc
    endif
    execute 'args' argv
endfunction

" ; と : をスワップ
noremap : ;
noremap ; :
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
noremap <expr><Tab> v:count !=0 ? "G" : "\<Tab>zvzz"
" タブで補完候補に移動
inoremap <silent><expr><Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" コマンドラインウィンドウ
" 検索後画面の中心に。
nnoremap n nzvzz
nnoremap N Nzvzz
nnoremap * *zvzz
nnoremap # *zvzz
" 検索で / をエスケープしなくて良くする（素の / を入力したくなったら<C-v>/）
cnoremap <expr>/ getcmdtype() == '/' <Bar><Bar> getcmdtype() == '?' ? '\/' : '/'
" 空行挿入
function! s:cmd_cr_n(count)
    for _ in range(a:count)
        call append('.', '')
    endfor
    execute 'normal!' a:count.'j'
endfunction
nnoremap <silent><CR> :<C-u>call <SID>cmd_cr_n(v:count1)<CR>
"Emacsライクなバインディング．ポップアップが出ないように移動．
inoremap <C-e> <END>
cnoremap <C-e> <END>
inoremap <C-a> <HOME>
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
function! s:delete_current_buf()
    let bufnr = bufnr('%')
    bnext
    if bufnr == bufnr('%') | enew | endif
    silent! bdelete! #
endfunction
nnoremap <C-w>d :<C-u>call <SID>delete_current_buf()<CR>
"インサートモードで次の行に直接改行
inoremap <C-j> <Esc>o
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
" クリップボードから貼り付け
inoremap <C-r>+ <C-o>:set paste<CR><C-r>+<C-o>:set nopaste<CR>
" コンマ後には空白を入れる
inoremap , ,<Space>
" 賢く行頭・非空白行頭・行末の移動
nnoremap M g^
nnoremap H g0
nnoremap L g$
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
nnoremap <C-w>*  <C-w>s*
nnoremap <C-w>#  <C-w>s#
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
" 畳み込みを開く
nnoremap <expr>h col('.') == 1 && foldlevel(line('.')) > 0 ? 'zc' : 'h'
nnoremap <expr>l foldclosed(line('.')) != -1 ? 'zo' : 'l'
" colorcolumn
nnoremap <expr><Leader>cl ":\<C-u>set colorcolumn=".(&cc == 0 ? v:count == 0 ? col('.') : v:count : 0)."\<CR>"

" ;; -> ::
function! s:double_semi() abort
    if getline('.')[col('.')-2] ==# ';'
        return "\<BS>::"
    endif
    return ';'
endfunction
AutocmdFT cpp,rust inoremap <silent><buffer><expr>; <SID>double_semi()

function! s:start_term(args) abort
    if exists('s:term_win')
        let winnr = win_id2win(s:term_win)
        if winnr > 0
            execute winnr . 'wincmd w'
            let job_id = &channel
            if job_id != 0 && a:args !=# ''
                call jobsend(job_id, [a:args])
            endif
            startinsert
            return
        endif
    endif

    " 2 means height of status line
    let s:term_win = nvim_open_win(bufnr('%'), v:true, {
                \   'relative': 'editor',
                \   'row': 0,
                \   'col': 0,
                \   'width': &columns,
                \   'height': &lines - 2,
                \ })

    if exists('s:term_bufnr') && bufexists(s:term_bufnr)
        execute 'buffer' s:term_bufnr
        if a:args !=# ''
            call jobsend(getbufvar(s:term_bufnr, '&channel'), [a:args])
        endif
        startinsert
        return
    endif

    hi link NormalFloat Normal

    execute 'terminal' a:args
    nnoremap <buffer>q :<C-u>quit<CR>
    startinsert
    let s:term_bufnr = bufnr('%')
endfunction
nnoremap <Leader>t :<C-u>call <SID>start_term('')<CR>
command! -nargs=* -complete=shellcmd T call <SID>start_term(<q-args>)
" leave from terminal mode
tnoremap <Esc><Esc> <C-\><C-n>

function! s:close_zoom_win() abort
    autocmd! zoom-win-leave
    if !exists('s:zoom_win_id')
        return
    endif
    let winnr = win_id2win(s:zoom_win_id)
    if winnr != 0
        execute winnr . 'wincmd c'
    endif
    unlet! s:zoom_win_id
    echo 'Zoom out'
endfunction
function! s:on_zoom_bufenter(bufnr) abort
    autocmd! zoom-win-after-leave
    if bufnr('%') != a:bufnr
        execute 'buffer' a:bufnr
    endif
endfunction
function! s:on_zoom_bufleave(bufnr) abort
    call s:close_zoom_win()
    augroup zoom-win-after-leave
        execute 'autocmd BufEnter * call <SID>on_zoom_bufenter(' . a:bufnr . ')'
    augroup END
endfunction
function! s:toggle_zoom_win(bufnr) abort
    if exists('s:zoom_win_id')
        call s:close_zoom_win()
    else
        let s:zoom_win_id = nvim_open_win(a:bufnr, v:true, {
                \   'relative': 'editor',
                \   'row': 0,
                \   'col': 0,
                \   'width': &columns,
                \   'height': &lines - 2,
                \ })
        setlocal bufhidden=hide
        augroup zoom-win-leave
            execute 'autocmd BufLeave <buffer> call <SID>on_zoom_bufleave(' . a:bufnr . ')'
            autocmd WinLeave <buffer> call <SID>close_zoom_win()
        augroup END
        echo 'Zoom in'
    endif
endfunction
command! -nargs=0 -bar ZoomWin call <SID>toggle_zoom_win(bufnr('%'))
nnoremap <C-w>o :<C-u>ZoomWin<CR>

" help のマッピング
function! s:on_FileType_help_define_mappings() abort
    if &l:readonly
        " カーソル下のタグへ飛ぶ
        nnoremap <buffer>J <C-]>
        " 戻る
        nnoremap <buffer>K <C-t>
        " リンクしている単語を選択する
        nnoremap <buffer><silent><Tab> /\%(\_.\zs<Bar>[^ ]\+<Bar>\ze\_.\<Bar>CTRL-.\<Bar><[^ >]\+>\)<CR>
        " その他
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
function! s:on_filetype_qf() abort
    nnoremap <buffer><silent> q :<C-u>cclose<CR>
    nnoremap <buffer><silent> j :<C-u>cnext<CR>:copen<CR>
    nnoremap <buffer><silent> k :<C-u>cprevious<CR>:copen<CR>
    nnoremap <buffer><silent> J :<C-u>cnfile<CR>:copen<CR>
    nnoremap <buffer><silent> K :<C-u>cpfile<CR>:copen<CR>
    nnoremap <buffer><silent> l :<C-u>clist<CR>
    nnoremap <buffer><CR> <CR>
endfunction
AutocmdFT qf call s:on_filetype_qf()

" Git
function! s:git(cmdline) abort
    let dir = expand('%:p:h')
    if dir ==# ''
        let dir = getcwd()
    endif
    execute 'terminal' 'VIMRUNTIME= git -C' dir a:cmdline
    let bufnr = bufnr('%')
    let close_buf = printf('silent %d bdelete! | echo "Done: `git %s`"', bufnr, a:cmdline)
    execute 'autocmd TermClose <buffer> if jobwait([&channel], 0)[0] == 0 | silent' close_buf '| endif'
endfunction
command! -nargs=* GitAdd call <SID>git('add %:p ' . <q-args>)
command! -nargs=* GitCommit call <SID>git('commit ' . <q-args>)
nnoremap <silent><Leader>ga :<C-u>GitAdd<CR>
nnoremap <silent><Leader>gc :<C-u>GitCommit<CR>

" ファイルタイプごとの設定
function! s:python_settings() abort
    syntax keyword Constant self
endfunction
AutocmdFT python call <SID>python_settings()

" dein.vim
function! s:install_dein() abort
    echo 'Installing dein.vim...'
    let cmd =
        \ 'curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh && ' .
        \ '(sh ./installer.sh ~/.cache/dein || rm installer.sh)'
    let out = system(cmd)
    if v:shell_error
        echohl ErrorMsg | echom 'Error!: ' . out | echohl None
    else
        echo 'dein.vim was installed to ~/.cache/dein'
    endif
endfunction
let s:dein_repo_path = expand('~/.cache/dein/repos/github.com/Shougo/dein.vim')
if !isdirectory(s:dein_repo_path)
    call s:install_dein()
endif
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

let s:dein_cache_dir = expand('~/.cache/dein')
if dein#load_state(s:dein_cache_dir)
    call dein#begin(s:dein_cache_dir)

    call dein#add(s:dein_repo_path)
    call dein#add('rhysd/wallaby.vim')
    call dein#add('rhysd/vim-color-spring-night')
    call dein#add('airblade/vim-gitgutter')
    call dein#add('vim-airline/vim-airline')
    call dein#add('vim-airline/vim-airline-themes')
    call dein#add('keith/tmux.vim')
    call dein#add('leafgarland/typescript-vim')
    call dein#add('w0rp/ale')

    call dein#add('kana/vim-textobj-user', {
                \   'lazy': 1,
                \ })
    call dein#add('rhysd/vim-textobj-anyblock', {
                \   'depends' : 'vim-textobj-user',
                \   'lazy': 1,
                \   'on_map' : [['xo', 'ab'], ['xo', 'ib']],
                \ })
    call dein#add('kana/vim-textobj-indent', {
                \   'depends' : 'vim-textobj-user',
                \   'lazy': 1,
                \   'on_map' : [['xo', 'ai'], ['xo', 'aI'], ['xo', 'ii'], ['xo', 'iI']],
                \ })
    call dein#add('sgur/vim-textobj-parameter', {
                \   'depends' : 'vim-textobj-user',
                \   'lazy': 1,
                \   'on_map' : [['xo', 'a,'], ['xo', 'i,']],
                \ })
    call dein#add('kana/vim-textobj-entire', {
                \   'depends' : 'vim-textobj-user',
                \   'lazy' : 1,
                \   'on_map' : [['xo', 'ae'], ['xo', 'ie']],
                \ })
    call dein#add('rhysd/clever-f.vim', {
                \   'lazy': 1,
                \   'on_map' : [['nv', 'f'], ['nv', 'F'], ['nv', 't'], ['nv', 'T']],
                \ })
    call dein#add('thinca/vim-quickrun', {
                \   'lazy' : 1,
                \   'on_cmd' : 'QuickRun',
                \   'on_map' : '<Plug>(quickrun-',
                \ })
    call dein#add('tyru/open-browser.vim', {
                \   'lazy' : 1,
                \   'on_cmd' : ['OpenBrowser', 'OpenBrowserSearch', 'OpenBrowserSmartSearch'],
                \   'on_map' : '<Plug>(openbrowser-',
                \ })
    call dein#add('tyru/open-browser-github.vim', {
                \   'lazy' : 1,
                \   'on_cmd' : ['OpenGithubFile', 'OpenGithubIssue', 'OpenGithubPullReq'],
                \   'depends' : 'open-browser.vim',
                \ })
    call dein#add('easymotion/vim-easymotion', {
                \   'lazy' : 1,
                \   'on_map' : '<Plug>(easymotion-',
                \ })
    call dein#add('rhysd/vim-notes-cli', {
                \   'lazy' : 1,
                \   'on_cmd' : ['Notes', 'NotesSelect', 'NotesNew', 'NotesList', 'NotesGrep'],
                \ })
    call dein#add('rhysd/git-messenger.vim', {
                \   'lazy' : 1,
                \   'on_cmd' : 'GitMessenger',
                \   'on_map' : '<Plug>(git-messenger',
                \ })
    call dein#add('kana/vim-operator-user', {
                \   'lazy' : 1,
                \ })
    call dein#add('kana/vim-operator-replace', {
                \   'lazy' : 1,
                \   'depends' : 'vim-operator-user',
                \   'on_map' : '<Plug>(operator-replace)',
                \ })
    call dein#add('rhysd/vim-operator-surround', {
                \   'lazy' : 1,
                \   'depends' : 'vim-operator-user',
                \   'on_map' : '<Plug>(operator-surround-'
                \ })
    call dein#add('justinmk/vim-dirvish', {
                \   'lazy' : 1,
                \   'on_func' : 'dirvish#open',
                \   'on_cmd' : 'Dirvish',
                \ })
    call dein#add('tyru/caw.vim', {
                \   'lazy' : 1,
                \   'depends' : 'vim-operator-user',
                \   'on_map' : '<Plug>(caw:',
                \ })

    " Completion
    call dein#add('Shougo/deoplete.nvim')
    call dein#add('autozimu/LanguageClient-neovim', {'build' : 'bash install.sh'})

    " call dein#local("~/.vim/bundle", {}, [])

    if s:on_nyaovim
        let s:opts = {}
    else
        let s:opts = { 'rtp' : '' }
    endif
    call dein#add('rhysd/nyaovim-popup-tooltip', s:opts)
    call dein#add('rhysd/nyaovim-mini-browser', s:opts)
    call dein#add('rhysd/nyaovim-markdown-preview', s:opts)
    call dein#add('rhysd/nyaovim-tree-view', s:opts)
    unlet s:opts

    call dein#end()
    call dein#save_state()

    if dein#check_install()
        call dein#install()
    endif
endif
filetype plugin indent on

" カラースキーム
" シンタックスハイライト
syntax enable
let s:true_color_enabled = $TERM_PROGRAM ==# 'iTerm.app'
if s:true_color_enabled
    set termguicolors
endif
try
    if s:on_nyaovim || s:true_color_enabled
        colorscheme spring-night
        let g:airline_theme = 'spring_night'
    else
        colorscheme wallaby
        let g:airline_theme = 'wombat'
    endif
catch
    set background=dark
    colorscheme default
endtry

let g:clever_f_smart_case = 1
let g:clever_f_across_no_line = 1
let g:clever_f_use_migemo = 1

let g:quickrun_no_default_key_mappings = 1
" quickrun_configの初期化
let g:quickrun_config = get(g:, 'quickrun_config', {})
"QuickRun 結果の開き方
let g:quickrun_config._ = {
            \ 'outputter' : 'quickfix',
            \ 'split' : 'rightbelow 10sp',
            \ 'open_cmd' : 'copen',
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
let g:quickrun_config['dachs'] = {
            \ 'command' : './bin/dachs',
            \ }
let g:quickrun_config['dachs/llvm'] = {
            \ 'type' : 'dachs',
            \ 'cmdopt' : '--emit-llvm',
            \ }
" プリプロセスのみ
let g:quickrun_config['cpp/preprocess/g++'] = { 'type' : 'cpp/g++', 'exec' : '%c -P -E %s' }
let g:quickrun_config['cpp/preprocess/clang++'] = { 'type' : 'cpp/clang++', 'exec' : '%c -P -E %s' }
let g:quickrun_config['cpp/preprocess'] = { 'type' : 'cpp', 'exec' : '%c -P -E %s' }
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
" LLVM
let g:quickrun_config['llvm'] = {
            \   'exec' : 'llvm-as %s:p -o=- | lli - %a',
            \ }

" QuickRunのキーマップ
nnoremap <Leader>q  <Nop>
nnoremap <silent><Leader>qr :<C-u>QuickRun<CR>
vnoremap <silent><Leader>qr :QuickRun<CR>
nnoremap <silent><Leader>qR :<C-u>QuickRun<Space>
AutocmdFT cpp nnoremap <silent><buffer><Leader>qc :<C-u>QuickRun -type cpp/clang<CR>

" open-browser.vim
nnoremap <Leader>O :<C-u>OpenGithubFile<CR>
vnoremap <Leader>O :OpenGithubFile<CR>
if s:on_nyaovim
    nnoremap <Leader>o :<C-u>MiniBrowser <C-r><C-p><CR>
    xnoremap <Leader>o y:<C-u>MiniBrowser <C-r>+<CR>
else
    nmap <Leader>o <Plug>(openbrowser-smart-search)
    xmap <Leader>o <Plug>(openbrowser-smart-search)
endif

" GitGutter
let g:gitgutter_map_keys = 0
let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0
nnoremap <Leader>gg :<C-u>GitGutterLineHighlightsToggle<CR>
nnoremap <Leader>gs :<C-u>GitGutterStageHunk<CR>
nnoremap <Leader>gr :<C-u>GitGutterRevertHunk<CR>
nnoremap <Leader>gp :<C-u>GitGutterPreviewHunk<CR>
nnoremap <Leader>g] :<C-u>GitGutterNextHunk<CR>
nnoremap <Leader>g[ :<C-u>GitGutterPrevHunk<CR>
nnoremap <Leader>gh :<C-u>GitGutterStageHunk<CR>
omap ih <Plug>GitGutterTextObjectInnerPending
omap ah <Plug>GitGutterTextObjectOuterPending
xmap ih <Plug>GitGutterTextObjectInnerVisual
xmap ah <Plug>GitGutterTextObjectOuterVisual

" EasyMotion
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
map : <Plug>(easymotion-overwin-f2)

" airline
let g:airline_left_sep = '»'
let g:airline_right_sep = '«'
let g:airline_extensions = []

" ALE
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
if executable('/usr/local/opt/llvm/bin/llc')
    let g:ale_llvm_llc_executable = '/usr/local/opt/llvm/bin/llc'
endif

" git-messenger
let g:git_messenger_no_default_mappings = 1
nmap <C-w>m <Plug>(git-messenger)
" Header such as 'Commit:', 'Author:'
hi link gitmessengerHeader Identifier
" Commit hash at 'Commit:' header
hi link gitmessengerHash Comment
" History number at 'History:' header
hi link gitmessengerHistory Constant
" Normal color. This color is the most important
hi link gitmessengerPopupNormal CursorLine
" Color of 'end of buffer'. To hide '~' in popup window, I recommend to use the same background
" color as gitmessengerPopupNormal.
hi gitmessengerEndOfBuffer term=None guifg=None guibg=None ctermfg=None ctermbg=None

" operator-replace
map <Leader>r <Plug>(operator-replace)

" operator-surround
map <silent>gy <Plug>(operator-surround-append)
map <silent>gd <Plug>(operator-surround-delete)
map <silent>gc <Plug>(operator-surround-replace)

" dirvish
let g:loaded_netrwPlugin = 1
" Shows all files in the order returned by glob()
let g:dirvish_mode = 2
function! s:on_dirvish() abort
    nnoremap <buffer><silent>l :<C-u>.call dirvish#open('edit', 0)<CR>
    nmap <buffer><silent>h <Plug>(dirvish_up)
    nnoremap <buffer><silent>O :<C-u>execute 'OpenBrowser' getline('.')<CR>
    nnoremap <buffer>~ :<C-u>Dirvish ~<CR>
endfunction
AutocmdFT dirvish call <SID>on_dirvish()
nnoremap <silent><Leader><Leader> :<C-u>execute 'Dirvish' expand('%:p:h')<CR>

" deoplete
let g:deoplete#enable_at_startup = 1

" LanguageClient-neovim
let g:LanguageClient_serverCommands = {
    \   'rust': ['rls'],
    \   'python': ['pyls'],
    \   'javascript': ['javascript-typescript-stdio'],
    \   'typescript': ['javascript-typescript-stdio'],
    \ }

function! s:lc_setup() abort
    command! -buffer Lookup call LanguageClient#textDocument_hover()
    command! -buffer GoToDef call LanguageClient#textDocument_definition()
    command! -buffer GoToTypedef call LanguageClient#textDocument_typeDefinition()
    command! -buffer GoToImpl call LanguageClient#textDocument_implementation()
    command! -buffer Rename call LanguageClient#textDocument_rename()

    nnoremap <buffer><Leader>ll :<C-u>Lookup<CR>
    nnoremap <buffer><Leader>ld :<C-u>GoToDef<CR>
    nnoremap <buffer><Leader>lt :<C-u>GoToTypedef<CR>
    nnoremap <buffer><Leader>li :<C-u>GoToImpl<CR>
    nnoremap <buffer><Leader>lr :<C-u>Rename<CR>

    nnoremap <buffer><silent>K :<C-u>Lookup<CR>
    nnoremap <buffer><silent>gd :<C-u>GoToDef<CR>
endfunction
AutocmdFT * if has_key(g:LanguageClient_serverCommands, &filetype) | call <SID>lc_setup() | endif

" caw.vim
let g:caw_no_default_keymappings = 1
" 行コメント
nmap <Leader>cc <Plug>(caw:hatpos:toggle)
xmap <Leader>cc <Plug>(caw:hatpos:toggle:operator)
" ブロックコメント
map <Leader>cb <Plug>(caw:wrap:toggle:operator)

if s:on_nyaovim
    " nyaovim-mini-browser
    function! s:devdocs(query) abort
        if a:query ==# ''
            let cword = expand('<cword>')
            if cword ==# ''
                MiniBrowser http://devdocs.io/
            else
                execute 'MiniBrowser' 'http://devdocs.io/#q='.escape(cword, ' \')
            endif
            return
        endif

        execute 'MiniBrowser' 'http://devdocs.io/#q='.escape(a:query, ' \')
    endfunction
    command! -nargs=* DevDocs call <SID>devdocs(<q-args>)
endif
