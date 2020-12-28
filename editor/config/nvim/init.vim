"
"    _____  _________  _                  _
"   |_   _||  _   _  || |                (_)
"     | |  |_/ | | \_|\_|.--.    _   __  __   _ .--..--.   _ .--.  .---.
" _   | |      | |      ( (`\]  [ \ [  ][  | [ `.-. .-. | [ `/'`\]/ /'`\]
"| |__' |     _| |_      `'.'.   \ \/ /  | |  | | | | | |  | |    | \__.
"`.____.'    |_____|    [\__) )   \__/  [___][___||__||__][___]   '.___.'
"
" Author: Julian True
" repo  : https://github.com/juliantrue/dotfiles/"
"
" Fish doesn't play all that well with others
set shell=/bin/bash
let mapleader = "\<Space>"

" =============================================================================
" # PLUGINS
" =============================================================================
" Load vundle
set nocompatible
filetype off
set rtp+=~/dev/others/base16/builder/templates/vim/
call plug#begin()

" Load plugins
" VIM enhancements
Plug 'ciaranm/securemodelines'
Plug 'sbdchd/neoformat'
Plug 'editorconfig/editorconfig-vim'
Plug 'justinmk/vim-sneak'

" GUI enhancements
Plug 'machakann/vim-highlightedyank'
Plug 'andymass/vim-matchup'

" Theme
Plug 'mhartington/oceanic-next'

" Fuzzy finder
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Semantic language support
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Syntactic language support
Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'
Plug 'rust-lang/rust.vim'
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'} " Python
Plug 'dag/vim-fish'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'ekalinin/Dockerfile.vim'

" Python Black for code formatting
Plug 'psf/black'

call plug#end()

" Colors are a pain
"if (match($TERM, "-256color") != -1) && (match($TERM, "screen-256color") == -1)
  " screen does not (yet) support truecolor
set termguicolors
"endif
 
syntax enable
let g:one_allow_italics = 1
let g:oceanic_next_terminal_bold = 1
let g:oceanic_next_terminal_italic = 1
colorscheme OceanicNext

set mouse=a
set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20
set clipboard+=unnamedplus
set nopaste
set noswapfile
filetype on
set  number
set tabstop=2 shiftwidth=2 expandtab

" =============================================================================
" System mappings
" =============================================================================

" No need for ex mode
nnoremap Q <nop>
vnoremap // y/<C-R>"<CR>
" recording macros is not my thing
map q <Nop>

noremap H ^
noremap L g_
noremap J 5j
noremap K 5k


" Copy to osx clipboard
vnoremap <C-c> "*y<CR>
vnoremap y "*y<CR>
noremap Y y$
vnoremap y myy`y
vnoremap Y myY`y

noremap <leader>p :read !xsel --clipboard --output<cr>
noremap <leader>c :w !xsel -ib<cr><cr>

" Persistent undos
set undodir=~/.vimdid
set undofile

" Syntax settings
filetype plugin indent on
set autoindent
set nowrap

let g:secure_modelines_allowed_items = [
                \ "textwidth",   "tw",
                \ "softtabstop", "sts",
                \ "tabstop",     "ts",
                \ "shiftwidth",  "sw",
                \ "expandtab",   "et",   "noexpandtab", "noet",
                \ "filetype",    "ft",
                \ "foldmethod",  "fdm",
                \ "readonly",    "ro",   "noreadonly", "noro",
                \ "rightleft",   "rl",   "norightleft", "norl",
                \ "colorcolumn"
                \ ]

" =============================================================================
" System mappings
" =============================================================================

" Convert : -> ;
nnoremap ; :

" Ctrl+c and Ctrl+j as Esc
" Ctrl-j is a little awkward unfortunately:
" https://github.com/neovim/neovim/issues/5916
" So we also map Ctrl+k
inoremap <C-j> <Esc>

nnoremap <C-k> <Esc>
inoremap <C-k> <Esc>
vnoremap <C-k> <Esc>
snoremap <C-k> <Esc>
xnoremap <C-k> <Esc>
cnoremap <C-k> <Esc>
onoremap <C-k> <Esc>
lnoremap <C-k> <Esc>
tnoremap <C-k> <Esc>

" Ctrl+h to stop searching
vnoremap <C-h> :nohlsearch<cr>
nnoremap <C-h> :nohlsearch<cr>


" =============================================================================
" Plugin Settings
" =============================================================================

let g:black_linelength = 88 " PEP8 is great, but not as great as 88
let g:python3_host_prog = "/usr/bin/python3"

" Run Black on save
autocmd BufWritePre *.py execute ':Black' 
