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

" pdf ファイルを開く
command! -nargs=0 TeXPdfOpen call <SID>tex_pdf_open(expand('%'))
autocmd MyVimrc FileType tex nnoremap <buffer><Leader>tp :<C-u>TeXPdfOpen<CR>

function! s:tex_pdf_open(fname)
    if fnamemodify(a:fname, ':e') !=# 'tex'
        echoerr a:fname.' is not a latex file!'
        return
    endif

    let pdf_name = fnamemodify(a:fname, ':p:r').'.pdf'
    if ! filereadable(pdf_name)
        echoerr pdf_name.' is not found!'
        return
    endif

    call vimproc#system_bg('zathura '.pdf_name)
endfunction

command! -nargs=0 TeXMakePdf call <SID>tex_make_pdf(expand('%:r'))
autocmd MyVimrc FileType tex nnoremap <buffer><Leader>tm :<C-u>TeXMakePdf<CR>
function! s:tex_make_pdf(base)
    VimShellCurrentDir -split-command=vsplit
    execute 'VimShellSendString' 'platex '.a:base.' && dvipdfmx '.a:base
endfunction

let g:quickrun_config.tex = {'exec' : ['platex %s:p', 'dvipdfmx %s:p'] }

" vim: set ft=vim fdm=marker ff=unix fileencoding=utf-8 :
