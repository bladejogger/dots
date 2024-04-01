"static color choice to be displayed
colorscheme slate

"always show cursor location
set ruler          

"when searching: 'l' matches all, 'L' matches uppercase
set ignorecase
set smartcase

"when searching: move cursor to matching string as you type
set incsearch

"display relative line numbers
set relativenumber 

"display current line number
set number

"highlight space before width end
set colorcolumn=79 

"wrap lines at 79 characters
set textwidth=79

"no bells: eb = errorbell, vb = visualbell
set noeb
set novb 

"key binding
noremap <up> <nop>
noremap <down> <nop>
noremap <right> <nop>
noremap <left> <nop>
"deal with 'system reboot' wall messages
noremap <F6> :redraw!<cr>

"programming: keyword coloring
syntax on

"auto-indent for programming
filetype plugin indent on

"all tabs are 4 spaces
set tabstop=8
set shiftwidth=4
set expandtab
set softtabstop=4
set smarttab
set autoindent

"save history when switching buffers
set hidden

"show matching parens, brackets, etc
set showmatch

"filename in title bar
set title

"prevent incorrect exit spellings
command! W w
command! Q q
command! Wq wq
command! WQ wq
