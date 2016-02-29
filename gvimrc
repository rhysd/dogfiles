" 基本設定
"ツールバーの非表示
set guioptions-=T
"スクロールバー無し
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L
set guioptions-=t
set guioptions-=b
"メニューバー無し
set guioptions-=m
"無効メニュー項目の灰色表示無し
set guioptions-=g
" autoselect いらない
set guioptions-=a
" メニューを読み込まない
set guioptions+=M

" メニューにアクセスしない
set winaltkeys=no

" GUI autocmds
Autocmd VimEnter * call Vimfiler_at_start()

set background=light
colorscheme solarized
let g:airline_theme = 'solarized'

function! Vimfiler_at_start()
    if empty(bufname('%'))
        VimFilerCurrentDir
    endif
endfunction

let g:haskell_conceal = 1

if isdirectory(expand('~/.cabal/bin'))
    let $PATH .= ':'.expand('~/.cabal/bin')
endif

if has('mac')
    " do not load togglebg
    let g:loaded_togglebg = 1

    set fuoptions=maxvert,maxhorz
    set guifont=Ricty:h16
    " F12 で透過率を3段階に切り替え(0, 40, 80)
    set transparency=0 "初期背景透過0%
    nnoremap <expr><F12> &transparency+40 > 100 ? ":set transparency=0\<CR>" : ":let &transparency=&transparency+40\<CR>"
elseif has('unix')
    colorscheme molokai

    NeoBundleSource restart.vim

    " IM の起動キーを gVim に教える
    " set imactivatekey=S-space
    set iminsert=2
    set vb t_vb=
    " フォント設定
    set guifont=Migu\ 2M\ 14
    set guioptions-=e
endif

call SourceIfExist($HOME . '/.local.gvimrc')

" vim: set ft=vim fdm=marker ff=unix fileencoding=utf-8 :
