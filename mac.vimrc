" vim:ft=vim:fdm=marker:

" 不可視文字
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
" brew と rbenv のパスを追加
"MacVim Kaoriyaに標準で入っている辞書を無効化
if has('kaoriya')
    let g:plugin_dicwin_disable = 1
endif

" option キーを Alt として使う．
set macmeta

AutocmdFT cpp setlocal path=.,/usr/local/Cellar/llvm34/HEAD/lib/llvm-3.4/include/c++/v1,/Library/Developer/CommandLineTools/usr/lib/c++/v1,/usr/local/opt/gcc49/lib/gcc/x86_64-apple-darwin13.1.0/4.9.0/include/c++,/usr/local/include,/usr/include

let g:quickrun_config.cpp = {
            \ 'command' : 'clang++-3.4',
            \ 'cmdopt' : '-std=c++1y -Wall -Wextra -O2',
            \ }
let g:quickrun_config.ruby = { 'exec' : $HOME.'/.rbenv/shims/ruby %o %s' }

" open-pdf で brew の findutils を使う
let g:unite_pdf_search_cmd = '/usr/local/bin/locate -l 30 "*%s*.pdf"'

" Mac の辞書.appで開く {{{
" 引数に渡したワードを検索
command! -range -nargs=? MacDict call system('open '.shellescape('dict://'.<q-args>))
" カーソル下のワードを検索
command! -nargs=0 MacDictCWord call system('open '.shellescape('dict://'.shellescape(expand('<cword>'))))
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

" Kobito.app {{{
function! s:open_kobito(...)
    if a:0 == 0
        call system('open -a Kobito '.expand('%:p'))
    else
        call system('open -a Kobito '.join(a:000, ' '))
    endif
endfunction

" 引数のファイル(複数指定可)を Kobitoで開く
" （引数無しのときはカレントバッファを開く
command! -nargs=* Kobito call s:open_kobito(<f-args>)
" Kobito を閉じる
command! -nargs=0 KobitoClose call system("osascript -e 'tell application \"Kobito\" to quit'")
" Kobito にフォーカスを移す
command! -nargs=0 KobitoActivate call system("osascript -e 'tell application \"Kobito\" to activate'")
" QuickRun の代わりに Kobito を開く
AutocmdFT markdown nnoremap <buffer><Leader>qr :<C-u>Kobito<CR>
"}}}

" unite-ruby-require.vim
let g:unite_source_ruby_require_ruby_command = '$HOME/.rbenv/shims/ruby'

" airline
let g:airline_left_sep = '»'
let g:airline_right_sep = '«'

" clang_complete
let g:clang_library_path = '/Library/Developer/CommandLineTools/usr/lib'
let g:clang_user_options = '-std=c++1y -I /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1 -I /usr/local/include'

" vim-clang-format
if executable('clang-format-3.4')
    let g:clang_format#command = 'clang-format-3.4'
endif

" gist-vim
let g:gist_clip_command = 'pbcopy'
