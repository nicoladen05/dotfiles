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
set clipboard+=unnamedplus

" Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'plasticboy/vim-markdown'
Plugin 'junegunn/goyo.vim'
Plugin 'mattn/emmet-vim'
Plugin 'lervag/vimtex'
call vundle#end()
filetype plugin indent on
let python_highlight_all=1
let g:tex_flavor = "latex"


" Mappings
nnoremap S :%s//g<Left><Left>
nmap <leader>g :Goyo<CR>
map q <Nop>
map Q <Nop>
map <leader>a :%s/->/→/g<CR>
map ,c :lcl<CR> :pc<CR> :cclose<CR>


" Misc settings
let g:goyo_width = "70%"
let g:goyo_height = "80%"
let g:vim_markdown_folding_disabled = 1

let g:vimtex_compiler_enabled = 1
let g:vimtex_compiler_progname = 'nvr'
let g:vimtex_view_general_viewer = 'okular'
set nu
set relativenumber
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
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix
au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2
    \ set softtabstop=2
    \ set shiftwidth=2
set encoding=utf-8
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree
hi StatusLine ctermbg=none cterm=bold

" Automatic commands
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritepre * %s/\n\+\%$//e

" Custom commands
command! Compile !pdflatex %:p|!biber file|!pdflatex %:p
