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

" 非同期ツイート {{{
" REQUIRE: gem install twitter
"          write keys in ~/.credential.yml
"
function! s:update_status() "{{{
    if ! has('ruby')
        echoerr 'Ruby interface is disabled.'
        return
    endif
    if ! filereadable(expand('~/.credential.yml'))
        echoerr "There are no keys to authenticate: ~/.credential.yml"
        return
    endif

    ruby << EOF
    buffer = VIM::Buffer::current

    Process.fork do
        require 'rubygems' if RUBY_VERSION < '1.9'
        require 'twitter'
        require 'yaml'
        has_terminal_notifier = true
        begin
            require 'terminal-notifier'
        rescue LoadError
            has_terminal_notifier = false
        end

        lines = []
        (1..buffer.length).each do |lnum|
            lines << buffer[lnum]
        end
        text = lines.join("\n")
        # hooter = VIM::evaluate "exists('g:tweet_hooter') ? g:tweet_hooter : ''"
        # text += hooter unless hooter.empty?

        begin
            yaml = YAML.load(File.open(File.expand_path('~/.credential.yml')).read)
            Twitter::configure do |config|
                config.consumer_key = yaml['consumer_key']
                config.consumer_secret = yaml['consumer_secret']
                config.oauth_token = yaml['oauth_token']
                config.oauth_token_secret = yaml['oauth_token_secret']
            end
            Twitter::update text
            if has_terminal_notifier
                TerminalNotifier::notify(text, :title => 'from vim')
            else
                puts "success in tweet"
            end
        rescue => e
            if has_terminal_notifier
                TerminalNotifier::notify(e.to_s, :title => 'fail to tweet')
            else
                VIM::command <<-CMD.gsub(/^\s+/,'').gsub("\n", " | ")
                    echohl Error
                    echomsg 'fail to tweet!'
                    echomsg '#{e.to_s}'
                    echohl None
                CMD
            end
        end
    end
EOF

    if bufwinnr('tweet') == winnr()
        bd!
    endif
endfunction
"}}}

function! Tweet() "{{{
    let bufnr = bufwinnr('__tweet')
    if bufnr > 0
        execute bufnr.'wincmd w'
    else
        botright split __tweet
        resize 6
        setlocal bufhidden=wipe nobuflisted noswapfile modifiable
        setlocal statusline=Tweet\ Buffer
        execute 0
        nnoremap <silent><buffer><CR>  :<C-u>call <SID>update_status()<CR>
        inoremap <silent><buffer><C-q> <Esc>:<C-u>call <SID>update_status()<CR>
        nnoremap <silent><buffer>q     :<C-u>bd!<CR>
        inoremap <silent><buffer><C-g> <Esc>:<C-u>bd!<CR>
        if !exists('b:tweet_already_bufwrite_cmd')
            autocmd BufWriteCmd <buffer> echohl Error | echo 'type <CR> to tweet' | echohl None
            let b:tweet_already_bufwrite_cmd = 1
        endif
        set ft=tweet
    endif
    startinsert!
endfunction
"}}}

command! -nargs=0 Tweet call Tweet()
nnoremap <Leader>tw :<C-u>Tweet<CR>
" let g:tweet_hooter = " #関西Emacs"
"}}}
