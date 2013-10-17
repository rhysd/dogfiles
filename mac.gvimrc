set background=light
colorscheme solarized
let g:airline_theme = 'solarized'
" do not load togglebg
let g:loaded_togglebg = 1

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

" vim: set ft=vim fdm=marker ff=unix fileencoding=utf-8
