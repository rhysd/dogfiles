if has("gui_running")
    set cursorline
    " set guifont=Migu\ 2M:h16
    set guifont=Ricty:h16
    set fuoptions=maxvert,maxhorz
    colorscheme solarized_sl "カラースキーマの指定
    set guioptions-=T "ツールバーの非表示
    set guioptions-=r "右スクロールバー無し
    set guioptions-=R "右スクロールバー無し
    set guioptions-=l "左スクロールバー無し
    set guioptions-=L "左スクロールバー無し
    set guioptions-=t "上スクロールバー無し
    set guioptions-=b "下スクロールバー無し
    if has('mac') 
        set transparency=0 "背景透過0%
        " F12 で透過率を3段階に切り替え(0, 40, 80)
        nnoremap <expr><F12> &transparency+40 >= 100 ? ":set transparency=0\<CR>" : ":let &transparency=&transparency+40\<CR>"
        au GUIEnter * set fullscreen "常にフルスクリーン
    endif

    autocmd VimEnter * :VimFiler
endif
