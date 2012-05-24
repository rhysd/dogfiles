" vundle.vim の設定 {{{
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

" GitHub上のリポジトリ
Bundle 'Shougo/vimproc'
Bundle 'Shougo/vimshell'
Bundle 'Shougo/vimfiler'
Bundle 'Shougo/neocomplcache'
Bundle 'Shougo/neocomplcache-snippets-complete'
Bundle 'Shougo/neocomplcache-clang'
Bundle 'thinca/vim-quickrun'
Bundle 'Shougo/unite.vim'
Bundle 'tomtom/tcomment_vim'
Bundle 'h1mesuke/unite-outline'
Bundle 'tsukkee/unite-help'
Bundle 'vim-jp/vimdoc-ja'
Bundle 'jceb/vim-hier'
Bundle 'rhysd/my-vimtoggle'
Bundle 'rhysd/my-endwise'
Bundle 'kana/vim-textobj-user'
Bundle 'kana/vim-textobj-indent'
" Bundle 'kana/vim-textobj-lastpat' これと同様の効果をキーマップに設定済み
Bundle 'h1mesuke/textobj-wiw'
Bundle 'rhysd/vim-accelerate'
Bundle 'rhysd/lindapp_cpp'
Bundle 'choplin/unite-spotlight'
Bundle 'kana/vim-smartinput'
" Bundle 'kana/vim-filetype-haskell'
Bundle 'rhysd/vim-filetype-haskell'
" Bundle 'Lokaltog/vim-powerline'
" Bundle 'ujihisa/vimshell-ssh'
" Bundle 'h1mesuke/vim-alignta'
" Bundle 'ujihisa/unite-colorscheme'
" Bundle 'ujihisa/neco-look'
" Bundle 'taku-o/vim-toggle'

" vim-scripts上のリポジトリ
Bundle 'Align'
" Bundle 'errormarker.vim'
" Bundle 'endwise.vim'

" その他のgitリポジトリ
" Bundle 'git://git.wincent.com/command-t.git'

filetype plugin indent on     " required!
" }}}

" Base settings {{{
let mapleader = ','

