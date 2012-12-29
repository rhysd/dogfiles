" 不可視文字
set listchars=tab:>-,trail:-,eol:$,extends:>,precedes:<,nbsp:%
" 256色使う
set t_Co=256

colorscheme wombat256mod
" プラグインのロード
filetype off
filetype plugin indent off
NeoBundle 'ujihisa/unite-locate'
NeoBundle 'Lokaltog/vim-powerline'
" GUI
filetype plugin indent on     " required!

" プラグインの設定
let g:neocomplcache_ctags_program = '/usr/bin/ctags'
nnoremap <silent>[unite]l :<C-u>UniteWithInput locate<CR>
autocmd MyVimrc FileType vimshell call vimshell#set_alias('gpp', 'g++ -std=c++11 -O2 -g -Wall -Wextra')

" waf でビルド
command! -nargs=* Waf call s:waf(<f-args>)

function! s:waf(...)
    if ! filereadable('waf')
        echoerr 'waf file is not found.'
        return
    endif
    let cmd = './waf '.join(a:000, ' ')
    VimShellCurrentDir -split-command=vsplit
    execute 'VimShellSendString' cmd
    startinsert
endfunction

" vim: set ft=vim fdm=marker ff=unix fileencoding=utf-8 :
