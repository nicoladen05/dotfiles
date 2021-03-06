" .vim in ~/.config/nvim/.vim
set runtimepath^=~/.config/nvim/.vim runtimepath+=~/.config/nvim/.vim/after
let &packpath = &runtimepath

" Required options
let mapleader = ","
set nocompatible
set shell=bash
set tw=0
filetype off
set clipboard=unnamedplus
set backspace=indent,eol,start
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=0
set guicursor=i:ver100-iCursor

" Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'plasticboy/vim-markdown'
Plugin 'preservim/nerdtree'
Plugin 'junegunn/goyo.vim'
Plugin 'mattn/emmet-vim'
Plugin 'lervag/vimtex'
call vundle#end()
filetype plugin indent on
let python_highlight_all=1
let g:tex_flavor = "latex"

" Mappings
nnoremap S :%s//g<Left><Left>
nmap <leader>n :NERDTreeToggle<CR>
nmap <leader>g :Goyo<CR>
nmap <leader>a :%s/->/→/g<CR>
nmap <leader>c :w<CR> :Compile<CR>
nmap j gj
nmap k gk
nmap J <down>
nmap K <up>


" Misc settings
let g:goyo_width = "60%"
let g:goyo_height = "80%"
let g:vim_markdown_folding_disabled = 1
let g:NERDTreeWinPos = "right"

let g:vimtex_compiler_enabled = 1
let g:vimtex_compiler_progname = 'nvr'
let g:vimtex_view_general_viewer = 'okular'
set nu
set relativenumber
set linebreak
syntax on
set laststatus=2
set background=dark
colorscheme default
"imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")
au BufNewFile,BufRead *.md
    \ hi StatusLineNC ctermfg=white |
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set nonu |
    \ imap
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |
    \ map <F5> :w<CR> :!alacritty -e python3 %:p<CR>
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