syntax enable
"行番号表示
set number
"バックアップファイルいらない
set nobackup
"vi協調モードoff
set nocompatible
"自動インデント
set autoindent
"タブが対応する空白の数
set tabstop=4 shiftwidth=4 softtabstop=4
" set tabstop=2 shiftwidth=2 softtabstop=2
"タブの代わりにスペースを使う
set expandtab
"長い行で折り返す
set wrap
"検索が末尾まで進んだら，ファイル先頭につなげる
set wrapscan
"対応する括弧にわずかの間ジャンプする
set showmatch
"カーソルが何行何列目にあるか表示する
set ruler
"エンコーディング
set encoding=utf-8
"最下ウィンドウにステータス行が表示される時
"1: ウィンドウの数が2以上 2:常
set laststatus=2
"モードライン無効化
set modelines=0
"スクロール時の余白確保
set scrolloff=5
"いろいろスマート
set smarttab
set cindent
"大文字が入っている時のみ大文字小文字を区別
set ignorecase
set smartcase
"ビープ音OFF
set vb t_vb=
"ホワイトスペース類を表示する
set list
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
"Boostや自前ビルドgccをpathに追加
set path=.,/usr/include,/usr/local/include,/usr/local/Cellar/gcc/4.6.3/gcc/include/c++/4.6.3,/Users/rhayasd/.rbenv/versions/1.9.3-p125/lib/ruby/1.9.1/,/Users/rhayasd/programs/**
"起動時のメッセージを消す
set shortmess+=I
"起動時IMEをOFFにする
set iminsert=0 imsearch=0
"IMを使う
set noimdisable
"コマンドラインでのIM無効化
set noimcmdline
"バックスペースでなんでも消せるように
set backspace=indent,eol,start
"ファイル切替時にファイルを隠す
set hidden
"日本語ヘルプを優先的に検索
set helplang=ja,en
"OSのクリップボードを使う
set clipboard+=unnamed
"矩形選択で自由に移動する
set virtualedit+=block
"改行コードの自動認識
set fileformats=unix,dos,mac
"コマンド実行中は再描画しない
set lazyredraw
"高速ターミナル接続を行う
set ttyfast
"MacVim Kaoriyaに標準で入っている辞書を無効化
let g:plugin_dicwin_disable = 1
"insertモードから抜けるときにIMをOFFにする（GUI(MacVim)は自動的にやってくれる
"iminsert=2にすると，insertモードに戻ったときに自動的にIMの状態が復元される
if !has("gui_running")
	inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>
endif
" 補完でプレビューウィンドウを開かない
set completeopt=longest,menu
" foldingの設定
set foldenable
set foldmethod=marker
" autocmd FileType cpp,c  set foldmethod=syntax
" C++ ラベル字下げ設定
set cinoptions+=:0,g0
" 編集履歴を保存して終了する
if has('persistent_undo')
    set undodir=~/.vim/undo
    set undofile
endif
" command-line-window の縦幅
set cmdwinheight=14
" Ruby シンタックスチェック
function! s:ExecuteMake()
  if &filetype == 'ruby' && expand('%:t') !~? '^pry\d\{8}.\+\.rb'
    silent make! -c "%" | redraw!
  endif
endfunction
compiler ruby
" augroup rbsyntaxcheck
"   autocmd! BufWritePost <buffer> call s:ExecuteMake()
" augroup END
" ステータスライン
set ruf=%45(%12f%=\ %m%{'['.(&fenc!=''?&fenc:&enc).']'}\ %l-%v\ %p%%\ [%02B]%)
set statusline=%f:\ %{substitute(getcwd(),'.*/','','')}\ %m%=%{(&fenc!=''?&fenc:&enc).':'.strpart(&ff,0,1)}\ %l-%v\ %p%%\ %02B
" *.md で読み込む filetype を変更（デフォルトは modula2）
autocmd BufRead *.md set ft=markdown

" カーソル下のハイライトグループを取得
" command! -nargs=0 GetHighlightingGroup echo 'hi<' . synIDattr(synID(line('.'),col('.'),1),'name') . '> trans<' . synIDattr(synID(line('.'),col('.'),0),'name') . '> lo<' . synIDattr(synIDtrans(synID(line('.'),col('.'),1)),'name') . '>'
"}}}

" user defined commands {{{
function! RemoveSpaces()
    let s:cursor = getpos(".")
    %s/\s\+$//g
    call setpos(".", s:cursor)
    unlet s:cursor
endfunction
command! RmDust :call RemoveSpaces()
command! EditVimrc :e $MYVIMRC $MYGVIMRC
"}}}

" neocomplcacheの設定 {{{
"AutoComplPopを無効にする
let g:acp_enableAtStartup = 0
"vim起動時に有効化
let g:neocomplcache_enable_at_startup = 1
"smart_caseを有効にする．大文字が入力されるまで大文字小文字の区別をなくす
let g:neocomplcache_enable_smart_case = 1
" CamelCase補完有効化
"let g:neocomplcache_enable_camel_case_completion = 1
"_を区切りとした補完を有効にする
let g:neocomplcache_enable_underbar_completion = 1
"シンタックスをキャッシュするときの最小文字長を3に
let g:neocomplcache_min_syntax_length = 3
"日本語を収集しないようにする
if !exists('g:neocomplcache_keyword_patterns')
	let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'
"リスト表示
let g:neocomplcache_max_list = 300
let g:neocomplcache_max_keyword_width = 20
" 辞書定義
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell/command-history',
    \ }
"リストの最大幅を指定
"let g:neocomplcache_max_filename_width = 25
"ctagsへのパス
" let g:neocomplcache_ctags_program = '/opt/local/bin/ctags'
"区切り文字パターンの定義
if !exists('g:neocomplcache_delimiter_patterns')
	let g:neocomplcache_delimiter_patterns= {}
