" Base settings {{{

"エンコーディング
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,euc-jp,cp932
" This is vim, not vi.
set nocompatible
" user-defined prefix
let mapleader = ','
" シンタックスハイライト
syntax enable
"行番号表示
set number
"バックアップファイルいらない
set nobackup
" 言語設定
language message C
language time C
"自動インデント
set autoindent
"タブが対応する空白の数
set tabstop=2 shiftwidth=2 softtabstop=2
"タブの代わりにスペースを使う
set expandtab
"長い行で折り返す
set wrap
"検索が末尾まで進んだら，ファイル先頭につなげる
set wrapscan
"対応する括弧にわずかの間ジャンプする
set showmatch
"カーソルが何行何列目にあるか表示する
set ruler
"最下ウィンドウにステータス行が表示される時
"1: ウィンドウの数が2以上 2:常
set laststatus=2
"モードライン無効化
set modelines=0
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
"256 bitカラーモード
" set t_Co=256
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
"コマンドラインでのIM無効化
set noimcmdline
"バックスペースでなんでも消せるように
set backspace=indent,eol,start
" 改行時にコメントしない
set formatoptions-=ro
" 行継続で勝手にインデントしない
" let g:vim_indent_cont = 0
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
set fileformats=unix,mac,dos
"行を折り返さない
set textwidth=0
"コマンド表示
set showcmd
"コマンド実行中は再描画しない
set lazyredraw
"高速ターミナル接続を行う
set ttyfast
" 自前で用意したものへの path
set path=.,/usr/include,/usr/local/include
" 補完でプレビューウィンドウを開かない
set completeopt=longest,menu
" foldingの設定
set foldenable
set foldmethod=marker
" C++ ラベル字下げ設定
set cinoptions& cinoptions+=:0,g0
" マルチバイト文字があってもカーソルがずれないようにする
set ambiwidth=double
" 編集履歴を保存して終了する
if has('persistent_undo')
    set undodir=~/.vim/undo
    set undofile
endif
" command-line-window の縦幅
    " set cmdwinheight=14
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
set ruf=%45(%12f%=\ %m%{'['.(&fenc!=''?&fenc:&enc).']'}\ %l-%v\ %p%%\ [%02B]%)
set statusline=%f:\ %{substitute(getcwd(),'.*/','','')}\ %m%=%{(&fenc!=''?&fenc:&enc).':'.strpart(&ff,0,1)}\ %l-%v\ %p%%\ %02B
" 一定時間カーソルを移動しないとカーソルラインを表示（ただし，ウィンドウ移動時
" はなぜか切り替わらない
" http://d.hatena.ne.jp/thinca/20090530/1243615055
augroup AutoCursorLine
  autocmd!
  autocmd CursorMoved,CursorMovedI,WinLeave * setlocal nocursorline
  autocmd CursorHold,CursorHoldI,WinEnter * setlocal cursorline
augroup END

