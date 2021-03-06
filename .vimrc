execute pathogen#infect()
          
filetype plugin indent on	    " enable auto-indent plugin

set number                      " Show line numbers
set backspace=indent,eol,start  " Makes backspace key more powerful.
set showcmd                     " Show me what I'm typing
set showmode                    " Show current mode.

" python
au BufNewFile,BufRead *.py set tabstop=4
au BufNewFile,BufRead *.py set softtabstop=4
au BufNewFile,BufRead *.py set shiftwidth=4
au BufNewFile,BufRead *.py set textwidth=79
au BufNewFile,BufRead *.py set expandtab
au BufNewFile,BufRead *.py set autoindent
au BufNewFile,BufRead *.py set fileformat=unix

" yaml
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

set foldmethod=indent
set foldlevel=99
nnoremap <space> za

" highlight scheme for trailing whitespace
highlight BadWhitespace ctermbg=red guibg=red
" ensure it doesn't get cleared by future colorscheme defenition
" (http://vim.wikia.com/wiki/Highlight_unwanted_spaces#Highlighting_with_the_match_command)
autocmd ColorScheme * highlight BadWhitespace ctermbg=red guibg=red
" match whitespaces to the highlight
match BadWhitespace /\s\+$/

set incsearch                   " Shows the match while typing search pattern
set hlsearch			        " Highlight found searches
set ignorecase                  " Search case insensitive...
set smartcase                   " ... but not when search pattern contains upper case characters

set nocursorcolumn
set nocursorline

" Make Vim to handle long lines nicely.
set wrap
set textwidth=79
set formatoptions=qrn1

set display+=lastline           " prevent long lines to be @'ed

" airline & theme config
syntax enable
set background=dark
let g:solarized_termcolors=256
let g:solarized_termtrans=1
let g:airline_theme='base16'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tmuxline#enabled = 0
colorscheme solarized

" indent & tab
set autoindent                  " use previous the line's indent width
set showmatch                   " jump to matching brace
set complete-=i                 " do not scan include files. See https://medium.com/usevim/set-complete-e76b9f196f0f
set smarttab                    " smarter bckspace for <tab>'s. http://vimdoc.sourceforge.net/htmldoc/options.html#'smarttab'

" map pastetoggle
set pastetoggle=<F2>

" key mapping
map <C-w>=  <C-w>s	        	" map these similar to tmux split using '=' and ' " '
map <C-w>" <C-w>v               " ... and escape the pipe

map <C-j> <C-W>j                " easy move between panes
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

nnoremap <C-x> :bnext<CR>       " easy switching betweeb buffers
nnoremap <C-z> :bprev<CR>

" Allow saving of files as sudo when I forgot to start vim using sudo. See http://vim.wikia.com/wiki/Su-write
cmap w!! w !sudo tee > /dev/null %
set t_Co=256
