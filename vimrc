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
set path=.,/usr/include,/usr/local/include,/usr/local/Cellar/gcc/4.6.2/gcc/include/c++/4.6.2,/Users/rhayasd/programs/**
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
" カーソル下のハイライトグループを取得
" command! -nargs=0 GetHighlightingGroup echo 'hi<' . synIDattr(synID(line('.'),col('.'),1),'name') . '> trans<' . synIDattr(synID(line('.'),col('.'),0),'name') . '> lo<' . synIDattr(synIDtrans(synID(line('.'),col('.'),1)),'name') . '>'
"}}}

" user defined commands {{{
command! RmDust :%s/\s\s*$//g | :nohlsearch
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
let g:neocomplcache_include_paths.cpp  = '.,/usr/local/include,/usr/local/Cellar/gcc/4.6.2/gcc/include/c++/4.6.2'
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
let g:neocomplcache_snippets_dir = $HOME.'/.vim/snippets'
" 最大候補数
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
" }}}

" VimShellの設定 {{{
" 追加プロンプト
let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
" 右プロンプト
let g:vimshell_right_prompt = 'vimshell#vcs#info("(%s)-[%b]", "(%s)-[%b|%a]")'
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
let g:quickrun_config.cpp = { 'command' : 'g++-4.6.2', 'cmdopt'  : '-std=c++0x -Wall -Wextra -O2 '}
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
let g:vimfiler_execute_file_list = { 'c' : 'vim',  'h' : 'vim',  'cpp' : 'vim',  'hpp' : 'vim', 'cc' : 'vim',  'rb' : 'vim', 'sh' : 'vim', 'pdf' : 'open', 'vim' : 'vim' }
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
    \'-I /usr/local/Cellar/gcc/4.6.2/gcc/include '.
    \'-I /usr/include/c++/4.2.1 '.
    \'-I /usr/include '.
    \'-I /usr/local/Cellar/boost/1.48.0/include '
" }}}

" vim-powerlineの設定 {{{
" キャッシュファイルの保存場所
" let g:Powerline_cache_file=expand('~/.Powerline.cache')
let g:Powerline_cache_file=''

" }}}

" キーマップの設定 {{{
" Base {{{
"insertモードから抜ける
inoremap jj <ESC>
inoremap <C-j> j
" Yの挙動はy$のほうが自然な気がする
nnoremap Y y$
" 縦方向は論理移動する
nnoremap j gj
nnoremap k gk
"Esc->Escで検索結果をクリア
nnoremap <silent><ESC><ESC> :nohlsearch<CR><ESC>
"行頭・行末の移動
nnoremap - $
vnoremap - $
nnoremap ^ 0
vnoremap ^ 0
" ffで直前のfを再実行
nnoremap ff ;
vnoremap ff ;
" 空行挿入
nnoremap <silent>; :<C-u>call append(expand('.'), '')<CR>j
"ヘルプ表示
nnoremap <Leader>vh :vert bo help<Space>
"insertモード時はEmacsライクなバインディング．ポップアップが出ないように移動．
inoremap <C-e> <END>
inoremap <C-e> <END>
cnoremap <C-e> <END>
cnoremap <C-a> <HOME>
inoremap <C-a> <HOME>noremap <C-a> <HOME>
inoremap <expr><C-n> pumvisible() ? "\<C-y>\<Down>" : "\<Down>"
inoremap <expr><C-p> pumvisible() ? "\<C-y>\<Up>" : "\<Up>"
inoremap <expr><C-b> pumvisible() ? "\<C-y>\<Left>" : "\<Left>"
inoremap <expr><C-f> pumvisible() ? "\<C-y>\<Right>" : "\<Right>"
" inoremap <C-n> <Down>
" inoremap <C-p> <Up>
" inoremap <C-b> <Left>
" inoremap <C-f> <Right>
inoremap <C-d> <Del>
inoremap <C-k> <C-o>D
"バッファ切り替え
nnoremap <silent><C-n>   :<C-u>bnext<CR>
nnoremap <silent><C-p>   :<C-u>bprevious<CR>
"Visualモード時にvで行末まで選択する
vnoremap v $h
"CTRL-hjklでウィンドウ移動．横幅が小さすぎる場合は自動でリサイズする．
function! s:good_width()
    if winwidth(0) < 84
        vertical resize 84
    endif
endfunction
nnoremap <C-j> <C-w>j:call <SID>good_width()<CR>
nnoremap <C-h> <C-w>h:call <SID>good_width()<CR>
nnoremap <C-l> <C-w>l:call <SID>good_width()<CR>
nnoremap <C-k> <C-w>k:call <SID>good_width()<CR>
"Ruby新規ファイルを開いたときに書きこむ
autocmd BufNewFile *.rb 0r ~/.vim/skeletons/ruby.skel
"Spaceの挙動
nnoremap <Space> i<Space><ESC>l
"<CR>の挙動
nnoremap <CR> i<CR><ESC>
"<TAB>の挙動
nnoremap <TAB> >>
"<BS>の挙動
nnoremap <BS> i<BS><ESC>
"コマンドラインモードでのカーソル移動
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
"_で次の_の手前まで
onoremap _ vf_h
" カーソルキーでの上下移動
nnoremap <silent><Down>  <C-w>-
nnoremap <silent><Up>    <C-w>+
nnoremap <silent><Left>  <C-w><
nnoremap <silent><Right> <C-w>>
" ペーストした文字列をビジュアルモードで選択
nnoremap <expr>gp '`['.strpart(getregtype(),0,1).'`]'
" 日付の挿入
inoremap <C-x>date <C-r>=strftime('%Y/%m/%d(%a) %H:%M')<CR>
nnoremap <Leader>date :r<Space>!date<Space>+'\%Y/\%m/\%d(\%a)<Space>\%H:\%M'<CR>
" text-obj-lastpat
nnoremap di/ d//e<CR>
nnoremap ci/ c//e<CR>
nnoremap yi/ y//e<CR>
" Tabの設定
nnoremap <Leader>te :tabnew<CR>
nnoremap <Leader>tn :tabnext<CR>
nnoremap <Leader>tp :tabprevious<CR>
nnoremap <Leader>tc :tabclose<CR>
" }}}

"VimShellの設定 {{{
nmap <expr><Leader>vs "\<Plug>(vimshell_split_switch)"

"neocomplcacheの設定
imap      <C-s>       <Plug>(neocomplcache_snippets_expand)
smap      <C-s>       <Plug>(neocomplcache_snippets_expand)
inoremap  <expr><C-g> neocomplcache#undo_completion()
"inoremap <expr><C-l> neocomplcache#complete_common_string()
"スニペット展開候補があれば展開を，そうでなければbash風補完を．
imap <expr><C-l> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : neocomplcache#complete_common_string()
" <CR>: close popup and save indent.
inoremap <expr><CR>  pumvisible() ? neocomplcache#smart_close_popup()."\<CR>" : "\<CR>"
" <TAB>: completion
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
"スニペットがあればそれを展開．なければ通常の挙動をするTABキー
" imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y> neocomplcache#close_popup()
inoremap <expr><C-e> neocomplcache#cancel_popup()
" }}}

"Unite.vimのキーマップ {{{
"insertモード時はC-gでいつでもバッファを閉じられる（絞り込み欄が空の時はC-hでもOK）
autocmd FileType unite imap <buffer> <C-g> <Plug>(unite_exit)
"ファイル上にカーソルがある時，pでプレビューを見る
autocmd FileType unite inoremap <buffer><expr> p unite#smart_map("p", unite#do_action('preview'))
"C-xでクイックマッチ
autocmd FileType unite imap <buffer> <C-x> <Plug>(unite_quick_match_default_action)
"lでデフォルトアクションを実行
autocmd FileType unite nmap <buffer> l <Plug>(unite_do_default_action)
autocmd FileType unite imap <buffer><expr> l unite#smart_map("l", unite#do_action(unite#get_current_unite().context.default_action))
"増えすぎてアレなら <Leader>ua などに置き換える．そのときはnnoremap <Leader>u <Nop>を忘れないようにする．
"すべてを表示
nnoremap <silent> <Leader>a  :<C-u>Unite -buffer-name=files buffer file_mru bookmark file outline history/yank<CR>
"バッファを開いた時のパスを起点としたファイル検索
" nnoremap <silent> <Leader>f  :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
"バッファ一覧
nnoremap <silent> <Leader>b  :<C-u>Unite -no-start-insert buffer<CR>
"ブックマークしたファイル/ディレクトリ
nnoremap <silent> <Leader>B  :<C-u>Unite -no-start-insert bookmark<CR>
"最近使用したファイル
nnoremap <silent> <Leader>m  :<C-u>Unite -no-start-insert file_mru directory_mru<CR>
"プログラミングにおけるアウトラインの表示
nnoremap <silent> <Leader>o  :<C-u>Unite outline<CR>
"grep検索．
nnoremap <silent> <Leader>g  :<C-u>Unite -no-start-insert grep<CR>
"yank履歴
nnoremap <silent> <Leader>y  :<C-u>Unite -no-start-insert history/yank<CR>
"helpを引く．絞り込み初期は候補が膨大になるのでワードを先に入力
nnoremap <silent> <Leader>h  :<C-u>UniteWithInput -no-start-insert help<CR>
"Uniteバッファの復元
nnoremap <silent> <Leader>r  :<C-u>UniteResume<CR>
" }}}

"QuickRunのキーマップ {{{
nnoremap <Leader>q  <Nop>
nmap     <silent><Leader>qr <Plug>(quickrun):copen<CR>
nnoremap <Leader>qR :w<CR>:QuickRun<Space>
"QuickFixバッファを閉じると同時にエラー表示も消す
" autocmd FileType qf nnoremap <buffer><silent> q :q<CR>:HierClear<CR>
autocmd FileType qf nnoremap <buffer><silent> q :q<CR>
autocmd FileType qf nnoremap <buffer><silent> j :cn<CR>
autocmd FileType qf nnoremap <buffer><silent> k :cp<CR>
" }}}

"tcomment.vimのキーマップ {{{
nnoremap <Leader>c :TComment<CR>
vnoremap <Leader>c :TComment<CR>
vnoremap <Leader>C :TCommentBlock<CR>
" }}}

"endwise.vimのキーマップ {{{
autocmd FileType ruby imap <buffer> <expr><CR>  pumvisible() ? neocomplcache#smart_close_popup() . "\<CR>\<Plug>DiscretionaryEnd" : "\<CR>\<Plug>DiscretionaryEnd"
" }}}

"vim-toggleのキーマップ {{{
" nmap <silent><C-t> <Plug>MyToggleN
" }}}

" vimfiler.vim のキーマップ {{{
nnoremap <Leader>f :VimFiler<CR>
nnoremap <Leader>F :VimFiler<Space>-no-quit<CR>
" }}}

" textobj-wiw のキーマップ {{{
let g:textobj_wiw_no_default_key_mappings = 1 " デフォルトキーマップの解除
omap ac <Plug>(textobj-wiw-a)
omap ic <Plug>(textobj-wiw-i)
" }}}
" }}}

" vundle.vim の設定 {{{
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required!
Bundle 'gmarik/vundle'

" My Bundles here:

" original repos on github
Bundle 'Shougo/vimproc'
Bundle 'Shougo/vimshell'
Bundle 'Shougo/vimfiler'
Bundle 'Shougo/neocomplcache'
Bundle 'thinca/vim-quickrun'
Bundle 'Shougo/unite.vim'
Bundle 'tomtom/tcomment_vim'
Bundle 'h1mesuke/unite-outline'
Bundle 'tsukkee/unite-help'
Bundle 'vim-jp/vimdoc-ja'
Bundle 'jceb/vim-hier'
Bundle 'rhysd/my-vimtoggle'
Bundle 'rhysd/my-endwise'
Bundle 'Shougo/neocomplcache-clang'
Bundle 'kana/vim-textobj-user'
Bundle 'kana/vim-textobj-indent'
" Bundle 'kana/vim-textobj-lastpat' これと同様の効果をキーマップに設定済み
Bundle 'h1mesuke/textobj-wiw'
" if !has('gui_running')
" Bundle 'Lokaltog/vim-powerline'
" endif
" Bundle 'ujihisa/vimshell-ssh'
" Bundle 'h1mesuke/vim-alignta'
" Bundle 'ujihisa/unite-colorscheme'
" Bundle 'ujihisa/neco-look'
" Bundle 'taku-o/vim-toggle'
" vim-scripts repos
Bundle 'surround.vim'
Bundle 'Align'
" Bundle 'errormarker.vim'
" Bundle 'endwise.vim'

" non github repos
" Bundle 'git://git.wincent.com/command-t.git'

filetype plugin indent on     " required!
" }}}
