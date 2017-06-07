" vim: set ft=vim fenc=utf8 ff=unix ts=2 sts=2 sw=2:
"------------------------------------------------------------
" 準備
"------------------------------------------------------------
" このファイルを利用する前に以下の手順を実行してください
"
" 1.NeoBundle のインストール
"   git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
"
" 2.プラグインのインストール
"   vim ~/.vimrc
"   :NeoBundleInstall

"------------------------------------------------------------
" vi 互換設定
"------------------------------------------------------------
if !1 | finish | endif

"------------------------------------------------------------
" 各種プラグイン読み込み
"------------------------------------------------------------
if has('vim_starting')
  set nocompatible
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'

" Autocomplete dropdown
" NeoBundle 'Shougo/neocomplcache'

" NeoBundle 'Shougo/neosnippet'
" NeoBundle 'Shougo/neosnippet-snippets'

NeoBundle 'Shougo/unite.vim'            " 統合 UI
NeoBundle 'itchyny/lightline.vim'       " ステータスライン

" シェル
"NeoBundle 'Shougo/vimshell.vim'
NeoBundle 'Shougo/vimproc.vim', {
      \ 'build' : {
      \     'windows' : 'tools\\update-dll-mingw',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'linux' : 'make',
      \     'unix' : 'gmake',
      \    },
      \ }

" カラースキームのプレビュー用
" :Unite -auto-preview colorscheme
NeoBundle 'ujihisa/unite-colorscheme'

" Color schemes
NeoBundle 'nanotech/jellybeans.vim'
"NeoBundle 'w0ng/vim-hybrid'
"NeoBundle 'jonathanfilip/vim-lucius'
"NeoBundle 'chriskempson/vim-tomorrow-theme'

NeoBundle 'sjl/gundo.vim'
NeoBundle 'tpope/vim-fugitive'          " git
NeoBundle 'thinca/vim-quickrun.git'
NeoBundle 'scrooloose/syntastic'

" programming language-specific bundles
NeoBundle 'leafgarland/typescript-vim'  " typescript
NeoBundle 'kchmck/vim-coffee-script'    " coffee
NeoBundle 'tpope/vim-haml'              " haml
NeoBundle 'PDV--phpDocumentor-for-Vim'  " phpdoc
NeoBundle 'StanAngeloff/php.vim'        " php
NeoBundle 'vim-scripts/nginx.vim'       " nginx
NeoBundle 'xsbeats/vim-blade'           " blade(?)
NeoBundle 'kannokanno/previm'

" Auto-complete surrounding brackets like Sublime (Doesn't work?)
NeoBundle 'tpope/vim-surround'

" Fix an issue with sql files freaking out
NeoBundle 'vim-scripts/dbext.vim'

call neobundle#end()
filetype plugin indent on
NeoBundleCheck

"------------------------------------------------------------
" 基本設定
"------------------------------------------------------------
set nobackup            " バックアップファイルを作らない
set noswapfile          " スワップファイルを作らない
set nocompatible        " vi 互換モードを無効

set hidden              " ファイル未保存でも他ファイルを開く
set confirm             " 終了前に未保存ファイルの確認
set autoread            " 外部の変更を自動でロード

set visualbell t_vb=    " ビープを無効
set termencoding=utf-8  " 端末の文字コード

filetype on             " ファイル形式毎の設定を有効

set t_Co=256            " 256 色を強制

"------------------------------------------------------------
" マウス設定
"------------------------------------------------------------
if has('mouse')
  set mouse=a             " 全モードでマウスを有効化
  if has('mouse_sgr')
    set ttymouse=sgr
  elseif v:version > 703 || v:version is 703 && has('patch632')
    set ttymouse=sgr
  else
    set ttymouse=xterm2
  endif
  noremap <M-LeftMouse> <LeftMouse><Esc><C-V>
  noremap <M-LeftDrag> <LeftDrag>
endif

"------------------------------------------------------------
" Input Settings
"------------------------------------------------------------
set textwidth=0         " 指定桁数を超える行の自動改行を無効

