" GUI のみで読み込むプラグイン

NeoBundleSource unite-colorscheme
NeoBundleSource vim-indent-guides
NeoBundleSource molokai
NeoBundleSource vim-colors-solarized
NeoBundleSource earendel
NeoBundleSource rdark

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

" GUI autocmds
augroup GuiAtStart
    autocmd!
    autocmd VimEnter * :VimFiler
augroup END

" vim-indent-guides {{{
let g:indent_guides_guide_size = 1
augroup IndentGuidesAutoCmd
    autocmd!
augroup END
if !has('gui_running') && &t_Co >= 256
    let g:indent_guides_auto_colors = 0
    autocmd IndentGuidesAutoCmd VimEnter,Colorscheme * hi IndentGuidesOdd  ctermbg=233
    autocmd IndentGuidesAutoCmd VimEnter,Colorscheme * hi IndentGuidesEven ctermbg=240
endif
autocmd IndentGuidesAutoCmd FileType haskell,python,haml call indent_guides#enable()
"}}}

nnoremap <Space>C :<C-u>Unite -auto-preview colorscheme<CR>

" プラットフォーム依存な設定の読み込み
if has('mac') && filereadable($HOME.'/.gvimrc.mac')
    source $HOME/.gvimrc.mac
elseif has('unix') && filereadable($HOME.'/.gvimrc.linux')
    source $HOME/.gvimrc.linux
endif

" vim: set ft=vim fdm=marker ff=unix fileencoding=utf-8 :