endif
let g:neocomplcache_delimiter_patterns.vim = ['#']
let g:neocomplcache_delimiter_patterns.cpp = ['::']
"インクルードパスの指定
if !exists('g:neocomplcache_include_paths')
    let g:neocomplcache_include_paths = {}
endif
let g:neocomplcache_include_paths.cpp  = '.,/usr/local/include,/usr/local/Cellar/gcc/4.6.3/gcc/include/c++/4.6.3'
let g:neocomplcache_include_paths.c    = '.,/usr/include'
let g:neocomplcache_include_paths.perl = '.,/System/Library/Perl,/Users/rhayasd/programs'
"インクルード文のパターンを指定
let g:neocomplcache_include_patterns = { 'cpp' : '^\s*#\s*include', 'perl' : '^\s*use', }
"インクルード先のファイル名の解析パターン
" let g:neocomplcache_include_exprs = {
" 	\ 'ruby' : substitute(substitute(v:fname,'::','/','g'),'$','.rb','')
" 	\ }
if !has("gui_running")
	"CUIのvimでの補完リストの色を調節する
	highlight Pmenu ctermbg=8
endif
" Enable omni completion.
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete
" autocmd FileType ruby set omnifunc=rubycomplete#Complete
" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
	let g:neocomplcache_omni_patterns = {}
endif
" let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'
"スニペットファイルのパス
" let g:neocomplcache_snippets_dir = $HOME.'/.vim/snippets'
" }}}

" Unite.vim {{{
"insertモードをデフォルトに
let g:unite_enable_start_insert = 1
" 無指定にすることで高速化
let g:unite_source_file_mru_filename_format = ''
" most recently used のリストサイズ
let g:unite_source_file_mru_limit = 100
" highlight settings
let g:unite_cursor_line_highlight = 'TabLineSel'
" let g:unite_abbr_highlight = 'TabLine'
" Unite起動時のウィンドウ分割
let g:unite_split_rule = 'rightbelow'
" }}}

" VimShellの設定 {{{
" 追加プロンプト
let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
let g:vimshell_right_prompt = 'fnamemodify(getcwd(), ":~")'
" 右プロンプト ( vcs#info は deprecated )
" let g:vimshell_right_prompt = 'vimshell#vcs#info("(%s)-[%b]", "(%s)-[%b|%a]")'
" 分割割合(%)
let g:vimshell_split_height = 25
" }}}

" vim-quickrunの設定 {{{
"<Leader>r を使わない
let g:quickrun_no_default_key_mappings = 1
" quickrun_configの初期化
if !has("g:quickrun_config")
	let g:quickrun_config = {}
endif
"C++
let g:quickrun_config.cpp = { 'command' : 'g++-4.7', 'cmdopt'  : '-std=c++11 -Wall -Wextra -O2 '}
"QuickRun 実行時のバッファの開き方
let g:quickrun_config._ = { 'outputter' : 'quickfix', 'split'   : 'rightbelow 10sp'}
" }}}

" Hier.vim {{{
"CUIだとエラーハイライトが見づらいので修正
" let g:hier_enabled = 1
if !has("gui_running")
	highlight qf_error_ucurl ctermbg=9
	let g:hier_highlight_group_qf = "qf_error_ucurl"
	let g:hier_highlight_group_loc = "qf_error_ucurl"
	highlight qf_warning_ucurl ctermbg=3
	let g:hier_highlight_group_qfw = "qf_warning_ucurl"
	let g:hier_highlight_group_locw = "qf_warning_ucurl"
	" QuickFix選択中のエラー
	highlight Search ctermbg=8
endif
" }}}

