" Old config
set noerrorbells visualbell t_vb=
if has('autocmd')
 autocmd GUIEnter * set visualbell t_vb=
endif

set number

" Highly recommended to set tab keys to 4 spaces
set tabstop=2
set shiftwidth=2
set nohlsearch
set wrap

" Set Dimentions
" set columns=100
" set lines=30 columns=95

" hi Normal guibg=NONE ctermbg=NONE

"set spelllang=en_us,el
"set spell

" Global encoding setup
set encoding=utf-8
set fileencoding=utf-8

filetype plugin on " Enable language dependant settings.
filetype indent on " Enable language dependant auto indentation.
syntax on          " Enable syntaxical coloration.
set wrap 
" set background=dark " Who use light background anyway ?
" colorscheme desert  " Makes use of the desert default solor scheme.

let mapleader = ","      " Change Leader from '\' to ','.
let maplocalleader = ";" " Sets LocalLeader to ';'.

nnoremap <Leader>< :tabnew $MYVIMRC<CR>
nnoremap <Leader>> :source $MYVIMRC<CR>

" Helper function : creates a directory if not already present.
function! SafeMkdir(path)
    if !isdirectory(a:path)
        call mkdir(a:path, "p", 0700)
    endif
endfunction

call SafeMkdir($HOME . "/.vim/swap")
set swapfile " Use recovery files.
set directory=$HOME/.vim/swap//

call SafeMkdir($HOME . "/.vim/undo")
set undofile " Keep an undo file (persistent).
set undodir=$HOME/.vim/undo//

set cursorline     " Highlight current line
set number
" set relativenumber " Show lines numbre relative to the cursor position.
set scrolloff=5    " Always keep cursor away from top/bottom

set lazyredraw " Redraw window only when usefull
set showcmd    " Show command while typing.
set showmode   " Show current mode. Void is 'Normal' mode.

set expandtab     " Replace <Tab> by $shiftwidth spaces.
set shiftround    " Round spaces to the nearest $shiftwidth multiple.
set softtabstop=4 " One softtab is two space long.
set shiftwidth=4  " One <Tab> is 4 spaces long.
set tabstop=2     " One TAB appears to be 4 spaces.
set autoindent    " Automatic code file indentation.

set ignorecase     " Ignore case while searching for an expression.
set smartcase      " Disable 'ignorecase' if a capital letter is typed.
set fileignorecase " Ignode case whil searching for a file.

set incsearch " Show search's result(s) while typing.
set hlsearch  " Highlight search's result(s).
set nohlsearch    " Disable highlight at a buffer opening.
nnoremap <Leader><Space> :nohlsearch<CR>

" Enable status line visibility
set laststatus=2
set statusline =\ D:%{getcwd()} " Working directory
set statusline+=\ F:%f          " Current file
set statusline+=\ S:%m          " File's modification state
set statusline+=\ R:%r          " File's permissions
set statusline+=\ T:%y          " File's language type
set statusline+=\ L:%l/%L       " Current line vs lines number
set statusline+=\ C:%v          " Current column
set statusline+=\ P:%p          " Current percentage

nnoremap j gj
nnoremap k gk

nnoremap <Leader>= mfggVG=`fzz

nnoremap <Leader>t :tabnew<Space>
nnoremap <Leader>h :tabfirst<CR>
nnoremap <Leader>j :tabprevious<CR>
nnoremap <Leader>k :tabnext<CR>
nnoremap <Leader>l :tablast<CR>

nnoremap <LocalLeader>h :tabmove0<CR>
nnoremap <LocalLeader>j :tabmove-<CR>
nnoremap <LocalLeader>k :tabmove+<CR>
nnoremap <LocalLeader>l :tabmove$<CR>

noremap <silent> <esc> <C-\><C-n>

noremap gf :vertical wincmd f<CR>
noremap gF :wincmd f<CR>

" Delete trailing spaces on save
autocmd BufWritePre * %s/\s\+$//e

"Goes back to the last cursor position before leaving the buffer.
autocmd BufReadPost *
            \ if line("'\"") > 1 && line("'\"") <= line("$") |
            \   execute "normal! g`\"" |
            \ endif

" Send current buffer to 'ix' pastebin
function! Ix()
    :w ![ -z "$1" ] && curl -F 'f:1=<-' ix.io || ix < "$1";
endfunction
nnoremap <Leader>X :call Ix()<CR>