augroup Misc
    autocmd!
    " 起動時メッセージ．ｲﾇｩ…
    autocmd VimEnter * echo "(U＾ω＾) enjoy vimming!"
    " *.md で読み込む filetype を変更（デフォルトは modula2）
    autocmd BufRead *.md,*.markdown setlocal ft=markdown
    " Gnuplot のファイルタイプを設定
    autocmd BufRead *.plt,*.plot,*.gnuplot setlocal ft=gnuplot
    " カーソル位置の復元
    autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
    " Hack #202: 自動的にディレクトリを作成する
    " http://vim-users.jp/2011/02/hack202/
    autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
    function! s:auto_mkdir(dir, force)
        if !isdirectory(a:dir) && (a:force ||
                    \    input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
            " call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
            call mkdir(a:dir, 'p')
        endif
    endfunction
augroup END

" カーソル下のハイライトグループを取得
" command! -nargs=0 GetHighlightingGroup echo 'hi<' . synIDattr(synID(line('.'),col('.'),1),'name') . '> trans<' . synIDattr(synID(line('.'),col('.'),0),'name') . '> lo<' . synIDattr(synIDtrans(synID(line('.'),col('.'),1)),'name') . '>'

" 基本マッピング {{{
" ; と : をスワップ
noremap ; :
noremap : ;
"insertモードから抜ける
inoremap jj <Esc>
" <C-c> も Esc と抜け方にする
inoremap <C-C> <Esc>
" Yの挙動はy$のほうが自然な気がする
nnoremap Y y$
" 縦方向は論理移動する
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
"Esc->Escで検索結果とエラーハイライトをクリア
nnoremap <silent><Esc><Esc> :<C-u>nohlsearch<CR>
"{数値}<Tab>でその行へ移動．それ以外だと通常の<Tab>の動きに
nnoremap <expr><Tab> v:count !=0 ? "G" : "\<Tab>zvzz"
"行頭・行末の移動
nnoremap 0 ^
vnoremap 0 ^
nnoremap ^ 0
vnoremap ^ 0
nnoremap - $
vnoremap - $
" コマンドラインウィンドウ
nnoremap q; q:
" q 誤爆しやすい
nnoremap q <Nop>
nnoremap qq q
" 検索後画面の中心に。
nnoremap n nzvzz
nnoremap N Nzvzz
nnoremap * *zvzz
nnoremap # *zvzz
" insertモードでもquit
inoremap <C-q><C-q> <Esc>:wq<CR>
" insertモードでもcmdmode
inoremap <C-:> <Esc>:
" Q で終了
nnoremap <C-q> :<C-u>q<CR>
" 空行挿入
nnoremap <silent><CR> :<C-u>call append(expand('.'), '')<CR>j
"ヘルプ表示
nnoremap <Leader>h :vert to help<Space>
" スペースを挿入
nnoremap <C-Space> i<Space><Esc><Right>
"insertモード時はEmacsライクなバインディング．ポップアップが出ないように移動．
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
cnoremap <C-d> <Del>
" Emacsライク<C-k> http//vim.g.hatena.ne.jp/tyru/20100116
inoremap <silent><expr><C-k> "\<C-g>u".(col('.') == col('$') ? '<C-o>gJ' : '<C-o>D')
cnoremap <C-k> <C-\>e getcmdpos() == 1 ? '' : getcmdline()[:getcmdpos()-2]<CR>
"バッファ切り替え
nnoremap <silent><C-n>   :<C-u>bnext<CR>
nnoremap <silent><C-p>   :<C-u>bprevious<CR>
"CTRL-hjklでウィンドウ移動．横幅が小さすぎる場合は自動でリサイズする．
function! s:good_width()
    if winwidth(0) < 84
        vertical resize 84
    endif
endfunction
" <C-w> -> q
nnoremap <silent>qh <C-w>h:<C-u>call <SID>good_width()<CR>
nnoremap <silent>qj <C-w>j:<C-u>call <SID>good_width()<CR>
nnoremap <silent>qk <C-w>k:<C-u>call <SID>good_width()<CR>
nnoremap <silent>ql <C-w>l:<C-u>call <SID>good_width()<CR>
nnoremap <silent>qv <C-w>v
nnoremap <silent>qs <C-w>s
nnoremap <silent>q] <C-w>]
nnoremap <silent>qc <C-w>c
nnoremap <silent>qn <C-w>n
nnoremap <silent>qo <C-w>o
nnoremap <silent>qp <C-w>p
nnoremap <silent>qr <C-w>r
nnoremap <silent>qf <C-w>f
"インサートモードで次の行に直接改行
inoremap <C-j> <Esc>o
"<BS>の挙動
nnoremap <BS> bdw
" カーソルキーでのウィンドウサイズ変更
nnoremap <silent><Down>  <C-w>-
nnoremap <silent><Up>    <C-w>+
nnoremap <silent><Left>  <C-w><
nnoremap <silent><Right> <C-w>>
" 検索で / をエスケープしなくて良くする（素の / を入力したくなったら<C-v>/）
cnoremap <expr>/ getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr>/ getcmdtype() == '?' ? '\/' : '/'
" help のマッピング
augroup HelpMapping
    autocmd!
    " カーソル下のタグへ飛ぶ
    autocmd FileType help nnoremap <buffer>t <C-]>
    " 戻る
    autocmd FileType help nnoremap <buffer>r <C-t>
    " 履歴を戻る
    autocmd FileType help nnoremap <buffer>< :<C-u>pop<CR>
    " 履歴を進む
    autocmd FileType help nnoremap <buffer>> :<C-u>tag<CR>
    " 履歴一覧
    autocmd FileType help nnoremap <buffer><Tab> :<C-u>tags<CR>
    " そのた
    autocmd FileType help nnoremap <buffer>u <C-u>
    autocmd FileType help nnoremap <buffer>d <C-d>
    autocmd FileType help nnoremap <buffer>q :<C-u>q<CR>
    autocmd FileType help nnoremap <buffer>x :<C-u>q<CR>
augroup END
" ペーストした文字列をビジュアルモードで選択
nnoremap <expr>gp '`['.strpart(getregtype(),0,1).'`]'
" 貼り付けは P のほうが好みかも
    " nnoremap p P
" 最後にヤンクしたテキストを貼り付け．
nnoremap P "0P

" タブの設定
nnoremap ge :<C-u>tabedit<Space>
nnoremap gn :<C-u>tabnew<CR>
nnoremap <silent>gc :<C-u>tabclose<CR>
" 行表示・非表示の切り替え．少しでも横幅が欲しい時は OFF に
nnoremap <Leader><Leader> :<C-u>set number! number?<CR>
" クリップボードから貼り付け
inoremap <C-r>* <C-o>:set paste<CR><C-r>*<C-o>:set nopaste<CR>
" カーソル下の単語を help で調べる
nnoremap K :<C-u>help <C-r><C-w><CR>
" TODO v で選択した範囲を help
" 貼り付けはインデントを揃える
    " nnoremap p ]p
" 行頭 → 非空白行頭 → 行 をローテートする
function! s:rotate_in_line()
    let c = col('.')

    let cmd = c == 1 ? '^' : '$'
    execute "normal! ".cmd

    " 行頭にスペースがなかったときは行頭と行末をトグル
    if c == col('.')
        if cmd == '^'
            normal! $
        else
            normal! 0
        endif
    endif

endfunction
nnoremap <silent>t :<C-u>call <SID>rotate_in_line()<CR>
" }}}

"}}}

" 最小限の設定と最小限のプラグインだけ読み込む {{{
" % vim --cmd "g:linda_pp_startup_with_tiny = 1" で起動した時
" または vi という名前の シンボリックリンク越しに vim を起動した時
if (exists("g:linda_pp_startup_with_tiny") && g:linda_pp_startup_with_tiny)
            \ || v:progname ==# 'vi'
    let g:caw_no_default_keymappings = 1
    if has('vim_starting')
        set rtp+=~/.vim/bundle/caw.vim
    endif
    nmap <Leader>c <Plug>(caw:i:toggle)
    vmap <Leader>c <Plug>(caw:i:toggle)
    nmap <Leader>C <Plug>(caw:wrap:toggle)
    vmap <Leader>C <Plug>(caw:wrap:toggle)
    finish
endif
"}}}

" user-defined functions and commands {{{
" clean unnecessary whitespaces
command! CleanSpaces call <SID>clean_whitespaces()
function! s:clean_whitespaces()
    let cursor = getpos(".")
    retab!
    %s/\s\+$//ge
    call setpos(".", cursor)
endfunction

command! Date :call setline('.', getline('.') . strftime('%Y/%m/%d (%a) %H:%M'))

