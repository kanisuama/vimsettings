" ------------------------------------------------------------------------------
" ~/.vimrc
" ------------------------------------------------------------------------------

" ------------------------------------------------------------------------------
" 基本設定
" ------------------------------------------------------------------------------

" 内容が変更されたら自動的に再読込み
set autoread

" バックアップファイルを作らない
set nobackup

" スワップファイルを作らない
set noswapfile

" アンドゥファイルを作らない
set noundofile

" 文字コードの設定
set encoding=utf-8
scriptencoding utf-8

" 日本語のヘルプファイルを読む
set helplang=ja,en

" gvimで終了時の状態を保存し, 次回起動時に状態を復元する
if has('gui_running')
    augroup save_and_load_session
        autocmd!

        " セッションファイル
        let s:session_file = expand('$HOME/.vimsession')

        if filereadable(s:session_file)
            " 引数なし起動の時、前回のセッションを復元
            autocmd VimEnter * nested if @% == '' && s:get_buf_byte() == 0
                                  \ |     execute 'source' s:session_file
                                  \ | endif
        endif

        " Vim終了時に現在のセッションを保存する
        let g:save_session = 0
        autocmd VimLeave * if g:save_session == 0
                       \ |     call delete(s:session_file)
                       \ | else
                       \ |     execute 'mksession!' s:session_file
                       \ | endif
    augroup END
endif

function! s:get_buf_byte()
    let byte = line2byte(line('$') + 1)
    return byte == -1 ? 0 : byte - 1
endfunction


" ------------------------------------------------------------------------------
" dein.vim settings
" ------------------------------------------------------------------------------

" プラグインが実際にインストールされるディレクトリ
if has('win32') || has('win64')
    if has('nvim')
        let g:dein_dir = expand('$HOME\AppData\Local\nvim\bundles')
    else
        let g:dein_dir = expand('$HOME\vimfiles\bundles')
    endif
else
    let g:dein_dir = expand('~/.vim/bundles')
endif

" dein.vim本体
let s:dein_repo_dir = g:dein_dir . expand('/repos/github.com/Shougo/dein.vim')


" dein.vimのインストール
function! s:dein_install()
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
    " インストールされたのを確認して，プラグインのロードと
    " インストールコマンドの削除
    if isdirectory(s:dein_repo_dir)
        call s:dein_load()
        delcommand DeinInstall
    endif
endfunction


" プラグインのロード
function! s:dein_load()
    " runtimepathのチェック
    if &runtimepath !~# expand('/dein.vim')
        execute 'set runtimepath^=' . s:dein_repo_dir
    endif

    if dein#load_state(g:dein_dir)
        " プラグインリストを入力したTOMLファイル
        let g:vim_settings = expand('~/vimsettings')
        let s:toml         = g:vim_settings . expand('/dein.toml')
        let s:local_toml   = expand('~/.dein_local.toml')

        call dein#begin(g:dein_dir, expand('<sfile>'))

        " TOMLを読み込み，キャッシュしておく
        call dein#load_toml(s:toml)

        " ローカルなTOMLがあれば追加で読み込み，キャッシュする
        if filereadable(s:local_toml)
            call dein#load_toml(s:local_toml)
        endif

        " 設定終了
        call dein#end()
        call dein#save_state()
    endif

    call dein#call_hook('source')

    " もし，未インストールのものがあればインストール
    if dein#check_install()
        call dein#install()
    endif
endfunction


if isdirectory(s:dein_repo_dir)
    " dein.vimがあれば，プラグインをロードする
    call s:dein_load()
else
    " dein.vimがなければ，インストールコマンドを生成する
    command! DeinInstall call s:dein_install()
    augroup nodein_call
        autocmd!
        autocmd VimEnter * echo 'dein.vimがインストールされていません．'
                            \ . ':DeinInstallでインストールして下さい．'
    augroup END
endif


" ------------------------------------------------------------------------------
" キーマッピング設定
" ------------------------------------------------------------------------------

" <BS>, <Space>による移動の無効化
noremap <BS>    <Nop>
noremap <Space> <Nop>

" jとgj, kとgkを入れ替える
noremap j gj
noremap gj j
noremap k gk
noremap gk k

" ;と:を入れ替える
noremap ; :
noremap : ;
nnoremap q; q:

" Deleteキーが効かなくなる問題を解決
if has('unix') && !has('gui_running')
    noremap!  