" vim-toggle.vim {{{
" let g:my_toggle_pairs = {}
" let g:my_toggle_pairs = {
" 			\'and':'or', 'or':'and',
" 			\'&&':'||', '||':'&&',
" 			\'++':'--','--','++',
" 			\'==':'!=','!=':'==',
" 			\'<=':'>=','>=':'<=',
" 			\'.':'->','->':'.',
" 			\'const&':'&','&':'const&',
" 			\'class':'struct','struct':'class',
" 			\'boost':'std','std':'boost',
" 			\'top':'right','right':'bottom','bottom':'left','left':'top'
" 			\}
" }}}

" VimFilerの設定 {{{
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_safe_mode_by_default = 0
let g:vimfiler_execute_file_list = { 'c' : 'vim',  'h' : 'vim',  'cpp' : 'vim',  'hpp' : 'vim', 'cc' : 'vim',  'rb' : 'vim', 'txt' : 'vim', 'pdf' : 'open', 'vim' : 'vim' }
" }}}

" neocomplecache-clang {{{
" libclangを使う
let g:neocomplcache_clang_use_library = 1
" ライブラリへのパス
let g:neocomplcache_clang_library_path = '/Developer/usr/clang-ide/lib'
" clangへのパス
let g:neocomplcache_clang_executable_path = '/usr/bin'
" let g:neocomplcache_clang_auto_options = ''
" clangのコマンドオプション
let g:neocomplcache_clang_user_options =
    \'-I /usr/local/Cellar/gcc/4.6.3/gcc/include '.
    \'-I /usr/include/c++/4.2.1 '.
    \'-I /usr/include '.
    \'-I /usr/local/Cellar/boost/1.48.0/include '
" }}}

" lindapp_cpp {{{
let g:neocomplcache_snippets_dir = $HOME.'/.vim/bundle/lindapp_cpp/snippets'
" }}}

" vim-smartinput"{{{
" call smartinput#define_default_rules()

" 括弧内のスペース
" call smartinput#map_to_trigger('i', '(', '(', '(')
call smartinput#define_rule({
\   'at':       '(\%#)',
\   'char':     '<Space>',
\   'input':    '<Space><Space><Left>',
\   })

call smartinput#map_to_trigger('i', '<Space>', '<Space>', '<Space>')
call smartinput#define_rule({
\   'at':       '( \%# )',
\   'char':     '<BS>',
\   'input':    '<Del><BS>',
\   })

call smartinput#define_rule({
\   'at':       '{\%#}',
\   'char':     '<Space>',
\   'input':    '<Space><Space><Left>',
\   })

call smartinput#define_rule({
\   'at':       '{ \%# }',
\   'char':     '<BS>',
\   'input':    '<Del><BS>',
\   })

call smartinput#define_rule({
\   'at':       '\[\%#\]',
\   'char':     '<Space>',
\   'input':    '<Space><Space><Left>',
\   })

call smartinput#define_rule({
\   'at':       '\[ \%# \]',
\   'char':     '<BS>',
\   'input':    '<Del><BS>',
\   })

" Ruby 文字列内変数埋め込み
call smartinput#map_to_trigger('i', '#', '#', '#')
call smartinput#define_rule({
\   'at': '\%#',
\   'char': '#',
\   'input': '#{}<Left>',
\   'filetype': ['ruby'],
\   'syntax': ['Constant', 'Special'],
\   })

" Ruby ブロック引数 ||
call smartinput#map_to_trigger('i', '<Bar>', '<Bar>', '<Bar>')
call smartinput#define_rule({
\   'at': '\({\|\<do\>\)\s*\%#',
\   'char': '<Bar>',
\   'input': '<Bar><Bar><Left>',
\   'filetype': ['ruby'],
\    })

" : で :: を一気に入力する．inoremap : :: だと次の2回押した場合の対処が効かなくなる．
call smartinput#map_to_trigger('i', ':', ':', ':')
call smartinput#define_rule({
\   'at': '\%#',
\   'char': ':',
\   'input': '::',
\   'filetype': ['cpp'],
\   })

" 癖で2回コロンを押しても大丈夫
call smartinput#define_rule({
\   'at': '::\%#',
\   'char': ':',
\   'input': '',
\   'filetype': ['cpp'],
\   })

