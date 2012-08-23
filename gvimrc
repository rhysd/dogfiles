" helpers
let s:has_linux = !has('mac') && has('unix')

" GUI のみで読み込むプラグイン

NeoBundleSource unite-colorscheme

" 基本設定 {{{
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

" GUI autocmds
augroup GuiAtStart
    autocmd!
    autocmd VimEnter * :VimFiler
augroup END

nnoremap <Space>C :<C-u>Unite -auto-preview colorscheme<CR>
" }}}

" specific platform settings {{{
if has('mac')

    set background=light
    colorscheme solarized_sl "カラースキーマの指定
    set fuoptions=maxvert,maxhorz
    set guifont=Ricty:h16
    " F12 で透過率を3段階に切り替え(0, 40, 80)
    set transparency=0 "初期背景透過0%
    nnoremap <expr><F12> &transparency+40 > 100 ? ":set transparency=0\<CR>" : ":let &transparency=&transparency+40\<CR>"
    " 常にフルスクリーン
    augroup GuiMac
        autocmd!
        autocmd GUIEnter * set fullscreen
    augroup END

elseif s:has_linux

    set background=dark
    colorscheme molokai
    set guifont=Ricty\ 16

    " GUI オンリーなプラグインのロード
    NeoBundleSource open-browser.vim
    NeoBundleSource twibill.vim
    NeoBundleSource webapi-vim
    NeoBundleSource TweetVim
    NeoBundleSource neco-tweetvim

    " TweetVim の設定 "{{{
    let g:tweetvim_display_icon = 1

    nnoremap <Leader>tw :<C-u>TweetVimHomeTimeline<CR>
    nnoremap <Leader>say :<C-u>TweetVimSay<CR>

    augroup TweetVimMapping
        autocmd!
        autocmd FileType tweetvim_say nnoremap <buffer><silent><C-g> :<C-u>q!<CR>
        autocmd FileType tweetvim_say inoremap <buffer><silent><C-g> <C-o>:<C-u>q!<CR><Esc>
        autocmd FileType tweetvim_say imap <buffer><C-CR> <Esc><Plug>(tweetvim_action_enter)
        autocmd FileType tweetvim nnoremap <buffer>s :<C-u>TweetVimSay<CR>
        autocmd FileType tweetvim nnoremap <buffer>m :<C-u>TweetVimMentions<CR>
        autocmd FileType tweetvim nmap <buffer>c <Plug>(tweetvim_action_in_reply_to)
        autocmd FileType tweetvim nnoremap <buffer>t :<C-u>Unite tweetvim -no-start-insert<CR>
        autocmd FileType tweetvim nmap <buffer><Space> <Plug>(tweetvim_action_reload)
        autocmd FileType tweetvim nmap <buffer>f <Plug>(tweetvim_action_page_next)
        autocmd FileType tweetvim nmap <buffer>b <Plug>(tweetvim_action_page_previous)
        autocmd FileType tweetvim nunmap <buffer>ff
        autocmd FileType tweetvim nunmap <buffer>bb
    augroup END
    " }}}

endif
" }}}
