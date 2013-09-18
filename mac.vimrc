" vim:ft=vim:fdm=marker:

" 不可視文字
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
" brew と rbenv のパスを追加
if has('vim_starting')
    set path+=/usr/local/Cellar/gcc48/4.8.0/gcc/include/c++/4.8.0,/Users/rhayasd/.rbenv/versions/1.9.3-p362/lib/ruby/1.9.1/,/Users/rhayasd/Programs/**
endif
"MacVim Kaoriyaに標準で入っている辞書を無効化
if has('kaoriya')
    let g:plugin_dicwin_disable = 1
endif

filetype off
filetype plugin indent off
NeoBundle 'choplin/unite-spotlight'
filetype plugin indent on     " required!

" option キーを Alt として使う．
set macmeta

"ctagsへのパス
let g:neocomplcache_ctags_program = '/usr/local/bin/ctags'
nnoremap <silent>[unite]l :<C-u>UniteWithInput spotlight<CR>
let g:quickrun_config.cpp.command = 'g++-4.8'
let g:quickrun_config.ruby = { 'exec' : $HOME.'/.rbenv/shims/ruby %o %s' }
" let g:quickrun_config['syntax/cpp'].command = 'g++-4.8'
" clang のライブラリ
let g:clang_user_options='-stdlib=libc++ -I /usr/local/include -I /usr/include -I /usr/local/Cellar/gcc48/4.8.1/gcc/include/c++/4.8.1 2>/dev/null || exit 0'

" open-pdf で brew の findutils を使う
let g:unite_pdf_search_cmd = '/usr/local/bin/locate -l 30 "*%s*.pdf"'

" VimShell で g++ のエイリアス
autocmd MyVimrc FileType vimshell call vimshell#set_alias('gpp', 'g++-4.8 -std=c++11 -O2 -g -Wall -Wextra')

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
autocmd MyVimrc FileType markdown nnoremap <buffer><Leader>qr :<C-u>Kobito<CR>
"}}}

" unite-ruby-require.vim
let g:unite_source_ruby_require_ruby_command = '$HOME/.rbenv/shims/ruby'

" airline
let g:airline_left_sep = '»'
let g:airline_right_sep = '«'
