" .vim in ~/.config/nvim/.vim
set runtimepath^=~/.config/nvim/.vim runtimepath+=~/.config/nvim/.vim/after
let &packpath = &runtimepath

" Required options
let mapleader=" "
set nocompatible
set shell=fish
set tw=0
filetype off
set clipboard=unnamedplus
set backspace=indent,eol,start
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=0
set guicursor=i:ver100-iCursor
set mouse=a
set nobackup
set nowritebackup
set noerrorbells
set noswapfile
set undofile
set undodir="~/.cache"

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" Requiered
Plugin 'gmarik/Vundle.vim'
"Cmp
Plugin 'hrsh7th/nvim-cmp'
Plugin 'hrsh7th/cmp-path'
Plugin 'hrsh7th/cmp-buffer'
Plugin 'hrsh7th/cmp-cmdline'
Plugin 'saadparwaiz1/cmp_luasnip'
Plugin 'hrsh7th/cmp-nvim-lsp'
"Snippets
Plugin 'L3MON4D3/LuaSnip'
Plugin 'rafamadriz/friendly-snippets'
"LSP
Plugin 'neovim/nvim-lspconfig'
Plugin 'williamboman/nvim-lsp-installer'
Plugin 'jose-elias-alvarez/null-ls.nvim'
"syntax highlighting
Plugin 'nvim-treesitter/nvim-treesitter'
"Autopair brackets
Plugin 'windwp/nvim-autopairs'
"Comments
Plugin 'numToStr/Comment.nvim'
"Toggle term
Plugin 'akinsho/toggleterm.nvim'
" Org mode
Plugin 'nvim-orgmode/orgmode'
Plugin 'akinsho/org-bullets.nvim'
"Markdown editing
Plugin 'ixru/nvim-markdown'
"Themes
" Bufferline
Plugin 'akinsho/bufferline.nvim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'catppuccin/nvim', {'name': 'catppuccin'}
Plugin 'nvim-telescope/telescope.nvim'
Plugin 'vim-scripts/indentpython.vim'
"Plugin 'plasticboy/vim-markdown'
" Plugin 'preservim/nerdtree'
Plugin 'kyazdani42/nvim-tree.lua'
Plugin 'ryanoasis/vim-devicons'
Plugin 'kdheepak/lazygit.nvim'
Plugin 'Pocco81/TrueZen.nvim'
" Plugin 'junegunn/goyo.vim'
" Plugin 'mattn/emmet-vim'
" Plugin 'lervag/vimtex'
" Plugin 'donRaphaco/neotex'
Plugin 'glepnir/dashboard-nvim'
Plugin 'folke/which-key.nvim'
"Dependencies
Plugin 'nvim-lua/plenary.nvim'
" Plugin 'ryanoasis/vim-devicons'
Plugin 'tpope/vim-fugitive'
"Discord presence
Plugin 'andweeb/presence.nvim'
call vundle#end()
filetype plugin indent on
let python_highlight_all=1
let g:tex_flavor = "latex"
let g:dashboard_default_executive='telescope'


" Airline
let g:airline_theme='deus'
let g:airline_powerline_fonts = 1
let g:airline_detect_modified = 1
let g:airline#extensions#branch#enabled=1
let g:airline#extensions#hunks#enabled=0
let g:airline#extensions#branch#vcs_checks = ['untracked', 'dirty']
let g:airline#extensions#whitespace#enabled = 1
let g:airline#extensions#tagbar#flags = 'f' " show the full tag hierarchy
let g:airline#extensions#hunks#enabled = 0
let g:airline_mode_map = {
      \ 'n'  : 'N',
      \ 'i'  : 'I',
      \ 'R'  : 'R',
      \ 'v'  : 'V',
      \ 'V'  : 'VL',
      \ 'c'  : 'CMD',
      \ }
" Just show the file name
let g:airline#extensions#default#layout = [
      \ [ 'a', 'b', 'c' ],
      \ [ 'x', 'y', 'z' ]
      \ ]
let g:airline_section_c = '%t'
let g:airline_section_y = ''
let g:airline_section_z = '%3p%% %#__accent_bold#%4l%#__restore__#:%3'
let g:airline_section_z = '%3p%%'

" Mappings
nnoremap S :%s//g<Left><Left>
map N :norm 
nnoremap <leader>dl <cmd>g/^$/d<cr>
map <leader>n :NvimTreeToggle<CR>
map <leader>zz :TZAtaraxis<CR>
map <leader>zm :TZMinimal<CR>
map <leader>a :%s/->/→/g<CR>
map <leader>c :w<CR> :Compile<CR>
map <leader>s :setlocal spell!<CR>
map <leader>x ddp
nnoremap <silent> <leader>g :LazyGit<CR>

