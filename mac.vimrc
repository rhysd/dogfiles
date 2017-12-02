scriptencoding utf-8

" 不可視文字
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%

" option キーを Alt として使う．
if exists('+macmeta')
    set macmeta
endif

AutocmdFT cpp setlocal path=.,/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1,/usr/local/include,/usr/include

let g:quickrun_config.ruby = { 'exec' : $HOME . '/.rbenv/shims/ruby %o %s' }

" Mac の辞書.appで開く {{{
" 引数に渡したワードを検索
command! -range -nargs=? MacDict call system('open ' . shellescape('dict://' . <q-args>))
" カーソル下のワードを検索
command! -nargs=0 MacDictCWord call system('open ' . shellescape('dict://' . expand('<cword>')))
" 辞書.app を閉じる
command! -nargs=0 MacDictClose call system("osascript -e 'tell application \"Dictionary\" to quit'")
" 辞書にフォーカスを当てる
command! -nargs=0 MacDictFocus call system("osascript -e 'tell application \"Dictionary\" to activate'")
" キーマッピング
nnoremap <silent><Leader>do :<C-u>MacDictCWord<CR>
vnoremap <silent><Leader>do y:<C-u>MacDict<Space><C-r>*<CR>
nnoremap <silent><Leader>dc :<C-u>MacDictClose<CR>
nnoremap <silent><Leader>df :<C-u>MacDictFocus<CR>
AutocmdFT gitcommit,markdown nnoremap <buffer>K :<C-u>MacDictCWord<CR>
"}}}

" unite-ruby-require.vim
let g:unite_source_ruby_require_ruby_command = $HOME . '/.rbenv/shims/ruby'

" airline
let g:airline_left_sep = '»'
let g:airline_right_sep = '«'

" gist-vim
let g:gist_clip_command = 'pbcopy'

" ale
if !executable('llc')
    let g:ale_llvm_llc_executable = '/usr/local/opt/llvm/bin/llc'
endif

if has('gui_running')
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

        call system('open -a Safari ' . f)
        if v:shell_error
            echoerr 'Failed to open Safari: ' + f
            return
        endif

        " Need to wait Safari starting before deleting the temporary file
        sleep 1

        call delete(f)
        bwipeout!
        quit
    endfunction
    command! -nargs=0 ShowOnSafari call <SID>show_on_safari()
endif

" vim:ft=vim:fdm=marker:
