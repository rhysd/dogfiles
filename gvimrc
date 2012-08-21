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

" GUI autocmds
augroup GuiAutoCmd
    autocmd!
    autocmd VimEnter * :VimFiler
augroup END

" specific platform settings
if has('mac')
    set background=light
    colorscheme solarized_sl "カラースキーマの指定
    set fuoptions=maxvert,maxhorz
    set guifont=Ricty:h16
    " F12 で透過率を3段階に切り替え(0, 40, 80)
    set transparency=0 "初期背景透過0%
    nnoremap <expr><F12> &transparency+40 > 100 ? ":set transparency=0\<CR>" : ":let &transparency=&transparency+40\<CR>"
    " 常にフルスクリーン
    augroup GuiMac
        autocmd!
        autocmd GUIEnter * set fullscreen
    augroup END
elseif has('unix')
    set background=dark
    colorscheme molokai
    set guifont=Ricty\ 16
endif

