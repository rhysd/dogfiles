" if has("gui_running")
set cursorline
" set guifont=Migu\ 2M:h16
" set guifont=Ricty
" colorscheme solarized_sl "カラースキーマの指定
colorscheme molokai "カラースキーマの指定
set guioptions-=T "ツールバーの非表示
set guioptions-=r "右スクロールバー無し
set guioptions-=R "右スクロールバー無し
set guioptions-=l "左スクロールバー無し
set guioptions-=L "左スクロールバー無し
set guioptions-=t "上スクロールバー無し
set guioptions-=b "下スクロールバー無し
set guioptions-=m "メニューバーを表示しない

autocmd VimEnter * :VimFiler
" endif