" open config file
command! Vimrc call s:edit_myvimrc()
function! s:edit_myvimrc()
    let files = ""
    if isdirectory($HOME.'/Github/dotfiles')
        if !empty($MYVIMRC)
            let files .= substitute(expand('~/Github/dotfiles/vimrc*'),'\n',' ','g')
        endif
        if !empty($MYGVIMRC)
            let files .= " " . substitute(expand('~/Github/dotfiles/gvimrc*'),'\n',' ','g')
        endif
    else
        if !empty($MYVIMRC)
            let files .= $MYVIMRC
        endif
        if !empty($MYGVIMRC)
            let files .= " " . $MYGVIMRC
        endif
    endif
    execute "args " . files
endfunction

" display all maps
" :AllMaps
" :AllMaps <buffer1> <buffer2> ...
" http://vim-users.jp/2011/02/hack203/
command! -nargs=* -complete=mapping
            \   AllMaps
            \   map <args> | map! <args> | lmap <args>

" output result of Vim script to new buffer
" :Capture <command>
" http://vim-users.jp/2011/02/hack203/
command! -nargs=+ -complete=command
            \   Capture
            \   call s:cmd_capture(<q-args>)

function! s:cmd_capture(q_args)
    redir => output
    silent execute a:q_args
    redir END
    let output = substitute(output, '^\n\+', '', '')

    belowright new

    silent file `=printf('[Capture: %s]', a:q_args)`
    setlocal buftype=nofile bufhidden=unload noswapfile nobuflisted
    call setline(1, split(output, '\n'))
endfunction

" カレントパスをクリプボゥにコピー
command! CopyCurrentPath :call s:copy_current_path()
function! s:copy_current_path()
    if has('win32')
        let @*=substitute(expand('%:p'), '\\/', '\\', 'g')
    elseif has('unix')
        let @*=expand('%:p')
    endif
endfunction

" エンコーディング指定オープン
command! -bang -complete=file -nargs=? Utf8 edit<bang> ++enc=utf-8 <args>
command! -bang -complete=file -nargs=? Sjis edit<bang> ++enc=cp932 <args>
command! -bang -complete=file -nargs=? Euc edit<bang> ++enc=eucjp <args>

" 適当なファイル名のファイルを開く
" http://vim-users.jp/2010/11/hack181/
command! -nargs=0 Sandbox call s:open_sandbox()
function! s:open_sandbox()
    let dir = $HOME . '/.vim_sandbox'
    if !isdirectory(dir)
        call mkdir(dir, 'p')
    endif

    let filename = input('New File: ', dir.strftime('/%Y-%m-%d-%H%M.'))
    if filename != ''
        execute 'edit ' . filename
    endif
endfunction

" Vim 力を測る Scouter （thinca さん改良版）
" http://d.hatena.ne.jp/thinca/20091031/1257001194
function! Scouter(file, ...)
    let pat = '^\s*$\|^\s*"'
    let lines = readfile(a:file)
    if !a:0 || !a:1
        let lines = split(substitute(join(lines, "\n"), '\n\s*\\', '', 'g'), "\n")
    endif
    return len(filter(lines,'v:val !~ pat'))
endfunction
command! -bar -bang -nargs=? -complete=file Scouter
            \        echo Scouter(empty(<q-args>) ? $MYVIMRC : expand(<q-args>), <bang>0)

"スクリプトローカルな関数を呼び出す
" http://d.hatena.ne.jp/thinca/20111228/1325077104
" Call a script local function.
" Usage:
" - S('local_func')
"   -> call s:local_func() in current file.
" - S('plugin/hoge.vim:local_func', 'string', 10)
"   -> call s:local_func('string', 10) in *plugin/hoge.vim.
" - S('plugin/hoge:local_func("string", 10)')
"   -> call s:local_func("string", 10) in *plugin/hoge(.vim)?.
function! S(f, ...)
  let [file, func] =a:f =~# ':' ?  split(a:f, ':') : [expand('%:p'), a:f]
  let fname = matchstr(func, '^\w*')

  " Get sourced scripts.
  redir =>slist
  silent scriptnames
  redir END

  let filepat = '\V' . substitute(file, '\\', '/', 'g') . '\v%(\.vim)?$'
  for s in split(slist, "\n")
    let p = matchlist(s, '^\s*\(\d\+\):\s*\(.*\)$')
    if empty(p)
      continue
    endif
    let [nr, sfile] = p[1 : 2]
    let sfile = fnamemodify(sfile, ':p:gs?\\?/?')
    if sfile =~# filepat &&
    \    exists(printf("*\<SNR>%d_%s", nr, fname))
      let cfunc = printf("\<SNR>%d_%s", nr, func)
      break
    endif
  endfor

  if !exists('nr')
    echoerr Not sourced: ' . file
    return
  elseif !exists('cfunc')
    let file = fnamemodify(file, ':p')
    echoerr printf(
    \    'File found, but function is not defined: %s: %s()', file, fname)
    return
  endif

  return 0 <= match(func, '^\w*\s*(.*)\s*$')
  \      ? eval(cfunc) : call(cfunc, a:000)
endfunction

"}}}

" helpers {{{

" git のルートディレクトリを開く
function! s:git_root_dir()
    if(system('git rev-parse --is-inside-work-tree') == "true\n")
        return system('git rev-parse --show-cdup')
    else
        echoerr 'current directory is outside git working tree'
    endif
endfunction

" Linux かどうか判定
    " let s:has_linux = !has('mac') && has('unix')
" 本当はこっちのほうが良いが，速度面で難あり
    " s:has_linux = executable('uname') && system('uname') == "Linux\n"
" これは Arch Linux だと使えない
    " s:has_linux = executable('lsb_release')

"}}}

