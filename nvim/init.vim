" Fundamentals "{{{
" ---------------------------------------------------------------------

" init autocmd
autocmd!
" set script encoding
scriptencoding utf-8
" stop loading config if it's on tiny or small
if !1 | finish | endif

set nocompatible
set number
set signcolumn=yes
syntax enable
set fileencodings=utf-8,sjis,euc-jp,latin
set encoding=utf-8
set title
set autoindent
set smartindent
set background=dark
set nobackup
set hlsearch
set showcmd
set cmdheight=1
set laststatus=2
set expandtab
"let loaded_matchparen = 1
set shell=zsh
set backupskip=/tmp/*,/private/tmp/*

" incremental substitution (neovim)
set inccommand=split

" Suppress appending <PasteStart> and <PasteEnd> when pasting
set t_BE=

set nosc noru nosm
" Don't redraw while executing macros (good performance config)
set lazyredraw

"set showmatch
" How many tenths of a second to blink when matching brackets
"set mat=2
" Ignore case when searching
set ignorecase
set smartcase
" Be smart when using tabs
set smarttab
" indents
filetype plugin indent on
set shiftwidth=2
set softtabstop=2
set tabstop=2
set ai "Auto indent
set si "Smart indent
set nowrap "No Wrap lines
set backspace=start,eol,indent
" Finding files - Search down into subfolders
set path+=**
set wildignore+=*/node_modules/*

" Turn off paste mode when leaving insert
autocmd InsertLeave * set nopaste

" Add asterisks in block comments
set formatoptions+=r
set formatoptions+=j " Delete comment character when joining commented lines

"}}}

" Highlights "{{{
" ---------------------------------------------------------------------
set nocursorline
"set cursorcolumn

" Set cursor line color on visual mode
highlight Visual cterm=NONE ctermbg=236 ctermfg=NONE guibg=Grey40

highlight LineNr cterm=none ctermfg=240 guifg=#2b506e guibg=#000000

" set cursorline to active window only
" augroup BgHighlight
"   autocmd!
"   autocmd WinEnter * set cursorline
"   autocmd WinLeave * set nocursorline
" augroup END

if &term =~ "screen"
  autocmd BufEnter * if bufname("") !~ "^?[A-Za-z0-9?]*://" | silent! exe '!echo -n "\ek[`hostname`:`basename $PWD`/`basename %`]\e\\"' | endif
  autocmd VimLeave * silent!  exe '!echo -n "\ek[`hostname`:`basename $PWD`]\e\\"'
endif

"}}}

" File types "{{{
" ---------------------------------------------------------------------
" JavaScript
au BufNewFile,BufRead *.es6 setf javascript
" TypeScript
au BufNewFile,BufRead *.tsx setf typescriptreact
" Markdown
au BufNewFile,BufRead *.md set filetype=markdown
au BufNewFile,BufRead *.mdx set filetype=markdown
" Flow
au BufNewFile,BufRead *.flow set filetype=javascript
" Zsh
au BufNewFile,BufRead *.sh set filetype=zsh

set suffixesadd=.js,.es,.jsx,.json,.css,.less,.sass,.styl,.php,.py,.md

autocmd FileType coffee setlocal shiftwidth=2 tabstop=2
autocmd FileType ruby setlocal shiftwidth=2 tabstop=2
autocmd FileType yaml setlocal shiftwidth=2 tabstop=2

"}}}

" Imports "{{{
" ---------------------------------------------------------------------
runtime ./plug.vim
if has("unix")
  let s:uname = system("uname -s")
  " Do Mac stuff
  if s:uname == "Darwin\n"
    runtime ./macos.vim
  endif
endif
if has('win32')
  runtime ./windows.vim
endif

runtime ./maps.vim
"}}}

" Syntax theme "{{{
" ---------------------------------------------------------------------

" true color
if exists("&termguicolors") && exists("&winblend")
  syntax enable
  set termguicolors
  set winblend=0
  set wildoptions=pum
  set pumblend=5
  set background=dark
  colorscheme gruvbox
  " " Use NeoSolarized
  " let g:neosolarized_termtrans=1
  " runtime ./colors/NeoSolarized.vim
  " colorscheme NeoSolarized
endif

"}}}

" Extras "{{{
" ---------------------------------------------------------------------
set exrc
"}}}

" mine
" set gfn=Iosevka\ Extralight\ Nerd\ Font\ Complete:h14
" set gfn=Iosevka\ Nerd\ Font\ Mono\ Extralight:h14
set gfn=Iosevka\ Nerd\ Font\ Mono:h18  " this makes Neovide work
nnoremap <Space> <Nop>
let mapleader = " "

set noswapfile
set nobackup
set nowritebackup
set undofile
set undodir=~/tmp
if !&scrolloff
  set scrolloff=2
endif
if !&sidescrolloff
  set sidescrolloff=5
endif
if !&sidescroll
  set sidescroll=1
endif
set display+=lastline

set dictionary=/usr/share/dict/words

" had these in my .vimrc without comments
set ttimeout
set ttimeoutlen=100
set wildmenu
set list
if &listchars ==# 'eol:$'
  " set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
  set listchars=tab:▸\ ,trail:-,extends:>,precedes:<,nbsp:+
endif
set autowriteall
set autoread
let g:netrw_liststyle=3 " tree view

" let g:gitgutter_sign_added = emoji#for('small_blue_diamond')
" let g:gitgutter_sign_modified = emoji#for('small_orange_diamond')
" let g:gitgutter_sign_removed = emoji#for('small_red_triangle')
" let g:gitgutter_sign_modified_removed = emoji#for('collision')
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '.'
let g:gitgutter_sign_modified_removed = '*'

" set mouse=    " disable mouse entirely

" Visually select the text that was most recently edited/pasted.
" Note: gv selects previously selected area.
nmap gV `[v`]

" Intellisense pop-up
" nnoremap <silent>K :Lspsaga hover_doc<CR>
" save the current file if modified
nnoremap <silent> <Leader><Space> :update<CR>
" copy to the system clipboard
vnoremap <Leader>y "+y
nnoremap <Leader>y "+y
" paste from the system clipboard (p)
nnoremap <Leader>p "+p
vnoremap <Leader>p "+p
" paste from the system clipboard (P)
nnoremap <Leader>P "+P
vnoremap <Leader>P "+P
" more convenient window movement
let g:NERDTreeMapJumpNextSibling = ''
let g:NERDTreeMapJumpPrevSibling = ''
nnoremap <C-j> <C-w>w
nnoremap <C-k> <C-w>W
" (Un)wrap argument lists and object literals
nnoremap <silent> <Leader>a :ArgWrap<CR>
let g:argwrap_padded_braces = '{'
nnoremap <silent> <Leader>c :Gcd<CR>

" splits -- D is Command, S is Shift
set splitright
set splitbelow
nnoremap <C-d> :vnew<CR>
nnoremap <D-d> :vnew<CR>
nnoremap <S-C-d> :new<CR>
nnoremap <S-C-d> :new<CR>

" Use <C-L> to clear the highlighting of :set hlsearch.
" nvim does this by default but causes a flash refresh that is annoying
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

if has("gui_running")
  set guioptions-=T " no toolbar
  set guioptions-=r " no scrollbar
  set guioptions-=L " no scrollbar
  set background=dark
endif
set guioptions-=e

augroup LastEditMarker
  autocmd!
  autocmd InsertLeave * normal mZ
augroup END

function! ToggleDarkLight()
  if &background == "dark"
    set background=light
  else
    set background=dark
  endif
endfunc

function! ToggleTransparency()
  if &transparency == 50
    set transparency=0
  else
    set transparency=50
  endif
endfunc

" toggle dark/light mode
nnoremap <Leader>t :call ToggleDarkLight()<CR>
nnoremap <Leader>T :call ToggleTransparency()<CR>

" H - home - Startify
nnoremap <silent> H :Startify<CR>

  " \ '      L  | show onLy this window (make it Lonely?)',
  " \ '      K  | split current line (reverse of J)',
  " \ '      U  | view Undo tree',
  " \ '     ^U  | jump to previously navigated buffer (better ctrl-O)',
  " \ '     ^Y  | jump to last place we left Insert mode',
  " \ '      =  | align text on provided delimiter',
  " \ '      A  | change callback to use Arrow => function',
  " \ '      C  | Change directory to that of the current buffer file',
  " \ '      d  | enter git Diff mode',
  " \ '      e  | Extended fuzzy find -- files from "work" directory',
  " \ '      G  | open Chrome to BitBucket (Git) page for this repo',
  " \ '      l  | Lint (--fix) current file',
  " \ '      n  | open Node.js module docs for word under cursor or selected text',
  " \ '      q  | delete the current buffer',
  " \ '      s  | Search DuckDuckGo for word under cursor or selected text',
  " \ '      S  | Search DuckDuckGo (+ducky) for word under cursor or selected text',
  " \ '      t  | Toggle dark/light theme',
  " \ '      w  | Wipe the current buffer',
  " \ '      cs | change surrounding quotes/tags',
  " \ '      ds | delete surrounding quotes/tags',

" let g:startify_custom_header = [
"   \ '',
"   \ ]
let g:startify_custom_footer = [
  \ '',
  \ '',
  \ '   -- Custom Mappings -----------------------------------------------------',
  \ '',
  \ '      H  | open this Home screen',
  \ '',
  \ '   Leader:',
  \ '         | [space] Save current file if modified',
  \ '      a  | (un)wrap Argument lists and object literals',
  \ '      b  | fuzzy find Buffers',
  \ '      c  | Change directory to project root',
  \ '      f  | fuzzy find function definition under cursor',
  \ '      F  | fuzzy find all Function definitions',
  \ '      h  | Hunt using fzf rg with preview',
  \ '      H  | Hunt using fzf rg including .extra-ignore',
  \ '      j  | fuzzy find files (in a Jiffy)',
  \ '      p  | Paste from the system clipboard',
  \ '      P  | Paste from the system clipboard',
  \ '      y  | Yank to the system clipboard',
  \ '      Y  | Yank to the system clipboard',
  \ '',
  \ '',
  \ '      ga | align text',
  \ '      gc | (un)comment a line',
  \ ]
let g:startify_padding_left           = 3
let g:startify_fortune_use_unicode    = 1
let g:startify_enable_special         = 0
let g:startify_files_number           = 20
let g:startify_relative_path          = 1
let g:startify_change_to_dir          = 1
let g:startify_update_oldfiles        = 0
let g:startify_session_autoload       = 1
let g:startify_session_persistence    = 0
let g:startify_session_delete_buffers = 0
highlight StartifyFooter ctermfg=208

let g:startify_list_order = [
  \ ['   Bookmarks:'],
  \ 'bookmarks',
  \ ['   MRU:'],
  \ 'files',
  \ ['   MRU here:'],
  \ 'dir',
  \ ['   Sessions:'],
  \ 'sessions',
  \ ]

let g:startify_skiplist = [
  \ 'COMMIT_EDITMSG',
  \ '.git/.*',
  \ '.*usr.local*',
  \ ]

let g:startify_bookmarks = [
  \ { 'v': '~/.config/nvim' },
  \ { 'q': '~/work/repos/quattro' },
  \ { 'o': '~/work/repos/operator-panel-v2' },
  \ { 'b': '~/work/repos/cloud-btm' },
  \ ]