" テンプレート内のスペース
call smartinput#map_to_trigger('i', '<', '<', '<')
call smartinput#define_rule({
\   'at':       '<\%#>',
\   'char':     '<Space>',
\   'input':    '<Space><Space><Left>',
\   'filetype': ['cpp'],
\   })
call smartinput#define_rule({
\   'at':       '< \%# >',
\   'char':     '<BS>',
\   'input':    '<Del><BS>',
\   'filetype': ['cpp'],
\   })

" クラス定義の場合は末尾に;を付け忘れないようにする
call smartinput#define_rule({
\   'at': '\(\<struct\>\|\<class\>\)\s*\w*\s*{\%#}',
\   'char': '<CR>',
\   'input': '<Right>;<Left><CR><CR><Up>',
\   'filetype': ['cpp'],
\   })

"}}}

" キーマップの設定 {{{
" Base Settings {{{
" ; と : をスワップ
noremap ; :
noremap : ;
"insertモードから抜ける
inoremap jj <esc>
inoremap <c-j> j
" yの挙動はy$のほうが自然な気がする
nnoremap y y$
" 縦方向は論理移動する
nnoremap j gj
nnoremap k gk
"esc->escで検索結果をクリア
nnoremap <silent><esc><esc> :<c-u>nohlsearch<cr><esc>
"行頭・行末の移動
nnoremap <tab> g
vnoremap <tab> g
nnoremap 0 ^
vnoremap 0 ^
nnoremap <c-0> 0
vnoremap <c-0> 0
nnoremap - $
vnoremap - $
" q:は誤爆しやすい
nnoremap q; q:
nnoremap <c-:> q:
nnoremap q: :q
" insertモードでもquit
inoremap <c-q><c-q> <esc>:wqa<cr>
" insertモードでもcmdmode
inoremap <c-:> <esc>:
" 空行挿入
nnoremap <silent><space> :<c-u>call append(expand('.'), '')<cr>j
"ヘルプ表示
nnoremap <leader>vh :vert bo help<space>
"insertモード時はemacsライクなバインディング．ポップアップが出ないように移動．
inoremap <c-e> <end>
vnoremap <c-e> <end>
cnoremap <c-e> <end>
inoremap <c-a> <home>
vnoremap <c-a> <home>
cnoremap <c-a> <home>
inoremap <expr><c-n> pumvisible() ? "\<c-y>\<down>" : "\<down>"
inoremap <expr><c-p> pumvisible() ? "\<c-y>\<up>" : "\<up>"
inoremap <expr><c-b> pumvisible() ? "\<c-y>\<left>" : "\<left>"
inoremap <expr><c-f> pumvisible() ? "\<c-y>\<right>" : "\<right>"
" inoremap <c-n> <down>
" inoremap <c-p> <up>
" inoremap <c-b> <left>
" inoremap <c-f> <right>
inoremap <c-d> <del>
cnoremap <c-d> <del>
inoremap <c-k> <c-o>d
cnoremap <c-k> <c-o>d
"バッファ切り替え
nnoremap <silent><c-n>   :<c-u>bnext<cr>
nnoremap <silent><c-p>   :<c-u>bprevious<cr>
"visualモード時にvで行末まで選択する
vnoremap v $h
"ctrl-hjklでウィンドウ移動．横幅が小さすぎる場合は自動でリサイズする．
function! s:good_width()
    if winwidth(0) < 84
        vertical resize 84
    endif