" Ruby {{{
augroup RubyMapping
    autocmd!
    autocmd FileType ruby inoremap <buffer><C-s> self.
    autocmd FileType ruby inoremap <buffer>; <Bar>
    autocmd FileType ruby inoremap <buffer><Bslash>
    if isdirectory(expand('~').'/.vim/skeletons')
        autocmd BufNewFile *.rb 0r ~/.vim/skeletons/ruby.skel
    endif
augroup END
"}}}

" C++ {{{

" {} の展開．cinoptions とかでできそうな気もする．
" smartinput でもできるはずだけれど，my-endwise で <CR> が設定済みのため反映されない
function! s:cpp_expand_brace()
    let cmd = ""
    let curline = getline('.')
    let target = strpart( curline, col('.')-2, 2 )
    if target == "{}" || target == "<>"
        if target == "{}" && curline =~# '^\s*\%(class\|struct\)'
            let cmd = cmd."\<Right>;\<left>\<Left>"
        endif
        let cmd = cmd."\<CR>\<Up>\<C-o>$"
    endif
    return cmd
endfunction

" -> decltype(expr) の補完
" constexpr auto func_name(...) を仮定
function! s:return_type_completion()
    let cur_line = getline('.')
    if cur_line =~#
                \ '^\s*return\s*\%(.*\);\s*$'
        let ret_expr =
                    \ substitute(cur_line, '^\s*return\s*\%((\|\)\(.*\)\%()\|\);\s*$', '\1', '')
        let linum = line('.') - 1
        while linum > 0
            let cur_line = getline(linum)
            if cur_line =~#
                        \ '^\s*\%(constexpr\s\+\|\)\%(inline\s\+\|\)auto\s\+[A-Za-z][A-Za-z:0-9]*\s*(.*)\s*$'
                call setline(linum, cur_line." -> decltype(".ret_expr.")")
                echo "add return type at line ".linum
                break
            elseif cur_line =~#
                        \ '^\s*\%(constexpr\s\+\|\)\%(inline\s\+\|\)[A-Za-z][A-Za-z:0-9\[\]]*\s\+[A-Za-z][A-Za-z:0-9]*\s*(.*)\s*$'
                break
            endif
            let linum -= 1
        endwhile
    endif
endfunction

" ヘッダファイルとソースファイルを入れ替える
function! s:cpp_hpp()
    let cpps = ['cpp', 'cc', 'cxx', 'c']
    let hpps = ['hpp', 'h']
    let ext = expand('%:e')
    let base = expand('%:r')

    " ソースファイルのとき
    if count(cpps,ext) != 0
        for hpp in hpps
            if filereadable(base.'.'.hpp)
                execute 'edit '.base.'.'.hpp
                return
            endif
        endfor
    endif

    " ヘッダファイルのとき
    if count(hpps,ext) != 0
        for cpp in cpps
            if filereadable(base.'.'.cpp)
                execute 'edit '.base.'.'.cpp
                return
            endif
        endfor
    endif

    " なければ Unite で検索
    if has('mac')
        execute "Unite spotlight -input=".base
    elseif !has('mac') && has('unix')
        execute "Unite locate -input=".base
    endif

endfunction

command! CppHpp :call <SID>cpp_hpp()

augroup CppSetting
    au!
    autocmd FileType cpp setlocal tabstop=4 shiftwidth=4 softtabstop=4
    autocmd FileType cpp inoremap <buffer>,  ,<Space>
    autocmd FileType cpp inoremap <buffer>;; ::
    autocmd FileType cpp inoremap <buffer><C-s>s      <C-o>Bstd::<End>
    autocmd FileType cpp inoremap <buffer><C-s>b      <C-o>Bboost::<End>
    autocmd FileType cpp inoremap <silent><buffer><expr><CR> <SID>cpp_expand_brace()."\<CR>"
    autocmd FileType cpp nnoremap <buffer><Leader>ret :<C-u>call <SID>return_type_completion()<CR>
    autocmd FileType cpp nnoremap <buffer><Leader>s Bistd::<Esc>
    autocmd FileType cpp nnoremap <buffer><Leader>b Biboost::<Esc>
    autocmd FileType cpp nnoremap <buffer><Leader>d Bidetail::<Esc>
    autocmd FileType cpp nnoremap <silent><buffer><C-t> :<C-u>call <SID>cpp_hpp()<CR>
augroup END

" }}}

" Haskell {{{
    " augroup HaskellMapping
    "     autocmd!
    "     autocmd FileType haskell nnoremap <buffer><silent><Leader>ht :<C-u>call <SID>ShowTypeHaskell(expand('<cword>'))<CR>
    " augroup END
    " function! s:ShowTypeHaskell(word)
    "     echo join(split(system("ghc -isrc " . expand('%') . " -e ':t " . a:word . "'")))
    " endfunction
command! Ghci :<C-u>VimshellInteractive ghci<CR>
"}}}

