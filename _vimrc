" %userprofile%_vimrc
" で配置する。
" あと、C:\Share\vim80-kaoriya-win64\_vimrc
" は邪魔な設定なのでなくしてしまう。

" エンコード系の設定
" エンコードの設定を先頭で指定しないと、メニューとコンテキストが文字化けする。
set encoding=utf-8
set fileencoding=utf-8
set fileformats=unix,dos,mac
set visualbell t_vb=
set novisualbell
" 挿入モードでは細い線、ノーマルモードではブロックにする
set guicursor=n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-Cursor2/lCursor2
" 挿入モードに入るときに縦棒、抜けるときにブロックにする（Windows Terminal用）
let &t_SI = "\e[5 q"
let &t_EI = "\e[2 q"
"文字コードをUFT-8に設定
" set fenc=utf-8
"スクリプトのエンコードを指定
scriptencoding utf-8

"if !has('gui_running') && &encoding != 'cp932' && &term == 'win32'
"  set termencoding=cp932
"endif

" バックアップファイルを作らない
set nobackup
" スワップファイルを作らない
set noswapfile
" 編集中のファイルが変更されたら自動で読み直す
set autoread
" バッファが編集中でもその他のファイルを開けるように
set hidden
" 入力中のコマンドをステータスに表示する
set showcmd


" 見た目系
" 行番号を表示
set number
" 現在の行を強調表示
"set cursorline
" 現在の行を強調表示（縦）
"set cursorcolumn
" 行末の1文字先までカーソルを移動できるように
set virtualedit=onemore
" インデントはスマートインデント
set smartindent
" ビープ音を可視化
set visualbell
" 括弧入力時の対応する括弧を表示
set showmatch
" ステータスラインを常に表示
set laststatus=2
" コマンドラインの補完
set wildmode=list:longest
" 折り返し時に表示行単位での移動できるようにする
nnoremap j gj
nnoremap k gk

"背景色
"ctermfg は CUI 版の Vim で使われる文字色、guifg は GUI 版の Vim で使われる文字色を指します。
"bg も同じ。ctermbg は CUI 版のバックグラウンドカラー。guibg は GUI 版の Vim で使われるバックグランドカラー。
highlight Normal guibg=Black guifg=Green ctermbg=Black ctermfg=Green

" Tab系
autocmd Colorscheme * highlight IdeographicSpace term=underline ctermbg=Red guifg=DarkGray
set list

set listchars=tab:>»,trail:_,eol:<,extends:>,precedes:<,nbsp:%

"改行文字とタブ文字の色設定（NonTextが改行、SpecialKeyがタブ）
hi NonText guibg=NONE guifg=#F8E4F1 ctermbg=NONE ctermfg=DarkGray
hi SpecialKey guibg=NONE guifg=#008080 ctermbg=NONE ctermfg=DarkMagenta
highlight SpecialKey guibg=#222222 cterm=underline ctermfg=darkgrey

"全角スペースをハイライト表示
function! ZenkakuSpace()
    highlight ZenkakuSpace cterm=reverse ctermfg=Red gui=reverse guifg=Red
endfunction

if has('syntax')
    augroup ZenkakuSpace
        autocmd!
        autocmd ColorScheme       * call ZenkakuSpace()
        autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
    augroup END
    call ZenkakuSpace()
endif


set showbreak=↪
" シンタックスハイライトを有効にする
syntax enable

" Tab文字を半角スペースにする
" set expandtab
" 行頭以外のTab文字の表示幅（スペースいくつ分）
set tabstop=2
set autoindent
set expandtab
" 行頭でのTab文字の表示幅
set shiftwidth=2


" 検索系
" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase
" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
" 検索文字列入力時に順次対象文字列にヒットさせる
set incsearch
" 検索時に最後まで行ったら最初に戻る
set wrapscan
" 検索語をハイライト表示
set hlsearch
" ESC連打でハイライト解除
nmap <Esc><Esc> :nohlsearch<CR><Esc>
" コマンドラインの高さ (Windows用gvim使用時はgvimrcを編集すること)
set cmdheight=1
" クリップボードをOSのものに
set clipboard=unnamed,autoselect

"コマンドに関連した設定
function! LeaveAndEnter(word)
  echo a:word
endfunction

autocmd VimEnter * call LeaveAndEnter("Hello World")
autocmd InsertEnter  * call LeaveAndEnter("Enter InsertMode. You can edit.")
autocmd InsertLeave * call LeaveAndEnter("Leave InsertMode. Current is Command ode.")

" コマンドモードの場合に f をおすとなぜか全角モードになる。
" 一度挿入モードにした場合には回避できるがうっとうしいのでこの設定。
set iminsert=0 imsearch=0

"set imdisable
" 挿入モードをやめたらimeをやめる
autocmd InsertLeave * set iminsert=0 imsearch=0
" バックスペースで改行も消せる
set backspace=indent,eol,start

"いつもcwコマンドを使用する場合は以下のように書けば省略できる。
au QuickfixCmdPost grep cw
au QuickfixCmdPost vimgrep cw
nnoremap [q :cprevious<CR>   " 前へ
nnoremap ]q :cnext<CR>       " 次へ
nnoremap [Q :<C-u>cfirst<CR> " 最初へ
nnoremap ]Q :<C-u>clast<CR>  " 最後へ

"全角スペースをハイライト表示
function! ZenkakuSpace()
    highlight ZenkakuSpace cterm=reverse ctermfg=DarkBlue gui=reverse guifg=#363658
endfunction

if has('syntax')
    augroup ZenkakuSpace
        autocmd!
        autocmd ColorScheme       * call ZenkakuSpace()
        autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
    augroup END
    call ZenkakuSpace()
endif

function! LeaveAndEnter(word)
  echo a:word
endfunction

autocmd VimEnter * call LeaveAndEnter("Hello World")
autocmd InsertEnter  * call LeaveAndEnter("Enter InsertMode. You can edit.")
autocmd InsertLeave * call LeaveAndEnter("Leave InsertMode. Current is Command Mode.")

" コマンドモードの場合に f をおすとなぜか全角モードになる。
" 一度挿入モードにした場合には回避できるがうっとうしいのでこの設定。
set iminsert=0 imsearch=0

set langmenu=ja_jp.utf-8
" 縦棒とカーソルをコマンドモードと入寮モードで切り替える
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
