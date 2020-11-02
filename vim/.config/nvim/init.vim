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

" ------ Commands ------
Plug 'tpope/vim-repeat'
" use gc to comment/uncomment
Plug 'tpope/vim-commentary'
" use cp to copy and cv to paste
Plug 'christoomey/vim-system-copy'
" use gs to sort
Plug 'christoomey/vim-sort-motion'
" use alt-hjkl in insert/normal/visual mode
" to move line/selection in a direction
Plug 'matze/vim-move'

" ------ Text objects ------
" (s)urrounding (object/motion/command)
Plug 'tpope/vim-surround'
" consider Plug 'kana/vim-textobj-custom'
Plug 'michaeljsmith/vim-indent-object'
" (i)ndentation
" - ai for line above, aI for above+below
" - ii for just indent

" ------ Smart stuff ------
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
let g:rooter_patterns = [
            \ 'Makefile', 'CMakeLists.txt', 'package.json', 'cargo.toml',
            \ '.git', '.git/', '_darcs/', '.hg/', '.bzr/', '.svn/']
" TODO: configure this madness
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'justinmk/vim-sneak'
" mapped to s and S, less absurd than easymotion

" in this way it does not conflict with CoC
" (coc's snippets function messes with ultisnip code)
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" Let vim be affected by .editorconfig files
Plug 'editorconfig/editorconfig-vim'

" Better, more reliable folding
Plug 'konfekt/fastfold'

" ------ File finding ------
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" ------ Code completion ------
Plug 'neoclide/coc.nvim', { 'branch': 'release' }

" ------ Linting ------
Plug 'dense-analysis/ale'

" ------ Cosmetics ------
Plug 'psliwka/vim-smoothie' " smud scrolling
Plug 'machakann/vim-highlightedyank'
if filereadable(expand('~/git/wal.vim/colors/wal.vim'))
    Plug '~/git/wal.vim' " Use custom wal.vim tweaks
else " Use dylan's version :(
    Plug 'dylanaraps/wal.vim'
endif
Plug 'chriskempson/base16-vim'
Plug 'lilydjwg/colorizer' " hex colors
let g:startify_files_number = 8 " not loadeeeeed
Plug 'mhinz/vim-startify' " start page
Plug 'Yggdroot/indentLine'
Plug 'ryanoasis/vim-devicons'

" ------ Distraction-free writing ------
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'

" ------ Languages ------
Plug 'daveyarwood/vim-alda'
Plug 'aliou/bats.vim'
" Plug 'Vimjas/vim-python-pep8-indent'
" Plug 'vim-python/python-syntax'
" let g:python_highlight_all = 1
Plug 'rust-lang/rust.vim'
let g:rustfmt_autosave = 1
let g:polyglot_disabled = ['rust', 'markdown', 'pandoc', 'mma',
                        \  'plaintex', 'tex', 'plaintex', 'latex']
Plug 'sheerun/vim-polyglot'
Plug 'alx741/vim-hindent' " only a supplement to polyglot's default
let g:hindent_on_save = 0 " (disable since it puts you at start of file)

let java_highlight_functions="style" " uhhhh necessary?

" ------ LaTeX ------
Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }
Plug 'lervag/vimtex'

" ------ Markdown ------
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'dhruvasagar/vim-table-mode'
" use <Leader>tm to toggle

" ------ Miscellaneous ------
Plug 'aurieh/discord.nvim', { 'do': ':UpdateRemotePlugins'}

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

" NB: this is overridden by indentLine
set concealcursor=

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
set cursorline " (with custom colorscheme it looks ok)

" autoswitch relativenumber
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set number relativenumber
    autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber
augroup END

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

" Load abbreviation file
call typos#fixemall()

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

" Fix matlab files recognized as... mma?
augroup fixFiletype
    au!
    au BufRead,BufNewFile *.m set filetype=matlab
augroup END

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

" moving up/down, however...
nnoremap j gj
nnoremap k gk

" make use of ø
" map ø ;
" map Ø ,
" (since ; is in that spot on US layouts...)
" NEVER MIND, make use of å for that?
map å ;
map Å ,

" also let [ and ] be more accessible

map ø [
map æ ]
map Ø {
map Æ }

" Fix a pesky inconsistency (C is c$, D is d$)
nmap Y y$

" Insert blanks
nmap <CR> o<Esc>k
nmap <S-Enter> O<Esc>j

" Go to last open buffer (back-and-forth)
" - since <c-^> is literally impossible to press
"   on Scandinavian keyboards
nnoremap <Leader><Leader> <c-^>

" Quick write (shift+: then releasing shift and pressing w<CR> is HARD)
nnoremap <Leader>w :w<CR>
" Even quicker write (C-s like normal folks...)
nnoremap <C-s> :w<CR>

" Quickly turn off search highlighting
nnoremap <Leader>h :noh<CR>

" let &t_TI = '\<Esc>[>4;2m'
" let &t_TE = '\<Esc>[>4;m'
" tested with: vim -Nu NONE + 'nno <C-i> :echom "C-i"<cr>' +'nno <tab> :echom "Tab"<cr>'
" ...it didn't work, C-i is tied to TAB.

" Open/close folds about as fast as in orgmode
" nnoremap <TAB> za (this breaks C-i, and C-TAB isn't mappable)
nnoremap <S-TAB> zA

