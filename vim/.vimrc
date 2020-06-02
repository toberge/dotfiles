"
"      totally qualified
"        _
" __   _(_)_ __ ___  _ __ ___
" \ \ / / | '_ ` _ \| '__/ __|
"  \ V /| | | | | | | | | (__
"   \_/ |_|_| |_| |_|_|  \___|
"
" With pieces taken from
" - standard Arch config
" - Vim wiki
" - plugin READMEs
"
" This config is meant to please no one but myself
"

" ------ Plugins ------{{{

" plug.vim (code from tips page)
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" ------ commands ------
Plug 'tpope/vim-repeat'
" use gc to comment/uncomment
Plug 'tpope/vim-commentary'
" use cp to copy and cv to paste
Plug 'christoomey/vim-system-copy'
" use gs to sort
Plug 'christoomey/vim-sort-motion'

" ------ text objects ------
" (s)urrounding (object/motion/command)
Plug 'tpope/vim-surround'
" (l)ine, (e)ntire buffer
" Plug 'kana/vim-textobj-line'
" Plug 'kana/vim-textobj-entire'
" (they stopped working)
Plug 'jiangmiao/auto-pairs'

" ------ file finding ------
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
" <Leader>T to use, <Leader> is \ by default (warum weiß ich nicht)
Plug 'wincent/Command-T', {
    \   'do': 'cd ruby/command-t/ext/command-t && ruby extconf.rb && make'
    \ }
" ok there's some builtin for this but whaaat eeeeever
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" ------ code completion ------
Plug 'ycm-core/YouCompleteMe', { 'do': './install.py' }
" Plug 'neoclide/coc.nvim', { 'branch': 'release' }
" goto def/refs
" nmap <leader>gd <Plug>(coc-definition)
" nmap <leader>gr <Plug>(coc-references)

" ------ linting ------
Plug 'dense-analysis/ale'

" ------ cosmetics ------
Plug 'psliwka/vim-smoothie' " smud scrolling
Plug 'dylanaraps/wal.vim'
Plug 'lilydjwg/colorizer'

" ------ LaTeX ------
Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }

" ------ Markdown ------
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'

call plug#end()

" }}} plugs

" ------ arch dump ------{{{

" Use Vim defaults instead of 100% vi compatibility
" Avoid side-effects when nocompatible has already been set.
if &compatible
  set nocompatible
endif

set suffixes+=.aux,.bbl,.blg,.brf,.cb,.dvi,.idx,.ilg,.ind,.inx,.jpg,.log,.out,.png,.toc
set suffixes-=.h
set suffixes-=.obj

" Move temporary files to a secure location to protect against CVE-2017-1000382
if exists('$XDG_CACHE_HOME')
  let &g:directory=$XDG_CACHE_HOME
else
  let &g:directory=$HOME . '/.cache'
endif
let &g:undodir=&g:directory . '/vim/undo//'
let &g:backupdir=&g:directory . '/vim/backup//'
let &g:directory.='/vim/swap//'
" Create directories if they doesn't exist
if ! isdirectory(expand(&g:directory))
  silent! call mkdir(expand(&g:directory), 'p', 0700)
endif
if ! isdirectory(expand(&g:backupdir))
  silent! call mkdir(expand(&g:backupdir), 'p', 0700)
endif
if ! isdirectory(expand(&g:undodir))
  silent! call mkdir(expand(&g:undodir), 'p', 0700)
endif

" Make shift-insert work like in Xterm
if has('gui_running')
  map <S-Insert> <MiddleMouse>
  map! <S-Insert> <MiddleMouse>
endif

" }}} arch

" ------ Visual settings ------{{{

syntax on
colorscheme wal

" fixing tmux issue
" set term=screen-256color
set term=rxvt-unicode-256color

" position visuals
set number
set relativenumber
" set cursorline (gotta customize colorscheme first)

" status line
set showcmd " show what ye're typin'
set ruler " cursor pos - airline does this though
set laststatus=2 " always status line

" }}}

" ------ Editor settings ------{{{

" lets you do 3x{ and 3x} in comments to enclose folds
" zo opens, za closes *all* under cursor, zc closes, and so on
set foldmethod=marker

set wildmenu " better command completion?

" better-than-default search
set ignorecase
set smartcase
set hlsearch " type :noh to disable after search

" misc QoL stuff
set confirm " no more :q!
set visualbell " don't beep
set t_vb= " but don't flash either!
set mouse=a
set cmdheight=2 " cmd height
set notimeout ttimeout ttimeoutlen=200 " timeout on keycode not on mapping?

" }}} editor

" ------ Indentation settings ------{{{

set autoindent " follow protocol!
filetype indent plugin on " let plugins decide indent

" indentation of 4 spaces
set shiftwidth=4
set softtabstop=4
set expandtab

set smarttab " tab to next intent
set backspace=indent,eol,start " backspace removes indent ++

" }}} indent

" ------ Keybinds ------{{{

" leader is space!
let mapleader = " "

" keep fingers on jklø
" møving left/roight ain't that useful

" make use of ø
map ø ;
map Ø ,
" (since ; is in that spot on US layouts...)

" arrow keys are banned {{{

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

" }}}

" }}} keybinds

" ------ Commands ------{{{

" autocmd BufWrite *.md :! pandoc % -o /tmp/thing.pdf
command PDF :!pandoc %:t -o /tmp/thing.pdf

" }}} cmd

" ------ Plugin settings ------

" ------ Pandoc, Latex, Markdown ------{{{

" Markdown plugin specifics
" set conceallevel=2 " if you wanna see ugly previews of formulas
" let g:vim_markdown_math = 1

" let vim_markdown_preview_toggle=2

" :LLPreview
let g:livepreview_previewer = 'zathura'

" damn spellcheck...
let g:pandoc#modules#disabled = ["spell"]

" vim-pandoc YCM
if !exists('g:ycm_semantic_triggers')
    let g:ycm_semantic_triggers = {}
endif
let g:ycm_semantic_triggers.pandoc = ['@']
let g:ycm_filetype_blacklist = {}

" }}}

" ------ airline ------{{{

let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_close_button = 0

" }}}

" ------ tmuxline ------{{{

" statusline content
let g:tmuxline_preset = {
      \'a'    : '#S',
      \'win'  : '#I #W',
      \'cwin' : '#I #W',
      \'y'    : '#F',
      \'z'    : '#H' }

" }}}

" ------ NERDTree ------{{{

" NERDTree on ctrl+n
let NERDTreeShowHidden=1
map <silent> <C-n> :NERDTreeToggle<CR>
map <leader>nf :NERDTreeFind<CR>

" close NERDTree after a file is opened
let g:NERDTreeQuitOnOpen=1

" hide certain obnoxious folders
let NERDTreeIgnore = ['^node_modules$', '^__pycache__$']

" }}}

" ------ fzf ------{{{

" use term colors!
let $FZF_DEFAULT_OPTS = '--color=16'

" Set bindings based on git/not-git
silent !git rev-parse --is-inside-work-tree &>/dev/null
if v:shell_error
    nnoremap <C-p> :Files<CR>
else
    nnoremap <C-p> :GFiles<CR>
endif


"  }}}

" ------ ALE ------{{{

" lint
let g:ale_linters_explicit = 1
let b:ale_linters = ['standard']
let g:ale_javascript_standard_executable = 'semistandard'

" fix
" let g:ale_fix_on_save = 1
let g:ale_fixers = {
\   'javascript': ['prettier'],
\   'css': ['prettier'],
\}

" }}}
