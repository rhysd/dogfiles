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

" GUI autocmds
Autocmd VimEnter * call <SID>vimfiler_at_start()

function! s:vimfiler_at_start()
    if empty(bufname('%'))
        VimFilerCurrentDir
    endif
endfunction

" IndentGuides はインデント指向言語を扱う時だけ読み込む "{{{
augroup IndentGuidesAutoCmd
    autocmd!
augroup END
autocmd IndentGuidesAutoCmd FileType haskell,python,haml call s:prepare_indent_guides()

function! s:prepare_indent_guides()

    " 一度読みこめばもういらないのでリセット
    augroup IndentGuidesAutoCmd
        autocmd!
    augroup END

    NeoBundleSource vim-indent-guides
    let g:indent_guides_guide_size = 1
    let g:indent_guides_auto_colors = 1
    if !has('gui_running') && &t_Co >= 256
        let g:indent_guides_auto_colors = 0
        autocmd IndentGuidesAutoCmd VimEnter,Colorscheme * hi IndentGuidesOdd  ctermbg=233
        autocmd IndentGuidesAutoCmd VimEnter,Colorscheme * hi IndentGuidesEven ctermbg=240
    endif
    call indent_guides#enable()
endfunction
"}}}

let g:haskell_conceal = 1

if isdirectory(expand('~/.cabal/bin'))
    let $PATH .= ':'.expand('~/.cabal/bin')
endif

" ファイルを俯瞰する :Overview {{{
let s:overview_mode = 0
function! s:overview_toggle()
    if s:overview_mode
        let &l:readonly = s:overview_original_readonly
        execute 'set guifont='.s:overview_guifont_prefix.s:overview_font_size
        silent! execute 'sign unplace 1 buffer=' . winbufnr(0)
        sign undefine OverviewSignSymbol
        highlight clear OverviewSignColor
        let s:overview_mode = 0
    else
        let pos = getpos('.')
        let [start, last] = [line('w0'), line('w$')]
        try
            normal! gg
            let screen_height = line('w$')
            if screen_height == line('$')
                return
            endif
            let s:overview_guifont_prefix = escape(substitute(&guifont, '\d\+$', '', ''), ' \')
            let s:overview_font_size = str2nr(matchstr(&guifont, '\d\+$'))
            if s:overview_guifont_prefix == '' || s:overview_font_size == 0
                echoerr 'Error occured'
                return
            endif
            sign define OverviewSignSymbol linehl=OverviewSignColor texthl=OverviewSignColor
            for l in range(start, last)
                execute 'sign place 1 line='.l.' name=OverviewSignSymbol buffer='.winbufnr(0)
            endfor
            if &bg == "dark"
                highlight OverviewSignColor ctermfg=white ctermbg=blue guifg=white guibg=RoyalBlue3
            else
                highlight OverviewSignColor ctermbg=white ctermfg=blue guibg=grey guifg=RoyalBlue3
            endif
            let s:overview_original_readonly = &l:readonly
            let font_size = s:overview_font_size * screen_height / line('$')
            let font_size = font_size < 1 ? 1 : font_size
            echom font_size
            execute 'set guifont='.s:overview_guifont_prefix.font_size
            setlocal readonly
            let s:overview_mode = 1
        finally
            call setpos('.', pos)
        endtry
    endif
endfunction
command! -nargs=0 Overview call <SID>overview_toggle()
nnoremap <C-w>O :<C-u>Overview<CR>
" }}}

" プラットフォーム依存な設定の読み込み
if has('mac')
    call SourceIfExist($HOME.'/.mac.gvimrc')
elseif has('unix')
    call SourceIfExist($HOME.'/.linux.gvimrc')
endif

call SourceIfExist($HOME.'/.local.gvimrc')

" vim: set ft=vim fdm=marker ff=unix fileencoding=utf-8 :
