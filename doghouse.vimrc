if has('vim_staring')
    " set rtp+=
endif

filetype off
filetype plugin indent off

" testing plugins
" NeoBundle 'Lokaltog/vim-easymotion'

filetype plugin indent on     " required!

nnoremap <silent><expr>s "i".nr2char(getchar())."\<Esc>"