endfunction
nnoremap <silent><c-j> <c-w>j:call <sid>good_width()<cr>
nnoremap <silent><c-h> <c-w>h:call <sid>good_width()<cr>
nnoremap <silent><c-l> <c-w>l:call <sid>good_width()<cr>
nnoremap <silent><c-k> <c-w>k:call <sid>good_width()<cr>
"ruby新規ファイルを開いたときに書きこむ
autocmd bufnewfile *.rb 0r ~/.vim/skeletons/ruby.skel
"<cr>の挙動
nnoremap <cr> i<cr><esc>
"<bs>の挙動
nnoremap <bs> i<bs><esc>
"コマンドラインモードでのカーソル移動
cnoremap <c-f> <right>
cnoremap <c-b> <left>
"_で次の_の手前まで
onoremap _ vf_h
" カーソルキーでの上下移動
nnoremap <silent><down>  <c-w>-
nnoremap <silent><up>    <c-w>+
nnoremap <silent><left>  <c-w><
nnoremap <silent><right> <c-w>>
" ペーストした文字列をビジュアルモードで選択
nnoremap <expr>gp '`['.strpart(getregtype(),0,1).'`]'
" 日付の挿入
inoremap <c-x>date <c-r>=strftime('%y/%m/%d(%a) %h:%m')<cr>
nnoremap <leader>date :r<space>!date<space>+'\%y/\%m/\%d(\%a)<space>\%h:\%m'<cr>
" text-obj-lastpat:sでマッチした部分をtextobjに
nnoremap di/ d//e<cr>
nnoremap ci/ c//e<cr>
nnoremap yi/ y//e<cr>
" タブの設定
nnoremap <leader>te :tabnew<cr>
nnoremap <leader>tn :tabnext<cr>
nnoremap <leader>tp :tabprevious<cr>
nnoremap <leader>tc :tabclose<cr>
" rubyのキーマップ
autocmd filetype ruby inoremap <buffer><c-s> self.
" 貼り付けはインデントを揃える
" nnoremap p ]p
" }}}

"vimshellの設定 {{{
nmap <expr><leader>vs "\<plug>(vimshell_split_switch)"

"neocomplcacheの設定
imap      <c-s>       <plug>(neocomplcache_snippets_expand)
smap      <c-s>       <plug>(neocomplcache_snippets_expand)
inoremap  <expr><c-g> neocomplcache#undo_completion()
"inoremap <expr><c-l> neocomplcache#complete_common_string()
"スニペット展開候補があれば展開を，そうでなければbash風補完を．
imap <expr><c-l> neocomplcache#sources#snippets_complete#expandable() ? "\<plug>(neocomplcache_snippets_expand)" : neocomplcache#complete_common_string()
" <cr>: close popup and save indent.
inoremap <expr><cr>  pumvisible() ? neocomplcache#smart_close_popup()."\<cr>" : "\<cr>"
" <tab>: completion
inoremap <expr><tab>  pumvisible() ? "\<c-n>" : "\<tab>"
"スニペットがあればそれを展開．なければ通常の挙動をするtabキー
" imap <expr><tab> neocomplcache#sources#snippets_complete#expandable() ? "\<plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<c-n>" : "\<tab>"
" <c-h>, <bs>: close popup and delete backword char.
" inoremap <expr><c-h> neocomplcache#smart_close_popup()."\<c-h>"
" inoremap <expr><bs> neocomplcache#smart_close_popup()."\<c-h>"
inoremap <expr><c-y> neocomplcache#close_popup()
" }}}