" バックスペースで制御文字を削除
set backspace=indent,eol,start

" 改行の回り込み設定
"
"   方向キーも許可する場合は以下を設定
"   set whichwrap=b,s,<,>,[,],~
set whichwrap=b,s       " バックスペースとスペースを許可

"------------------------------------------------------------
" Status line and command line
"------------------------------------------------------------
set laststatus=2        " ステータスラインを常に表示
set noruler             " デフォルトのルーラを非表示

set showcmd             " 入力中コマンドを表示
set showmode            " 現在のモードを表示
set cmdheight=2         " コマンドラインを 2 行表示

" ステータスラインの表示
set statusline=%<

" ファイル, 各種フラグ
set statusline+=%F%m%r%h%w%=

" git ブランチ名
if neobundle#is_installed('vim-fugitive')
  set statusline+=%{fugitive#statusline()}\ 
endif

" 文字エンコードとファイル形式
set statusline+=[%{(&fenc!=''?&fenc:&enc)}]
set statusline+=[%{(&ff=='unix'?'LF':(&ff=='dos'?'CRLF':'CR'))}]

" 列数, 行数/総行数
set statusline+=\ %c%l/%L

" プラグインが存在する場合はプラグインの設定で上書き
if neobundle#is_installed('lightline.vim')
  let g:lightline = {
    \ 'colorscheme': 'jellybeans',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'fugitive', 'readonly', 'filename', 'modified' ] ]
    \ },
    \ 'component': {
    \   'readonly': '%{&filetype=="help" ? "" : (&readonly ? "\u2B64" : "")}',
    \   'modified': '%{&filetype=="help" ? "" : (&modified ? "+" : (&modifiable? "" : "-"))}',
    \   'fugitive': '%{exists("*fugitive#head") && "" != fugitive#head() ? ("\u2B60 " . fugitive#head()) : ""}'
    \ },
    \ 'component_visible_condition': {
    \   'readonly': '(&filetype!="help" && &readonly)',
    \   'modified': '(&filetype!="help" && (&modified || !&modifiable))',
    \   'fugitive': '(exists("*fugitive#head") && "" != fugitive#head())'
    \ },
    \ 'separator': { 'left': "\u2B80", 'right': "\u2B82" },
    \ 'subseparator': { 'left': "\u2B81", 'right': "\u2B83" },
    \ }
endif

"------------------------------------------------------------
" タブライン
"------------------------------------------------------------
" タブ関係のキー設定
nnoremap [Tag] <Nop>
nmap t [Tag]

" t1...9 : タブジャンプ
" tc : タブ作成
" tx : タブを閉じる
" tn : 次のタブ
" tp : 前のタブ
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
map <silent> [Tag]c :tablast <bar> tabnew<CR>
map <silent> [Tag]x :tabclose<CR>
map <silent> [Tag]n :tabnext<CR>
map <silent> [Tag]p :tabprevious<CR>

"------------------------------------------------------------
" ウィンドウ操作
"------------------------------------------------------------
" so : ウィンドウを最大化
" s= : ウィンドウの幅を均一化
nnoremap so <C-w>_<C-w>\|
nnoremap s= <C-w>=

"------------------------------------------------------------
" Write/Quit remaps AKA GODAMMIT YOU KNOW WHAT I MEAN, VIM
"------------------------------------------------------------
nnoremap q <NOP>
:cabbrev Q q
:cabbrev W w
:cabbrev Wq wq
:cabbrev WQ wq
:cabbrev we w

"------------------------------------------------------------
" インデント
"------------------------------------------------------------
set noautoindent        " オートインデントを無効
set nosmartindent       " 行挿入時のインデントを無効
set nocindent           " C プログラムの自動インデントを無効

set expandtab           " タブキーを空白に変換
set tabstop=2           " タブ文字の見た目上の幅
set softtabstop=2       " インデント自動挿入時のインデント幅
set shiftwidth=2        " タブ挿入時のインデント幅

