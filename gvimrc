" 基本設定
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
" autoselect いらない
set guioptions-=a
" メニューを読み込まない
set guioptions+=M

" メニューにアクセスしない
set winaltkeys=no

function! s:dirvish_at_start() abort
    if empty(bufname('%'))
        Dirvish
    endif
endfunction

" GUI autocmds
Autocmd VimEnter * if empty(bufname('%')) | Dirvish | endif

let s:cabal_bin_dir = expand('~/.cabal/bin')
if isdirectory(s:cabal_bin_dir)
    let $PATH .= ':' . s:cabal_bin_dir
endif

colorscheme spring-night
let g:airline_theme = 'spring_night'

if has('mac')
    " do not load togglebg
    let g:loaded_togglebg = 1

    set fuoptions=maxvert,maxhorz
    set guifont=SF\ Mono:h14
    " F12 で透過率を3段階に切り替え(0, 40, 80)
    set transparency=0 "初期背景透過0%
    nnoremap <silent><F12> :<C-u>let &transparency=&transparency + 40 > 100 ? 0 : &transparency + 40<CR>

    function! s:show_on_safari() abort
        let src = expand('%')
        TOhtml
        if expand('%') !=# src . '.html'
            echoerr 'Failed to make HTML from current buffer: ' . expand('%')
        endif

        let f = expand('~/tmp.html')
        execute 'silent! write!' f
        if !filereadable(f)
            echoerr 'Cannot save generated HTML ' . f
            return
        endif

        try
            call system('open -a Safari ' . f)
            if v:shell_error
                echoerr 'Failed to open Safari: ' + f
                return
            endif

            " Need to wait Safari starting before deleting the temporary file
            sleep 2

            bwipeout!
        finally
            call delete(f)
        endtry

        quit
    endfunction
    command! -nargs=0 -bar ShowOnSafari call <SID>show_on_safari()
elseif has('unix')
    " IM の起動キーを gVim に教える
    " set imactivatekey=S-space
    set iminsert=2
    set vb t_vb=
    " フォント設定
    set guifont=Migu\ 2M\ 14
    set guioptions-=e
elseif has('win32')
    set guifont=Cascadia_Code:h10:cANSI:qDRAFT
    set vb t_vb=
endif

" vim: set ft=vim fdm=marker ff=unix fileencoding=utf-8 :