nmap <Leader>ss :<C-u>SessionSave<CR>
nmap <Leader>sl :<C-u>SessionLoad<CR>
nnoremap <silent> <Leader>fh :DashboardFindHistory<CR>
nnoremap <silent> <Leader>ff :DashboardFindFile<CR>
nnoremap <silent> <Leader>fa :DashboardFindWord<CR>
nnoremap <silent> <Leader>fb :DashboardJumpMark<CR> nnoremap <silent> <Leader>fn :DashboardNewFile<CR>

nnoremap <silent> <Leader>tc :DashboardChangeColorscheme<CR>
nnoremap <leader>tr <cmd>set rnu!<cr>
nnoremap <leader>tn <cmd>set nu!<cr>

nnoremap <leader>p <cmd>Format<cr>

nnoremap <leader>P :lua require("nabla").popup()<CR>

" Move around in windows
nnoremap <C-h> <C-W>h
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l

" Bufferline
nnoremap <silent>L :BufferLineCycleNext<CR>
nnoremap <silent>H :BufferLineCyclePrev<CR>
nnoremap <silent>ctrl+shift+l :BufferLineMoveNext<CR>
nnoremap <silent>ctrl+shift+h :BufferLineMovePrev<CR>
nnoremap <silent><C-q> :BufferLineCloseLeft<CR>
nnoremap <silent><C-w> :BufferLineCloseRight<CR>

" Misc settings
syntax enable
" Hide statusline



let g:vim_markdown_math = 1
let g:vim_markdown_folding_disabled = 1

let g:dashboard_custom_header = [
   \'        ▄▄▄▄▄███████████████████▄▄▄▄▄     ',
   \'      ▄██████████▀▀▀▀▀▀▀▀▀▀██████▀████▄   ',
   \'     █▀████████▄             ▀▀████ ▀██▄  ',
   \'    █▄▄██████████████████▄▄▄         ▄██▀ ',
   \'     ▀█████████████████████████▄    ▄██▀  ',
   \'       ▀████▀▀▀▀▀▀▀▀▀▀▀▀█████████▄▄██▀    ',
   \'         ▀███▄              ▀██████▀      ',
   \'           ▀██████▄        ▄████▀         ',
   \'              ▀█████▄▄▄▄▄▄▄███▀           ',
   \'                ▀████▀▀▀████▀             ',
   \'                  ▀███▄███▀                ',
   \'                     ▀█▀                   ',
   \ ]
let g:dashboard_custom_shortcut={
\ 'last_session'       : 'SPC s l',
\ 'find_history'       : 'SPC f h',
\ 'find_file'          : 'SPC f f',
\ 'new_file'           : 'SPC f n',
\ 'change_colorscheme' : 'SPC t c',
\ 'find_word'          : 'SPC f a',
\ 'book_marks'         : 'SPC f b',
\ }

let g:vimtex_compiler_enabled = 1
let g:vimtex_compiler_progname = 'nvr'
let g:livepreview_previewer = 'zathura'
let g:vimtex_view_general_viewer = 'zathura'
set nu
set relativenumber
set cursorline
set smartcase
set autoread
set incsearch
set hidden
set linebreak
set wildmenu
set termguicolors
syntax on
set laststatus=2
set background=dark
set tabstop=4
set softtabstop=4
set shiftwidth=4
"colorscheme default
"imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")
au BufNewFile,BufRead *.md
    \ hi StatusLineNC ctermfg=white |
    \ set nonu |
    \ imap
au BufNewFile,BufRead *.py
    \ set expandtab |
    \ set autoindent |
    \ map <F5> :w<CR> :!st -e python3 %:p<CR>
au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2
    \ set softtabstop=2
    \ set shiftwidth=2
set encoding=utf-8
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree
hi StatusLine ctermbg=none cterm=bold

" Automatic commands
" autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritepre * %s/\n\+\%$//e

" Custom commands
command! Compile !compiler %:p

colorscheme catppuccin

" Return the cursor to a bar after exiting
au VimLeave * set guicursor=a:ver2-blinkon0

" Lua
lua << EOF

require "user.cmp"
require "user.lsp"
require "user.whichkey"
require "user.treesitter"
require "user.autopairs"
require "user.comment"
require "user.toggleterm"
require "user.nvim-tree"
require "user.bufferline"
require "user.orgmode"
require "user.zen"

EOF