endif

" <ESC><ESC>でハイライト解除
nnoremap <ESC><ESC> :<C-U>nohlsearch<CR>

" 括弧の補完
inoremap {     {}<LEFT>
inoremap {<CR> {<CR>}<ESC>O
inoremap {}    {}
inoremap (     ()<LEFT>
inoremap ()    ()
inoremap <     <><LEFT>
inoremap <>    <>
inoremap [     []<LEFT>
inoremap []    []
inoremap "     ""<LEFT>
inoremap ""    ""
inoremap '     ''<LEFT>
inoremap ''    ''

" インサートモードでの<C-H>, <C-J>, <C-K>, <C-L>による移動の割り当て
inoremap <C-H> <LEFT>
inoremap <C-J> <DOWN>
inoremap <C-K> <UP>
inoremap <C-L> <RIGHT>

" コマンドラインモードでの<C-P>, <C-N>による履歴補完の割り当て
cnoremap <C-P> <UP>
cnoremap <C-N> <DOWN>

" コマンドラインモードでの<C-H>, <C-J>, <C-K>, <C-L>による移動の割り当て
cnoremap <C-J> <LEFT>
cnoremap <C-K> <RIGHT>
cnoremap <C-H> <S-LEFT>
cnoremap <C-L> <S-RIGHT>

" Home, Endの割り当て（状況に応じてg^/^/0, g$/$を使い分ける）
" （ビジュアルモードでもgo_to_head/footが使えるようにしたい…）
nnoremap <silent> <Space>h :<C-U>call <SID>go_to_head()<CR>
vnoremap          <Space>h ^
onoremap          <Space>h ^
nnoremap <silent> <Space>l :<C-U>call <SID>go_to_foot()<CR>
vnoremap          <Space>l $
onoremap          <Space>l $

function! s:go_to_head()
    let l:bef_col = col('.')
    normal! g^
    let l:aft_col = col('.')
    if l:bef_col == l:aft_col
        normal! ^
        let l:aft_col = col('.')
        if l:bef_col == l:aft_col
            normal! 0
        endif
    endif
endfunction

function! s:go_to_foot()
    let l:bef_col = col('.')
    normal! g$
    let l:aft_col = col('.')
    if l:bef_col == l:aft_col
        normal! $
    endif
endfunction


" ------------------------------------------------------------------------------
" 表示系設定
" ------------------------------------------------------------------------------

" カラースキームの設定
colorscheme torte

" 編集中のファイル名を表示する
set title

" ステータスラインを表示
set laststatus=2

" ルーラの表示
set ruler

" 相対行番号の表示
set relativenumber
set numberwidth=3
 
" カーソル行を表示
set cursorline

" カーソル行の上下へのオフセットを設定する
set scrolloff=4

" ハイライトする括弧に<>を追加
set matchpairs& matchpairs+=<:>

" Unicodeで行末が変になる問題を解決
set ambiwidth=double

function! s:define_hilights()
    " カーソル行の色設定
    highlight CursorLine term=reverse cterm=none ctermbg=8

    " 補完ポップアップの色設定
    highlight Pmenu    ctermbg=lightgray
    highlight Pmenu    ctermfg=black
    highlight PmenuSel ctermbg=3
    highlight PmenuSel ctermfg=black
endfunction

augroup sethighlights
    autocmd!
    autocmd ColorScheme * :call <SID>define_hilights()
augroup END

" 挿入モード時、ステータスラインの色を変更
let g:hl_insert = 'highlight StatusLine ctermfg=white ctermbg=red cterm=none '
                                      \ . 'guifg=white   guibg=red   gui=none'

if has('syntax')
    augroup insert_hook
        autocmd!
        autocmd InsertEnter * call s:status_line('Enter')
        autocmd InsertLeave * call s:status_line('Leave')
    augroup END
endif

let s:sl_hl_cmd = ''
function! s:status_line(mode)
    if a:mode == 'Enter'
        silent! let s:sl_hl_cmd = 'highlight ' . s:get_highlight('StatusLine')
        silent exec g:hl_insert
    else
        highlight clear StatusLine
        silent exec s:sl_hl_cmd
    endif
endfunction

function! s:get_highlight(hi)
    redir => hl
    exec 'highlight ' . a:hi
    redir END
    let hl = substitute(hl, '[\r\n]', '', 'g')
    let hl = substitute(hl, 'xxx', '', '')
    return hl
endfunction


" 全角スペースを表示
" コメント以外で全角スペースを指定しているので scriptencodingと、
" このファイルのエンコードが一致するよう注意！
" 全角スペースが強調表示されない場合、ここでscriptencodingを指定すると良い。
" scriptencoding cp932

" デフォルトのZenkakuSpaceを定義
function! s:set_zs_hl()
    highlight ZenkakuSpace cterm=none ctermbg=darkred gui=none guibg=darkred
endfunction

if has('syntax')
    augroup zenkaku_space_group
        autocmd!
        " ZenkakuSpaceをカラーファイルで設定するなら次の行は削除
        autocmd ColorScheme       * call s:set_zs_hl()
        " 全角スペースのハイライト指定
        autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
        autocmd VimEnter,WinEnter * match ZenkakuSpace '\%u3000'
    augroup END
    call s:set_zs_hl()
endif


" 構文ハイライトを有効にする
syntax enable


" ------------------------------------------------------------------------------
" 検索設定
" ------------------------------------------------------------------------------

" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase

" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase

" 検索文字列入力時に順次対象文字列にヒットさせる
set incsearch

" 検索時に最後まで行ったら最初に戻る
set wrapscan

" 検索語をハイライト
augroup hl_search
    autocmd!
    autocmd VimEnter * set hlsearch
augroup END

" 直前の検索パターンと"hlsearch"をバッファローカルにする
" augroup localized_search
"     autocmd!
"     autocmd WinLeave * let b:vimrc_pattern = @/
"     autocmd WinEnter * let @/ = get(b:, 'vimrc_pattern', @/)
" augroup END

" ビジュアルモードで, *, #で選択文字列で検索できるようにする
xnoremap * :<C-U>call <SID>visual_star_search()<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-U>call <SID>visual_star_search()<CR>#<C-R>=@/<CR><CR>

function! s:visual_star_search()
    let l:temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(substitute(escape(@s, '/\'), '\n$', '', ''),
                             \ '\n', '\\n', 'g')
    let @s = l:temp
endfunction


" ------------------------------------------------------------------------------
" インデント設定
" ------------------------------------------------------------------------------

" 自動インデントを行う
set autoindent

" 高度な自動インデントを行う
set smartindent

" Tab文字を半角スペースにする
set expandtab

" 行頭でのTab文字の表示幅
set shiftwidth=4

" 行頭以外のTab文字の表示幅
set tabstop=4


" ------------------------------------------------------------------------------
" その他の設定
" ------------------------------------------------------------------------------

" 行を越えて左右移動
set whichwrap=h,l,<,>,[,]

" コマンドラインの補完機能の設定
set wildmenu
set wildmode=longest:full,full

" スペルチェック時に日本語等を無視
set spelllang& spelllang+=cjk

" コメント補完の無効化
augroup auto_comment_off
    autocmd!
    autocmd BufEnter * setlocal formatoptions-=r
    autocmd BufEnter * setlocal formatoptions-=o
augroup END

" <C-G>でカレントファイルの更新日時を表示
nnoremap <C-G> :<C-U>call <SID>add_timestamp()<CR>

function! s:add_timestamp()
    if expand('%') == ''
        normal! 
    else
        let l:file_info = substitute(execute('normal! '), '\n', '', 'g')
        let l:timestamp = strftime(" %y/%m/%d %H:%M:%S", getftime(expand('%')))
        let l:file_info = join(insert(split(l:file_info, '"\zs'),
                                    \ l:timestamp, 2), '')
        echo l:file_info
    endif
endfunction


" ------------------------------------------------------------------------------
" 言語別設定
" ------------------------------------------------------------------------------

" vim scriptの編集中に""，tomlファイルの編集中に''の補完を無効にする
augroup vimscript
    autocmd!
    autocmd BufRead,BufNewFile [._]g\=vimrc,.vimrc_local,*.vim,*.toml
                                    \ inoremap <buffer> " "
    autocmd BufRead,BufNewFile *.toml inoremap <buffer> ' '
augroup END


" ------------------------------------------------------------------------------
" ~/.vimrc_local
" ------------------------------------------------------------------------------

" ローカルなvimrcがあれば，読み込む
let s:vimrc_local = expand('~/.vimrc_local')
if filereadable(s:vimrc_local)
    execute 'source' s:vimrc_local
endif