" Handle annoying typos
cabbrev Q q
cabbrev Q! q!
cabbrev wQ wq
cabbrev Wq wq
cabbrev WQ wq
cabbrev W w

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

" Preferred extensions (can be overridden)
" C/C++ and Haskell setups are configured in coc-config.json
let g:coc_global_extensions = [
    \ 'coc-snippets',
    \ 'coc-sh',
    \ 'coc-python',
    \ 'coc-rust-analyzer',
    \ 'coc-tsserver',
    \ 'coc-html',
    \ 'coc-css',
    \ 'coc-json',
    \ 'coc-vimtex',
    \ ]

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

" use it for snippets too?
let g:coc_snippet_next = '<tab>'

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
" Bind it!
nnoremap <Leader>F :call CocAction('format')<CR>

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" (see that section of the readme for more...)

"  }}}

"  }}}

" ------ Startify ------{{{

let g:mood_ascii = [
    \ '     ___  ________  ___________  ',
    \ '     |  \/  |  _  ||  _  |  _  \ ',
    \ '     | .  . | | | || | | | | | | ',
    \ '     | |\/| | | | || | | | | | | ',
    \ '     | |  | \ \_/ /\ \_/ / |/ /  ',
    \ '     \_|  |_/\___/  \___/|___/   ',
    \ ]

" Pretty sure none of startify's mappings are covered by this
" ...and i cannot use æøå since that messes with indent
let g:startify_custom_indices = ['f', 'd', 'g', 'h', 'a', 'l', 'w', 'o',
                              \  'o', 'p', 'u', 'r', 'c', 'n', 'x', 'm',
                              \  'D', 'A', 'F', 'T', 'E', 'L', 'K']

let g:startify_custom_header = startify#pad(g:mood_ascii)
" let g:startify_custom_header = startify#pad(split(system('fortune startify | figlet -f doom'), '\n'))

let g:startify_custom_footer = startify#pad(split(system('fortune quotes'), '\n'))

augroup startifyfixes
    autocmd!
    autocmd User Startified           setlocal cursorline
    autocmd User StartifyReady        :IndentLinesDisable
    autocmd User StartifyBufferOpened :IndentLinesEnable
augroup END

let g:startify_lists = [
    \ { 'header': ['   🟉🟊🟉 Recent 🟉🟊🟉'],                    'type': 'files' },
    \ { 'header': ['   🟉🟊🟉 Recent in '. getcwd() . ' 🟉🟊🟉'], 'type': 'dir' },
    \ { 'header': ['   🟉🟊🟉 Sessions 🟉🟊🟉'],                  'type': 'sessions' },
    \ ]

" Save session on exit (if this is a session)
let g:startify_session_persistence = 1

" Bindings for session saving/listing
nnoremap <leader>ls :SSave<CR>
nnoremap <leader>ll :SClose<CR>

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
let g:pandoc#folding#fastfolds = 1

" disable conceal for now...
" let g:pandoc#syntax#conceal#use = 0
" (or not)

" TODO: handle this in after/ftplugin or with a toggle command?
" autocmd BufWritePost *.md :!pandoc % -o /tmp/thing.pdf
" note: %:p gives full file path. vim-rooter messes with path.
command PDF :!pandoc %:p -o /tmp/thing.pdf
command TogglePDF autocmd BufWritePost *.md :!pandoc %:p -o /tmp/thing.pdf
command OpenPDF :!zathura /tmp/thing.pdf

" }}}

" ------ autopairs ------{{{

au FileType markdown,latex let b:AutoPairs = AutoPairsDefine({
\   '$' : '$',
\   '$$' : '$$'
\}, [])

" examples in README
au FileType vim let b:AutoPairs = AutoPairsDefine({'\^"': ''}, ['"']) " This does not fix everything though!
au FileType html let b:AutoPairs = AutoPairsDefine({'<!--' : '-->'}, [])
au FileType rust let b:AutoPairs = AutoPairsDefine({'\w\zs<': '>'})

" }}}

" ------ goyo ------{{{

nnoremap <Leader>gg :Goyo<CR>

let g:pandoc#folding#fdc = 0

function! s:goyo_enter()
    Limelight
    set nocursorline " (limelight is enough)
    " Disable linenumber toggle group
    " (for entire session, actually)
    autocmd! numbertoggle
    set nonumber norelativenumber
    " see https://github.com/junegunn/goyo.vim/issues/198
    set eventignore=FocusGained
    let g:pandoc#folding#fdc = 0
endfunction

function! s:goyo_leave()
    Limelight!
    set cursorline
    set number relativenumber
    set eventignore=
    let g:pandoc#folding#fdc = 1
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

"  }}}

" ------ airline ------{{{

" Avoid duplicate insert mode indicator
set noshowmode

" glöphs
let g:airline_powerline_fonts = 1

" smoother separators
let g:airline_right_sep = ''
let g:airline_left_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_left_alt_sep = ''

" Don't show annoying

" tabline ON
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#show_close_button = 0

" But only show bufferline when necessary!
let airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#buffer_min_count = 2

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
let $FZF_DEFAULT_COMMAND = 'fd --type f --hidden --follow -E node_modules -E .git -E out -E target -E .ccls-cache'

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