" Vim script "{{{
augroup VimScriptSetting
    autocmd!
    autocmd FileType vim setlocal tabstop=4 shiftwidth=4 softtabstop=4
augroup END
"}}}

" neobundle.vim の設定 {{{
filetype off
filetype plugin indent off
if has('vim_starting')
    set rtp+=~/.vim/bundle/neobundle.vim/
    call neobundle#rc(expand('~/.vim/bundle'))
endif

" GitHub上のリポジトリ
NeoBundle 'Shougo/vimproc'
NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/vimfiler'
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/neocomplcache-snippets-complete'
NeoBundle 'vim-jp/cpp-vim'
    " NeoBundle 'Rip-Rip/clang_complete'
NeoBundle 'rhysd/clang_complete'
NeoBundle 'osyo-manga/neocomplcache-clang_complete'
NeoBundle 'rhysd/home-made-snippets'
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'tyru/caw.vim'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'h1mesuke/unite-outline'
NeoBundle 'osyo-manga/unite-fold'
NeoBundle 'ujihisa/unite-haskellimport'
NeoBundle 'sgur/unite-qf'
NeoBundle 'osyo-manga/unite-quickfix'
NeoBundle 'rhysd/quickrun-unite-qf-outputter'
NeoBundle 'basyura/unite-rails'
NeoBundle 'vim-jp/vimdoc-ja'
NeoBundle 'jceb/vim-hier'
NeoBundle 'rhysd/my-endwise'
    " NeoBundle 'tpope/vim-endwise'
NeoBundle 'kana/vim-textobj-user'
NeoBundle 'kana/vim-textobj-indent'
NeoBundle 'kana/vim-textobj-lastpat'
NeoBundle 'h1mesuke/textobj-wiw'
NeoBundle 'kana/vim-operator-user'
NeoBundle 'kana/vim-operator-replace'
NeoBundle 'thinca/vim-textobj-between'
NeoBundle 'thinca/vim-prettyprint'
NeoBundle 'rhysd/accelerated-jk'
NeoBundle 'kana/vim-smartinput'
NeoBundle 'thinca/vim-ref'
NeoBundle 'kana/vim-filetype-haskell'
NeoBundle 'ujihisa/ref-hoogle'
NeoBundle 'ujihisa/neco-ghc'
NeoBundle 'eagletmt/ghcmod-vim'
NeoBundle 'rhysd/auto-neobundle'
NeoBundle 'rhysd/wombat256.vim'
    " NeoBundle 'rhysd/ref-rurema'
    " NeoBundle 'ujihisa/vimshell-ssh'
    " NeoBundle 'h1mesuke/vim-alignta'
    " NeoBundle 'ujihisa/unite-colorscheme'
    " NeoBundle 'ujihisa/neco-look'

" vim-scripts上のリポジトリ
NeoBundle 'Align'
    " NeoBundle 'errormarker.vim'
    " NeoBundle 'endwise.vim'

" その他のgitリポジトリ
    " NeoBundle 'git://git.wincent.com/command-t.git'

" GUI オンリーなプラグイン
NeoBundleLazy 'ujihisa/unite-colorscheme'
NeoBundleLazy 'nathanaelkane/vim-indent-guides'
NeoBundleLazy 'tomasr/molokai'
NeoBundleLazy 'altercation/vim-colors-solarized'
NeoBundleLazy 'earendel'
NeoBundleLazy 'rdark'

filetype plugin indent on     " required!

" カラースキーム "{{{
colorscheme wombat256mod
" }}}

" auto_neobundle "{{{
" augroup AutoUpdate
"     autocmd!
"     autocmd VimEnter * call auto_neobundle#update_every_3days()
" augroup END
"}}}

" NeoBundle のキーマップ{{{
" すべて更新するときは基本的に Unite で非同期に実行
" nnoremap <silent><Leader>nbu   :<C-u>AutoNeoBundleTimestamp<CR>:NeoBundleUpdate<CR>
nnoremap <silent><Leader>nbu   :<C-u>NeoBundleUpdate<CR>
nnoremap <silent><Leader>nbc   :<C-u>NeoBundleClean<CR>
nnoremap <silent><Leader>nbi   :<C-u>NeoBundleInstall<CR>
nnoremap <silent><Leader>nbl   :<C-u>Unite output<CR>NeoBundleList<CR>
" }}}

" }}}

" neocomplcacheの設定 {{{
"AutoComplPopを無効にする
let g:acp_enableAtStartup = 0
"vim起動時に有効化
let g:neocomplcache_enable_at_startup = 1
"smart_caseを有効にする．大文字が入力されるまで大文字小文字の区別をなくす
let g:neocomplcache_enable_smart_case = 1
" CamelCase補完有効化
    "let g:neocomplcache_enable_camel_case_completion = 1
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
"リストの最大幅を指定
    "let g:neocomplcache_max_filename_width = 25
"区切り文字パターンの定義
if !exists('g:neocomplcache_delimiter_patterns')
    let g:neocomplcache_delimiter_patterns= {}
endif
let g:neocomplcache_delimiter_patterns.vim = ['#']
let g:neocomplcache_delimiter_patterns.cpp = ['::']
"インクルードパスの指定
if !exists('g:neocomplcache_include_paths')
    let g:neocomplcache_include_paths = {}
endif
let g:neocomplcache_include_paths.cpp  = '.,/usr/local/include,/usr/local/Cellar/gcc/4.7.1/gcc/include/c++/4.7.1'
let g:neocomplcache_include_paths.c    = '.,/usr/include'
let g:neocomplcache_include_paths.perl = '.,/System/Library/Perl,/Users/rhayasd/Programs'
let g:neocomplcache_include_paths.ruby = expand('~/.rbenv/versions/1.9.3-p194/lib/ruby/1.9.1')
"インクルード文のパターンを指定
let g:neocomplcache_include_patterns = { 'cpp' : '^\s*#\s*include', 'ruby' : '^\s*require', 'perl' : '^\s*use', }
"インクルード先のファイル名の解析パターン
let g:neocomplcache_include_exprs = {
            \ 'ruby' : "substitute(substitute(v:fname,'::','/','g'),'$','.rb','')"
            \ }
if !has("gui_running")
    "CUIのvimでの補完リストの色を調節する
    highlight Pmenu ctermbg=8
endif
" Enable omni completion.
augroup NeocomplcacheOmniFunc
    autocmd!
    autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd FileType html setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd FileType css setlocal omnifunc=csscomplete#CompleteCss
    autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
    autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
    autocmd FileType c setlocal omnifunc=ccomplete#Complete
    " autocmd FileType ruby set omnifunc=rubycomplete#Complete
augroup END
" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
    let g:neocomplcache_omni_patterns = {}
endif
    " let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'

"neocomplcacheのマッピング {{{
imap      <C-s>       <Plug>(neocomplcache_snippets_expand)
smap      <C-s>       <Plug>(neocomplcache_snippets_expand)
inoremap  <expr><C-g> neocomplcache#undo_completion()
    "inoremap <expr><C-l> neocomplcache#complete_common_string()
"スニペット展開候補があれば展開を，そうでなければbash風補完を．
imap <expr><C-l> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : neocomplcache#complete_common_string()
" <CR>: close popup and save indent.
imap <expr><CR>  pumvisible() ? neocomplcache#smart_close_popup()."\<CR>" : "\<CR>"
" <TAB>: completion
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
"スニペットがあればそれを展開．なければ通常の挙動をするTABキー
    " imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
    " inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
    " inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y> neocomplcache#close_popup()
"}}}

" }}}

" Unite.vim {{{
"insertモードをデフォルトに
let g:unite_enable_start_insert = 1
" 無指定にすることで高速化
let g:unite_source_file_mru_filename_format = ''
" most recently used のリストサイズ
let g:unite_source_file_mru_limit = 100
" Unite起動時のウィンドウ分割
let g:unite_split_rule = 'rightbelow'
" 使わないデフォルト Unite ソースをロードしない
let g:loaded_unite_source_bookmark = 1
let g:loaded_unite_source_tab = 1
let g:loaded_unite_source_window = 1
" unite-grep で使うコマンド
let g:unite_source_grep_default_opts = "-Hn --color=never"

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

"Unite.vimのキーマップ {{{
augroup UniteMapping
    autocmd!
    "insertモード時はC-gでいつでもバッファを閉じられる（絞り込み欄が空の時はC-hでもOK）
    autocmd FileType unite imap <buffer><C-g> <Plug>(unite_exit)
    " <Space> だと待ち時間が発生してしまうので <Space><Space> を割り当て
    autocmd FileType unite nmap <buffer><Space><Space> <Plug>(unite_toggle_mark_current_candidate)
    " q だと待ち時間が発生してしまうので
    autocmd FileType unite nmap <buffer><C-g> <Plug>(unite_exit)
    "直前のパス削除
    autocmd FileType unite imap <buffer><C-w> <Plug>(unite_delete_backward_path)
    autocmd FileType unite nmap <buffer>h <Plug>(unite_delete_backward_path)
    "ファイル上にカーソルがある時，pでプレビューを見る
    autocmd FileType unite inoremap <buffer><expr>p unite#smart_map("p", unite#do_action('preview'))
    "C-xでクイックマッチ
    autocmd FileType unite imap <buffer><C-x> <Plug>(unite_quick_match_default_action)
    "lでデフォルトアクションを実行
    autocmd FileType unite nmap <buffer>l <Plug>(unite_do_default_action)
    autocmd FileType unite imap <buffer><expr>l unite#smart_map("l", unite#do_action(unite#get_current_unite().context.default_action))
augroup END

nnoremap <Space> <Nop>
"バッファを開いた時のパスを起点としたファイル検索
nnoremap <silent><Space><Space> :<C-u>UniteWithBufferDir -buffer-name=files file -vertical<CR>
"最近使用したファイル
nnoremap <silent><Space>m :<C-u>Unite -no-start-insert file_mru directory_mru<CR>
"指定したディレクトリ以下を再帰的に開く
" nnoremap <silent><Space>R :<C-u>UniteWithBufferDir -no-start-insert file_rec/async -auto-resize<CR>
"バッファ一覧
nnoremap <silent><Space>b :<C-u>Unite -quick-match -auto-resize -immediately -no-empty -auto-preview buffer<CR>
"プログラミングにおけるアウトラインの表示
nnoremap <silent><Space>o :<C-u>Unite outline -vertical -no-start-insert<CR>
"コマンドの出力
nnoremap <silent><Space>c :<C-u>Unite output<CR>
"grep検索．
nnoremap <silent><Space>g :<C-u>Unite -no-start-insert grep<CR>
"find
nnoremap <silent><Space>fi :<C-u>Unite -no-start-insert find<CR>
"Uniteバッファの復元
nnoremap <silent><Space>r :<C-u>UniteResume<CR>
"SpotLight の利用
nnoremap <silent><Space>L :<C-u>Unite line<CR>
" NeoBundle
" nnoremap <silent><Space>nb :<C-u>AutoNeoBundleTimestamp<CR>:Unite neobundle/update -auto-quit<CR>
nnoremap <silent><Space>nb :<C-u>Unite neobundle/update -auto-quit<CR>
" Haskell Import
augroup HaskellImport
    autocmd!
    autocmd FileType haskell
                \ nnoremap <buffer><expr><Space>hi
                \ empty(expand("<cword>")) ? ":\<C-u>Unite haskellimport\<CR>"
                \ : ":\<C-u>UniteWithCursorWord haskellimport -immediately<CR>"
augroup END
" Git のルートディレクトリを開く
nnoremap <silent><expr><Space>fg ":\<C-u>Unite file -input=".fnamemodify(<SID>git_root_dir(),":p")
" fold
nnoremap <silent><Space>fl :<C-u>Unite fold -no-start-insert -no-empty<CR>
" }}}

" unite-rails コマンド {{{
command! RModels Unite rails/model -no-start-insert -auto-resize
command! RControllers Unite rails/controller -no-start-insert -auto-resize
command! RViews Unite rails/view -no-start-insert -auto-resize
command! RMVC Unite rails/model rails/controller rails/view
command! RHelpers Unite rails/helpers -no-start-insert -auto-resize
command! RMailers Unite rails/mailers -no-start-insert -auto-resize
command! RLib Unite rails/lib -no-start-insert -auto-resize
command! RDb Unite rails/db -no-start-insert -auto-resize
command! RConfig Unite rails/config -no-start-insert -auto-resize
command! RLog Unite rails/log -no-start-insert -auto-resize
command! RJapascripts Unite rails/javascripts -no-start-insert -auto-resize
command! RStylesheets Unite rails/stylesheets -no-start-insert -auto-resize
command! RBundle Unite rails/bundle -no-start-insert -auto-resize
command! RGems Unite rails/bundled_gem -no-start-insert -auto-resize
command! R execute 'Unite rails/model rails/controller rails/view -no-start-insert -autoresize -input=' . s:rails_mvc_name()
" }}}

" }}}

" VimShellの設定 {{{
" プロンプト
let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
let g:vimshell_right_prompt = 'strftime("%Y/%m/%d %H:%M")'
let g:vimshell_prompt = "(U'w'){ "
    " let g:vimshell_prompt = "(U^w^){ "
" 右プロンプト ( vimshell#vcs#info は deprecated )
    " let g:vimshell_right_prompt = 'vimshell#vcs#info("(%s)-[%b]", "(%s)-[%b|%a]")'
" 分割割合(%)
let g:vimshell_split_height = 25

"VimShell のキーマッピング {{{
nmap <Leader>vs <Plug>(vimshell_split_switch)
" }}}

" }}}

" vim-quickrunの設定 {{{
"<Leader>r を使わない
let g:quickrun_no_default_key_mappings = 1
" quickrun_configの初期化
if !has("g:quickrun_config")
    let g:quickrun_config = {}
endif
"C++
let g:quickrun_config.cpp = { 'command' : "g++", 'cmdopt' : '-std=c++11 -Wall -Wextra -O2' }
" clang 用
let g:quickrun_config['cpp/clang'] = { 'command' : 'clang++', 'cmdopt' : '-stdlib=libc++ -std=c++11 -Wall -Wextra -O2' }
"QuickRun 結果の開き方
let g:quickrun_config._ = { 'outputter' : 'unite_qf', 'split' : 'rightbelow 10sp' }

"QuickRunのキーマップ {{{
nnoremap <Leader>q  <Nop>
nnoremap <silent><Leader>qr :<C-u>QuickRun<CR>
nnoremap <silent><Leader>qf :<C-u>QuickRun >quickfix -runner vimproc<CR>
vnoremap <silent><Leader>qr :QuickRun<CR>
vnoremap <silent><Leader>qf :QuickRun >quickfix -runner vimproc<CR>
nnoremap <silent><Leader>qR :<C-u>QuickRun<Space>
if has('mac')
    nnoremap <silent><Leader>qn :<C-u>QuickRun >mac_notifier -runner vimproc<CR>
    vnoremap <silent><Leader>qn :QuickRun >mac_notifier -runner vimproc<CR>
end
" clang で実行する
augroup QuickRunClang
    autocmd!
    autocmd FileType cpp nnoremap <silent><Leader>qc :<C-u>QuickRun clang<CR>
augroup END

augroup QFixMapping
    autocmd!
    autocmd FileType qf nnoremap <buffer><silent> q :q<CR>
    autocmd FileType qf nnoremap <buffer><silent> j :cn!<CR>
    autocmd FileType qf nnoremap <buffer><silent> k :cp!<CR>
augroup END
" }}}

" }}}

" accelerated-jk "{{{
nmap <silent>j <Plug>(accelerated_jk_gj)
nmap <silent>k <Plug>(accelerated_jk_gk)
"}}}

" Hier.vim {{{
"CUIだとエラーハイライトが見づらいので修正
if !has("gui_running")
    highlight qf_error_ucurl ctermbg=9
    let g:hier_highlight_group_qf = "qf_error_ucurl"
    let g:hier_highlight_group_loc = "qf_error_ucurl"
    highlight qf_warning_ucurl ctermbg=3
    let g:hier_highlight_group_qfw = "qf_warning_ucurl"
    let g:hier_highlight_group_locw = "qf_warning_ucurl"
    " QuickFix選択中のエラー
    highlight Search ctermbg=8
endif

nnoremap <silent><Esc><Esc> :<C-u>nohlsearch<CR>:HierClear<CR>
" }}}

" VimFilerの設定 {{{
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_safe_mode_by_default = 0
let g:vimfiler_split_command = 'vertical rightbelow vsplit'
let g:vimfiler_execute_file_list = { 'c' : 'vim',  'h' : 'vim',  'cpp' : 'vim',  'hpp' : 'vim', 'cc' : 'vim',  'rb' : 'vim', 'txt' : 'vim', 'pdf' : 'open', 'vim' : 'vim' }

" vimfiler.vim のキーマップ {{{

augroup VimFilerMapping
    autocmd!
    autocmd FileType vimfiler nmap <buffer><silent><expr> e vimfiler#smart_cursor_map(
                \   "\<Plug>(vimfiler_cd_file)",
                \   "\<Plug>(vimfiler_edit_file)")
augroup END
nnoremap <Leader>f        <Nop>
nnoremap <Leader>ff       :<C-u>VimFiler<CR>
nnoremap <Leader>fnq      :<C-u>VimFiler<Space>-no-quit<CR>
nnoremap <Leader>fh       :<C-u>VimFiler<Space>~<CR>
nnoremap <Leader>fc       :<C-u>VimFilerCurrentDir<CR>
nnoremap <Leader>fb       :<C-u>VimFilerBufferDir<CR>
nnoremap <expr><Leader>fg ":\<C-u>VimFiler " . <SID>git_root_dir() . '\<CR>'
"        }}}

" }}}

" clang_complete {{{
let g:neocomplcache_force_overwrite_completefunc=1
let g:clang_complete_auto=1
let g:clang_hl_errors=1
let g:clang_conceal_snippets=1
let g:clang_exec="/usr/bin/clang"
let g:clang_user_options='-I /usr/local/include -I /usr/include -I /usr/local/Cellar/gcc/4.7.1/gcc/include/c++/4.7.1 2>/dev/null || exit 0'
" }}}

" vim-smartinput"{{{
    " call smartinput#define_default_rules()

" 括弧内のスペース
    " call smartinput#map_to_trigger('i', '(', '(', '(')
call smartinput#define_rule({
            \   'at':       '(\%#)',
            \   'char':     '<Space>',
            \   'input':    '<Space><Space><Left>',
            \   })

call smartinput#map_to_trigger('i', '<Space>', '<Space>', '<Space>')
call smartinput#define_rule({
            \   'at':       '( \%# )',
            \   'char':     '<BS>',
            \   'input':    '<Del><BS>',
            \   })

call smartinput#define_rule({
            \   'at':       '{\%#}',
            \   'char':     '<Space>',
            \   'input':    '<Space><Space><Left>',
            \   })

call smartinput#define_rule({
            \   'at':       '{ \%# }',
            \   'char':     '<BS>',
            \   'input':    '<Del><BS>',
            \   })

call smartinput#define_rule({
            \   'at':       '\[\%#\]',
            \   'char':     '<Space>',
            \   'input':    '<Space><Space><Left>',
            \   })

call smartinput#define_rule({
            \   'at':       '\[ \%# \]',
            \   'char':     '<BS>',
            \   'input':    '<Del><BS>',
            \   })

" Ruby 文字列内変数埋め込み
call smartinput#map_to_trigger('i', '#', '#', '#')
call smartinput#define_rule({
            \   'at': '\%#',
            \   'char': '#',
            \   'input': '#{}<Left>',
            \   'filetype': ['ruby'],
            \   'syntax': ['Constant', 'Special'],
            \   })

" Ruby ブロック引数 ||
call smartinput#map_to_trigger('i', '<Bar>', '<Bar>', '<Bar>')
call smartinput#define_rule({
            \   'at': '\({\|\<do\>\)\s*\%#',
            \   'char': '<Bar>',
            \   'input': '<Bar><Bar><Left>',
            \   'filetype': ['ruby'],
            \    })

