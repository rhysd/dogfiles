" GUI のみで読み込むプラグイン

NeoBundleSource unite-colorscheme
NeoBundleSource molokai
NeoBundleSource vim-colors-solarized
NeoBundleSource earendel
NeoBundleSource rdark
NeoBundleSource vim-color-github

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

" メニューにアクセスしない
set winaltkeys=no

" GUI autocmds
augroup GuiAtStart
    autocmd!
    autocmd VimEnter * call <SID>vimfiler_at_start()
augroup END

function! s:vimfiler_at_start()
    if empty(bufname('%'))
        VimFilerCurrentDir
    endif
endfunction

" IndentGuides はインデント指向言語を扱う時だけ読み込む "{{{
augroup IndentGuidesAutoCmd
    autocmd!
augroup END
autocmd IndentGuidesAutoCmd FileType haskell,python,haml call s:prepare_indent_guides()

function! s:prepare_indent_guides()

    " 一度読みこめばもういらないのでリセット
    augroup IndentGuidesAutoCmd
        autocmd!
    augroup END

    NeoBundleSource vim-indent-guides
    let g:indent_guides_guide_size = 1
    let g:indent_guides_auto_colors = 1
    if !has('gui_running') && &t_Co >= 256
        let g:indent_guides_auto_colors = 0
        autocmd IndentGuidesAutoCmd VimEnter,Colorscheme * hi IndentGuidesOdd  ctermbg=233
        autocmd IndentGuidesAutoCmd VimEnter,Colorscheme * hi IndentGuidesEven ctermbg=240
    endif
    call indent_guides#enable()
endfunction
"}}}

nnoremap <Space>C :<C-u>Unite -auto-preview colorscheme<CR>

let g:haskell_conceal = 1

" プラットフォーム依存な設定の読み込み
if has('mac') && filereadable($HOME.'/.gvimrc.mac')
    source $HOME/.gvimrc.mac
elseif has('unix') && filereadable($HOME.'/.gvimrc.linux')
    source $HOME/.gvimrc.linux
endif

" vim: set ft=vim fdm=marker ff=unix fileencoding=utf-8 :
