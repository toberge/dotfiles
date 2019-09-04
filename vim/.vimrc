
" default arch vim config (nice)
runtime! archlinux.vim

" plug.vim (code from tips page)
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" ------ complex things ------
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'ycm-core/YouCompleteMe', { 'do': './install.py' }
" <Leader>T to use, <Leader> is \ by default (warum weiß ich nicht)
Plug 'wincent/Command-T', {
    \   'do': 'cd ruby/command-t/ext/command-t && ruby extconf.rb && make'
    \ }

" ------ commands ------
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
" use gc to comment/uncomment
Plug 'tpope/vim-commentary'
" use cp to copy and cv to paste
Plug 'christoomey/vim-system-copy'
" use gs to sort
Plug 'christoomey/vim-sort-motion'

" ------ text objects ------
" (l)ine, (e)ntire buffer
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-entire'

call plug#end()

autocmd BufWrite *.md :! pandoc % -o /tmp/thing.pdf

" NERDTree on ctrl+n
let NERDTreeShowHidden=1
map <silent> <C-n> :NERDTreeToggle<CR>

" close NERDTree after a file is opened
let g:NERDTreeQuitOnOpen=1


" don't use arrowkeys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" really, just don't
inoremap <Up>    <NOP>
inoremap <Down>  <NOP>
inoremap <Left>  <NOP>
inoremap <Right> <NOP>

" from vim wiki http://vim.wikia.com/wiki/Example_vimrc

" Attempt to determine the type of a file based on its name and possibly its
" contents. Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
filetype indent plugin on

" Enable syntax highlighting
syntax on


" Better command-line completion
set wildmenu

" Show partial commands in the last line of the screen
set showcmd

" Highlight searches (use <C-L> to temporarily turn off highlighting; see the
" mapping of <C-L> below)
set hlsearch


" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent


" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler

" Always display the status line, even if only one window is displayed
set laststatus=2

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

" Use visual bell instead of beeping when doing something wrong
set visualbell

" And reset the terminal code for the visual bell. If visualbell is set, and
" this line is also included, vim will neither flash nor beep. If visualbell
" is unset, this does nothing.
set t_vb=

" Enable use of the mouse for all modes
set mouse=a

" Set the command window height to 2 lines, to avoid many cases of having to
" "press <Enter> to continue"
set cmdheight=2

" Display line numbers on the left
set number
set relativenumber
" ahem, RELATIVE == UsEFUL

" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=200


" Indentation settings for using 4 spaces instead of tabs.
" Do not change 'tabstop' from its default value of 8 with this setup.
set shiftwidth=4
set softtabstop=4
set expandtab
" ALSo maybe this for xtra convenience
set smarttab " tab to next intent

" Indentation settings for using hard tabs for indent. Display tabs as
" four characters wide.
"set shiftwidth=4
"set tabstop=4

