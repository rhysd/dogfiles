" 不可視文字
set listchars=tab:>-,trail:-,eol:$,extends:>,precedes:<,nbsp:%
" 256色使う
set t_Co=256

" プラグインの設定
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

command! -nargs=0 TeXMakePdf call <SID>tex_make_pdf(expand('%:p'))
autocmd MyVimrc FileType tex nnoremap <buffer><Leader>tm :<C-u>TeXMakePdf<CR>
function! s:tex_make_pdf(path)
    execute 'lcd' fnamemodify(a:path, ':h')
    let base = fnamemodify(a:path, ':r')
    VimShellCurrentDir -split-command=vsplit
    execute 'VimShellSendString' 'platex '.base.' && dvipdfmx '.base
endfunction

let g:quickrun_config.tex = {'exec' : ['platex %s:p', 'dvipdfmx %s:p'] }

" 句読点変換
command! -nargs=0 ConvertCommaPeriod call <SID>convert_comma_period()

function! s:convert_comma_period()
    %substitute/，/、/g
    %substitute/．/。/g
endfunction

" openbrowser
let s:browser = executable('google-chrome') ? 'google-chrome' : 'firefox'
let g:openbrowser_open_commands = [
        \   {'name': s:browser,
        \    'args': ['{browser}', '{uri}']},
        \   {'name': 'xdg-open',
        \    'args': ['{browser}', '{uri}']},
        \   {'name': 'w3m',
        \    'args': ['{browser}', '{uri}']},
        \]
unlet s:browser

" vim-marching
let g:marching_command_option = '-std=c++11'
let g:marching_include_paths = [
            \ '/usr/include/c++/4.8.1',
            \ '/usr/local/include',
            \ ]

" vim: set ft=vim fdm=marker ff=unix fileencoding=utf-8 :
