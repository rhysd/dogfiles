" GUI のみで読み込むプラグイン

NeoBundleSource unite-colorscheme
NeoBundleSource molokai
NeoBundleSource vim-colors-solarized

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

nnoremap <Space>C :<C-u>Unite -auto-preview colorscheme<CR>

" プラットフォーム依存な設定の読み込み
if has('mac') && filereadable($HOME.'/.gvimrc.mac')
    source $HOME/.gvimrc.mac
elseif has('unix') && filereadable($HOME.'/.gvimrc.linux')
    source $HOME/.gvimrc.linux
endif

" vim: set ft=vim fdm=marker ff=unix fileencoding=utf-8 :
