" 不可視文字
set listchars=tab:>-,trail:-,eol:$,extends:>,precedes:<,nbsp:%
" 256色使う
set t_Co=256

" pdf ファイルを開く
command! -nargs=0 TeXPdfOpen call <SID>tex_pdf_open(expand('%'))
AutocmdFT tex nnoremap <buffer><Leader>tp :<C-u>TeXPdfOpen<CR>

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

" vim: set ft=vim fdm=marker ff=unix fileencoding=utf-8 :