"unite.vimのキーマップ {{{
"insertモード時はc-gでいつでもバッファを閉じられる（絞り込み欄が空の時はc-hでもok）
autocmd filetype unite imap <buffer> <c-g> <plug>(unite_exit)
"ファイル上にカーソルがある時，pでプレビューを見る
autocmd filetype unite inoremap <buffer><expr> p unite#smart_map("p", unite#do_action('preview'))
"c-xでクイックマッチ
autocmd filetype unite imap <buffer> <c-x> <plug>(unite_quick_match_default_action)
"lでデフォルトアクションを実行
autocmd filetype unite nmap <buffer> l <plug>(unite_do_default_action)
autocmd filetype unite imap <buffer><expr> l unite#smart_map("l", unite#do_action(unite#get_current_unite().context.default_action))
"増えすぎてアレなら <leader>ua などに置き換える．そのときはnnoremap <leader>u <nop>を忘れないようにする．
"バッファを開いた時のパスを起点としたファイル検索
" nnoremap <silent> <leader>f  :<c-u>unitewithbufferdir -buffer-name=files file<cr>
"バッファ一覧
nnoremap <silent> <leader>ub  :<c-u>unite -no-start-insert buffer<cr>
"ブックマークしたファイル/ディレクトリ
nnoremap <silent> <leader>ub  :<c-u>unite -no-start-insert bookmark<cr>
"最近使用したファイル
nnoremap <silent> <leader>um  :<c-u>unite -no-start-insert file_mru directory_mru<cr>
nnoremap <silent> <leader>m  :<c-u>unite -no-start-insert file_mru directory_mru<cr>
"プログラミングにおけるアウトラインの表示
nnoremap <silent> <leader>uo  :<c-u>unite outline -vertical -no-start-insert<cr>
"grep検索．
nnoremap <silent> <leader>ug  :<c-u>unite -no-start-insert grep<cr>
"yank履歴
nnoremap <silent> <leader>uy  :<c-u>unite -no-start-insert history/yank<cr>
"find
nnoremap <silent> <leader>uf  :<c-u>unite -no-start-insert find<cr>
"helpを引く．絞り込み初期は候補が膨大になるのでワードを先に入力
nnoremap <silent> <leader>uh  :<c-u>unitewithinput -no-start-insert help<cr>
"uniteバッファの復元
nnoremap <silent> <leader>ur  :<c-u>uniteresume<cr>
"spotlight の利用
if has('mac')
    nnoremap <silent> <leader>us :<c-u>unite spotlight<cr>
endif
" }}}

"quickrunのキーマップ {{{
nnoremap <leader>q  <nop>
nmap     <silent><leader>qr <plug>(quickrun):<c-u>copen<cr>
nnoremap <leader>qr :<c-u>quickrun<space>
nnoremap <leader>qq :<c-u>cope<cr>
"quickfixバッファを閉じると同時にエラー表示も消す
" autocmd filetype qf nnoremap <buffer><silent> q :q<cr>:hierclear<cr>
autocmd filetype qf nnoremap <buffer><silent> q :q<cr>
autocmd filetype qf nnoremap <buffer><silent> j :cn<cr>
autocmd filetype qf nnoremap <buffer><silent> k :cp<cr>
" }}}

"tcomment.vimのキーマップ {{{
nnoremap <leader>c :tcomment<cr>
vnoremap <leader>c :tcomment<cr>
vnoremap <leader>c :tcommentblock<cr>
" }}}

"endwise.vimのキーマップ {{{
autocmd filetype ruby,vim imap <buffer> <expr><cr>  pumvisible() ? neocomplcache#smart_close_popup() . "\<cr>\<plug>discretionaryend" : "\<cr>\<plug>discretionaryend"
"
" }}}

"vim-toggleのキーマップ {{{
" nmap <silent><c-t> <plug>mytogglen
" }}}

" vimfiler.vim のキーマップ {{{
nnoremap <leader>f :vimfiler<cr>
nnoremap <leader>f :vimfiler<space>-no-quit<cr>
" }}}

" textobj-wiw のキーマップ {{{
let g:textobj_wiw_no_default_key_mappings = 1 " デフォルトキーマップの解除
omap ac <plug>(textobj-wiw-a)
omap ic <plug>(textobj-wiw-i)
" }}}

" lindapp_cpp の キーマップ {{{
autocmd filetype cpp call lindapp_cpp#my_cpp_mapping()
autocmd filetype cpp inoremap <silent><buffer><expr><cr> lindapp_cpp#expand_brace()."\<cr>"
autocmd filetype cpp nmap <silent><buffer><leader>dt <plug>lindapp_cpp_return_type
" }}}
" }}}

" autocmd Filetype haskell syntax match lambda /[[]]/ transparent conceal cchar=λ
