" vim:ft=vim:fdm=marker:

" 不可視文字
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
" brew の パスを追加
if has('vim_starting')
    set path+=/usr/local/Cellar/gcc/4.7.2/gcc/include/c++/4.7.2,/Users/rhayasd/.rbenv/versions/1.9.3-p286/lib/ruby/1.9.1/,/Users/rhayasd/Programs/**
endif
"MacVim Kaoriyaに標準で入っている辞書を無効化
if has('kaoriya')
    let g:plugin_dicwin_disable = 1
endif

filetype off
filetype plugin indent off
NeoBundle 'choplin/unite-spotlight'
NeoBundle 'rhysd/twit-buffer.vim'
filetype plugin indent on     " required!

"ctagsへのパス
let g:neocomplcache_ctags_program = '/usr/local/bin/ctags'
nnoremap <silent>[unite]l :<C-u>UniteWithInput spotlight<CR>
let g:quickrun_config.cpp.command = 'g++-4.7'
let g:quickrun_config.ruby = { 'exec' : $HOME.'/.rbenv/shims/ruby %o %s' }
" let g:quickrun_config['syntax/cpp'].command = 'g++-4.7'
" clang のライブラリ
let g:clang_user_options='-I /usr/local/include -I /usr/include -I /usr/local/Cellar/gcc/4.7.2/gcc/include/c++/4.7.2 2>/dev/null || exit 0'

" open-pdf で brew の findutils を使う
let g:unite_pdf_search_cmd = '/usr/local/bin/locate -l 30 "*%s*.pdf"'

" VimShell で g++ のエイリアス
augroup VimShellAlias
    autocmd!
    autocmd FileType vimshell call vimshell#altercmd#define('gpp', 'g++-4.7 -std=c++11 -O2 -g -Wall -Wextra')
augroup END

" Mac の辞書.appで開く {{{
" 引数に渡したワードを検索
command! -range -nargs=? MacDict      call system('open '.shellescape('dict://'.<q-args>))
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

" twit-buffer
nnoremap <Leader>tw :<C-u>Tweet<CR>