"------------------------------------------------------------
" 表示
"------------------------------------------------------------
set number              " Show line number
set showmatch           " 対応する括弧をハイライト
set cursorline          " カーソル行のハイライト
set list                " 不可視文字の表示
set ambiwidth=single    " 曖昧な文字(★など)に 1 文字分の幅を割当
" set scrolloff=5         " スクロール中にカーソル下 5 行表示

" 不可視文字の表示設定
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%

syntax on               " ハイライトを有効化
if neobundle#is_installed('jellybeans.vim')
  colorscheme jellybeans  " カラースキームを設定
endif

" 全角スペースの表示
" http://code-life.net/?p=2704
function! ZenkakuSpace()
  highlight ZenkakuSpace cterm=reverse ctermfg=DarkMagenta gui=reverse guifg=DarkMagenta
endfunction

augroup ZenkakuSpace
autocmd!
autocmd ColorScheme       * call ZenkakuSpace()
autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
augroup END
call ZenkakuSpace()

" Line at 121 characters
highlight ColorColumn ctermbg=234 guibg=#1c1c1c
let &colorcolumn="121"
" let &colorcolumn="80,".join(range(121,999),",") " line at 80, block past 120

"------------------------------------------------------------
" 補完
"------------------------------------------------------------
set wildmenu            " コマンドラインモードの補完を有効化
set wildchar=<tab>      " コマンド補完を開始するキー
set history=1000        " コマンド・検索パターンの履歴数
set wildmode=list:longest,full

let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_ignore_case = 1
let g:neocomplcache_enable_smart_case = 1
if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_underbar_completion = 1

"------------------------------------------------------------
" 検索
"------------------------------------------------------------
set wrapscan            " 最後まで検索したら先頭に戻る
set ignorecase          " 大小文字を区別しない
set smartcase           " 大文字検索は大小文字区別
set hlsearch            " 検索語を強調表示
set incsearch           " インクリメンタルサーチを有効化

" Esc を 2 回押したときにハイライト消去
nnoremap <Esc><Esc> :nohlsearch<CR><ESC>

"------------------------------------------------------------
" 移動
"------------------------------------------------------------
set nostartofline       " 移動コマンド時の行頭移動を無効

" 挿入モードでの移動
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>

"------------------------------------------------------------
" Autocomplete
" -----------------------------------------------------------
inoremap <Nul> <C-n>

"------------------------------------------------------------
" ファイル
"------------------------------------------------------------
" 改行文字
set fileformats=unix,dos,mac

" 文字コード
set encoding=utf-8
set fileencodings=utf-8,euc-jp,iso-2022-jp,cp932

"------------------------------------------------------------
" ディレクトリ
"------------------------------------------------------------
let g:netrw_liststyle = 3
let g:netrw_altv = 1
let g:netrw_alto = 1

"------------------------------------------------------------
" ファイル形式ごとの設定
"------------------------------------------------------------
au FileType php   setlocal sts=4 ts=4 sw=4
au FileType blade setlocal sts=2 ts=2 sw=2
au FileType scss  setlocal sts=2 ts=2 sw=2
au BufNewFile,BufRead *.blade.php set ft=html | set ft=phtml | set ft=blade
au BufNewFile,BufRead *.md set ft=markdown

let g:previm_open_cmd='echo'

"let g:syntastic_check_on_open = 1
"let g:syntastic_php_checkers = ['php']
"let g:syntastic_ruby_checkers = ['ruby']

let g:syntastic_check_on_open = 1
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': ['ruby', 'php'] }
let g:syntastic_php_checkers = ['php']
let g:syntastic_ruby_checkers = ['mri']

"------------------------------------------------------------
" Utilities
"------------------------------------------------------------
nmap <F5> :call TouchRestart()<CR>
function! TouchRestart()
  for repo in ['admin', 'admin_suzaku', 'admin_shop', 'racoupon_api']
    call system('touch /usr/local/rms/july/shareee/' . repo . '/tmp/restart.txt')
  endfor
  echo 'tmp/restart.txt touched!'
endfunction

nmap <F7> :call Format()<CR>
function! Format()
  :w
  ! spec-format %
endfunction
