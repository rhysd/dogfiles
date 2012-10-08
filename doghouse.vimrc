" Tweet Buffer with Ruby interface "{{{
" REQUIRE: gem install twitter
" 
function! s:update_status() "{{{
    if ! has('ruby')
        return
    endif
    if ! filereadable(expand('~/.credential.yml'))
        echoerr "There are no keys to authenticate."
        return
    endif

    ruby << EOF
    buffer = VIM::Buffer::current

    Process.fork do
        require 'rubygems'
        require 'twitter'
        require 'yaml'

        lines = []
        (1..buffer.length).each do |lnum|
            lines << buffer[lnum]
        end
        text = lines.join("\n")

        begin
            yaml = YAML.load(File.open(File.expand_path('~/.credential.yml')).read)
            Twitter::configure do |config|
                config.consumer_key = yaml['consumer_key']
                config.consumer_secret = yaml['consumer_secret']
                config.oauth_token = yaml['oauth_token']
                config.oauth_token_secret = yaml['oauth_token_secret']
            end
            Twitter::update text
            puts "success in tweet"
        rescue => e
            VIM::command <<-CMD.gsub(/^\s+/,'').split("\n").join(" | ")
                echohl Error
                echomsg 'fail to tweet!'
                echomsg '#{e.to_s}'
                echohl None
            CMD
        end
    end
EOF

    if bufwinnr('tweet') == winnr()
        bd!
    endif
endfunction
"}}}

function! Tweet() "{{{
    let bufnr = bufwinnr('tweet')
    if bufnr > 0
        execute bufnr.'wincmd w'
    else
        botright split tweet
        resize 6
        setlocal bufhidden=wipe nobuflisted noswapfile modifiable
        setlocal statusline=Tweet\ Buffer
        execute 0
        nnoremap <silent><buffer><CR>  :<C-u>call <SID>update_status()<CR>
        inoremap <silent><buffer><C-q> <C-o>:<C-u>call <SID>update_status()<CR>
        nnoremap <silent><buffer>q     :<C-u>bd!<CR>
        inoremap <silent><buffer><C-g> <C-o>:<C-u>bd!<CR>
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
"}}}