" テンプレート内のスペース
call smartinput#map_to_trigger('i', '<', '<', '<')
call smartinput#define_rule({
            \   'at':       '<\%#>',
            \   'char':     '<Space>',
            \   'input':    '<Space><Space><Left>',
            \   'filetype': ['cpp'],
            \   })
call smartinput#define_rule({
            \   'at':       '< \%# >',
            \   'char':     '<BS>',
            \   'input':    '<Del><BS>',
            \   'filetype': ['cpp'],
            \   })

" クラス定義の場合は末尾に;を付け忘れないようにする
    " call smartinput#define_rule({
    " \   'at': '\(\<struct\>\|\<class\>\)\s*\w*\s*{\%#}',
    " \   'char': '<CR>',
    " \   'input': '<Right>;<Left><CR><CR><Up>',
    " \   'filetype': ['cpp'],
    " \   })

"}}}

" caw.vim {{{
" デフォルトマッピングを OFF
let g:caw_no_default_keymappings = 1

" キーマッピング {{{
nmap <Leader>c <Nop>
vmap <Leader>c <Nop>
" 行コメント
nmap <Leader>cc <Plug>(caw:i:toggle)
vmap <Leader>cc <Plug>(caw:i:toggle)
" 行末尾コメント
nmap <Leader>ca <Plug>(caw:a:toggle)
vmap <Leader>ca <Plug>(caw:a:toggle)
" ブロックコメント
nmap <Leader>cw <Plug>(caw:wrap:toggle)
vmap <Leader>cw <Plug>(caw:wrap:toggle)
" 改行後コメント
nmap <Leader>co <Plug>(caw:jump:comment-next)
nmap <Leader>cO <Plug>(caw:jump:comment-prev)
"}}}

