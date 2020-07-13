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

if has('nvim')
    if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
        silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
	    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
else
    if empty(glob('~/.vim/autoload/plug.vim'))
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
            \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
endif


if has('nvim')
    call plug#begin(stdpath('data') . '/plugged')
else
    call plug#begin('~/.vim/plugged')
endif

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
" consider Plug 'kana/vim-textobj-custom'
Plug 'michaeljsmith/vim-indent-object'
" (i)ndentation
" - ai for line above, aI for above+below
" - ii for just indent

" ------ smart stuff ------
" Annoying auto-pairing - TODO replace..
" remember (<M-e> to expand to end of line
Plug 'jiangmiao/auto-pairs'
" Auto-close things only on <CR>
" both are buggy
" Plug 'rstacruz/vim-closer'
" Plug 'tpope/vim-endwise'
" Align with ga<motion><around what>
Plug 'junegunn/vim-easy-align'
Plug 'alvan/vim-closetag'
" cwd to project root!
Plug 'airblade/vim-rooter'
" TODO: configure this madness
Plug 'SirVer/ultisnips'
Plug 'justinmk/vim-sneak'
" mapped to s and S, less absurd than easymotion

let g:UltiSnipsExpandTrigger="<c-tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

Plug 'editorconfig/editorconfig-vim'


" ------ file finding ------
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" ------ code completion ------
" Plug 'ycm-core/YouCompleteMe', { 'do': './install.py' }
Plug 'neoclide/coc.nvim', { 'branch': 'release' }

" ------ linting ------
Plug 'dense-analysis/ale'

" ------ cosmetics ------
Plug 'psliwka/vim-smoothie' " smud scrolling
Plug 'machakann/vim-highlightedyank'
Plug 'dylanaraps/wal.vim'
Plug 'chriskempson/base16-vim'
Plug 'lilydjwg/colorizer'
Plug 'mhinz/vim-startify' " start page
Plug 'Yggdroot/indentLine'

" ------ langs ------
" Plug 'dag/vim-fish'
" Plug 'cespare/vim-toml'
" Plug 'Vimjas/vim-python-pep8-indent'
" Plug 'vim-python/python-syntax'
" let g:python_highlight_all = 1
Plug 'rust-lang/rust.vim'
let g:rustfmt_autosave = 1
let g:polyglot_disabled = ['rust']
Plug 'sheerun/vim-polyglot'


" ------ LaTeX ------
Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }
" vimtex?

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

" Load preferred (base16) colorscheme or use term colors
if filereadable(expand('~/.config/nvim/theme.vim'))
    source `=expand('~/.config/nvim/theme.vim')`
else
    colorscheme wal
endif

" fixing tmux issue
if !has('nvim')
    set term=rxvt-unicode-256color
endif

" position visuals
set number
set relativenumber
" set cursorline (gotta customize colorscheme first)

" show whitespace - which wal.vim does not highlight...
" TODO: the NoText highlight does not work?
hi Whitespace ctermfg=DarkGray
hi NoText ctermfg=DarkGray
set list
" tab was ⇥  and I do not set space:·
" now tab should mimic the indentLine plugin
" ...removing trail:· too
set listchars=tab:¦\ ,eol:¬,extends:→,precedes:←

" status line
set showcmd " show what ye're typin'
set ruler " cursor pos - airline does this though
set laststatus=2 " always status line

" terminal title
set title

" }}}

" ------ Editor settings ------{{{

" lets you do 3x{ and 3x} in comments to enclose folds
" zo opens, za closes *all* under cursor, zc closes, and so on
set foldmethod=marker

set wildmenu " better command completion?
set wildmode=longest:full,full " longest match first, then full menu

" save undo history...
set undodir=~/.vimdid
set undofile

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

" Go to last open buffer (back-and-forth)
" - since <c-^> is literally impossible to press
"   on Scandinavian keyboards
nmap <Leader><Leader> <c-^>

" Quick write (shift+: then releasing shift and pressing w<CR> is HARD)
nmap <Leader>w :w<CR>

" Quickly turn off search highlighting
nmap <Leader>h :noh<CR>

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

" ------ Plugin settings ------

" ------ Various bindings ------{{{

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"  }}}

" ------ Counquer[or] of Completion (sic) ------{{{

" Recommended defaults that idk about
" see https://github.com/neoclide/coc.nvim#example-vim-configuration
set hidden
set shortmess+=c
" set nowritebackup and nobackup if things get messed up (tsserver?)

" Reduce delay
set updatetime=300

" signcolumn - the one next to line numbers by default
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" ------ keybinds ------{{{

" use tab like normal folks
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> <leader>gd <Plug>(coc-definition)
nmap <silent> <leader>gy <Plug>(coc-type-definition)
nmap <silent> <leader>gi <Plug>(coc-implementation)
nmap <silent> <leader>gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
" nmap <silent> <C-s> <Plug>(coc-range-select)
" xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" (see that section of the readme for more...)

"  }}}

"  }}}

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

" TODO: handle this in after/ftplugin or with a toggle command?
" autocmd BufWritePost *.md :!pandoc % -o /tmp/thing.pdf
command PDF :!pandoc %:t -o /tmp/thing.pdf
command TogglePDF autocmd BufWritePost *.md :!pandoc % -o /tmp/thing.pdf
command OpenPDF :!zathura /tmp/thing.pdf

" }}}

" ------ autopairs ------{{{

au FileType markdown,latex let b:AutoPairs = AutoPairsDefine({
\   '$' : '$', 
\   '$$' : '$$'
\}, [])

" examples in README
au FileType html let b:AutoPairs = AutoPairsDefine({'<!--' : '-->'}, [])
au FileType rust let b:AutoPairs = AutoPairsDefine({'\w\zs<': '>'})

" }}}

" ------ airline ------{{{

" glöphs
let g:airline_powerline_fonts = 1

" smoother separators
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''

" tabline ON
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let airline#extensions#tabline#show_buffers = 1 " ambivalent towards this
let g:airline#extensions#tabline#show_close_button = 0


" }}}

" ------ tmuxline ------{{{

" TODO do I really wanna use tmuxline?
" why not go for something simpler-looking?
" statusline content
" let g:tmuxline_preset = {
"       \'a'    : '#S',
"       \'win'  : '#I #W',
"       \'cwin' : '#I #W',
"       \'y'    : '#F',
"       \'z'    : '#H' }

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

nnoremap <Leader>fb :Buffers<CR>
nnoremap <Leader>ff :Files<CR>
nnoremap <Leader>fc :Commands<CR>
" Remember that :Rg exists (ripgrep)
nnoremap <Leader>r :Rg 

"  }}}

" ------ ALE ------{{{

" Airline integration
let g:airline#extensions#ale#enabled = 1

" lint
let g:ale_linters_explicit = 0

" fix
let g:ale_fix_on_save = 1

" see ftplugin files for linter/fixer rules

" }}}
