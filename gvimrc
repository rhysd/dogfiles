if has("gui_running")
    set cursorline
    " set guifont=Migu\ 2M:h16
    set guifont=Ricty:h16
    set background=light
    set guioptions-=T "ツールバーの非表示
    set guioptions-=r "右スクロールバー無し
    set guioptions-=R "右スクロールバー無し
    set guioptions-=l "左スクロールバー無し
    set guioptions-=L "左スクロールバー無し
    set guioptions-=t "上スクロールバー無し
    set guioptions-=b "下スクロールバー無し
    set guioptions-=m "メニューバー無し
    if has('mac')
        colorscheme solarized_sl "カラースキーマの指定
        set fuoptions=maxvert,maxhorz
        " F12 で透過率を3段階に切り替え(0, 40, 80)
        set transparency=0 "初期背景透過0%
        nnoremap <expr><F12> &transparency+40 > 100 ? ":set transparency=0\<CR>" : ":let &transparency=&transparency+40\<CR>"
        " 常にフルスクリーン
        au GUIEnter * set fullscreen
    else
        colorscheme molokai
    endif
    if has('vim_starting')
        autocmd VimEnter * :VimFiler
    endif
endif