"}}}

" textobj-wiw {{{
let g:textobj_wiw_no_default_key_mappings = 1 " デフォルトキーマップの解除
omap ac <Plug>(textobj-wiw-a)
omap ic <Plug>(textobj-wiw-i)
" }}}

" vim-operator {{{
nmap <Leader>r <Plug>(operator-replace)
vmap <Leader>r <Plug>(operator-replace)
"}}}

" ghcmod-vim {{{
augroup GhcModSetting
    autocmd!
    autocmd FileType haskell nnoremap <buffer><silent><C-t> :<C-u>GhcModType<CR>
    autocmd BufWritePost *.hs GhcModCheckAndLintAsync
    autocmd FileType haskell let &l:statusline = '%{empty(getqflist()) ? "[No Errors] " : "[Errors Found] "}'
                                               \ . (empty(&l:statusline) ? &statusline : &l:statusline)
    autocmd FileType haskell nnoremap <buffer><silent><Esc><Esc> :<C-u>nohlsearch<CR>:HierClear<CR>:GhcModTypeClear<CR>
    autocmd FileType haskell nnoremap <buffer><silent>cqf :<C-u>cclose<CR>
augroup END
"}}}

" 自作スニペット {{{
let g:neocomplcache_snippets_dir=$HOME.'/.vim/bundle/home-made-snippets/snippets'
"}}}

"endwise.vim {{{
augroup EndWiseMapping
    autocmd!
    autocmd FileType ruby,vim imap <buffer> <expr><CR>  pumvisible() ? neocomplcache#smart_close_popup() . "\<CR>\<Plug>DiscretionaryEnd" : "\<CR>\<Plug>DiscretionaryEnd"
augroup END
" }}}

" プラットフォーム依存な設定をロードする "{{{
if has('mac') && filereadable($HOME."/.vimrc.mac")
    source $HOME/.vimrc.mac
elseif has('unix') && filereadable($HOME.'/.vimrc.linux')
    source $HOME/.vimrc.linux
endif
"}}}

" vim: set ft=vim fdm=marker ff=unix fileencoding=utf-8
