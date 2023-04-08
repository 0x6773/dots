" 	~/.vimrc
"	Govind Sahai
"	@mnciitbhu
"	Copied from https://github.com/amix/vimrc/blob/master/vimrcs/basic.vim

" Copied from Vundle

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
" Plugin 'Valloric/YouCompleteMe'

Plugin 'morhetz/gruvbox'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" End Copy from Vundle

" let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.pyc'
" let g:gruvbox_contrast_dark = "soft"
colorscheme gruvbox

"	Set autoindent
set autoindent

"	Set
set ts=4

"	Sets how many lines of history VIM has to remember
set history=500

"	Enable filetype plugins
filetype plugin on
filetype indent on

"   Show Line Number
set number

"		Use system clipboard
set clipboard=unnamedplus

"	Set to auto read when a file is changed from the outside
set autoread

"	With a map leader it's possible to do extra key combinations
"	like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

"	Fast saving
nmap <leader>w :w!<cr>

"	:W sudo saves the file
command W w

"	:Q quits the file
command Q q

"	:wq sudo saves and quits the file
command Wq wq
command WQ wq

"	Set 7 lines to the cursor - when moving vertically using j/k
set so=7

"	Turn on the WiLd menu
set wildmenu

"	Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
else
    set wildignore+=.git\*,.hg\*,.svn\*
endif

"	Always show current position
set ruler

"	Height of the command bar
set cmdheight=2

"	A buffer becomes hidden when it is abandoned
set hid

"	Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

"	In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

"	Ignore case when searching
set ignorecase

"	When searching try to be smart about cases
set smartcase

"	Highlight search results
set hlsearch

"	Makes search act like search in modern browsers
set incsearch

"	Don't redraw while executing macros (good performance config)
set lazyredraw

"	For regular expressions turn magic on
set magic

"	Show matching brackets when text indicator is over them
set showmatch

"	How many tenths of a second to blink when matching brackets
set mat=2

"	No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

"  Tree
map <C-n> :NERDTreeToggle<CR>

"	Enable syntax highlighting
syntax enable

set background=dark

"	Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

"	Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile

"	Be smart when using tabs ;)
set smarttab

"	1 tab == 8 spaces
set tabstop=2
set softtabstop=2
set shiftwidth=2

"	Use tab
set noexpandtab

"	Linebreak on 500 characters
set lbr
" set tw=80

"set ai 		"Auto indent
set si 		"Smart indent
set wrap 	"Wrap lines

" folding
set foldmethod=marker
set foldmarker={,}
set nofoldenable
map <F7> za

"	Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :call VisualSelection('f', '')<CR>
vnoremap <silent> # :call VisualSelection('b', '')<CR>

"	Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

"	Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

"	Close the current buffer
map <leader>bd :Bclose<cr>

"	Close all the buffers
map <leader>ba :1,1000 bd!<cr>

"	Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>t<leader> :tabnext

"	Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()


"	Opens a new tab with the current buffer's path
"	Super useful when editing files in the same directory
map <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/

"	Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

"	Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

"	Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
"	Remember info about open buffers on close
set viminfo^=%

"	Always show the status line
set laststatus=2

"	Remap VIM 0 to first non-blank character
map 0 ^

"	Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()

"   bindings to move between windows
map <F2> :tabn<cr>
map <F1> :tabp<cr>


"	When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>

"	Quickly open a buffer for scribble
map <leader>q :e ~/buffer<cr>

"	Quickly open a markdown buffer for scribble
map <leader>x :e ~/buffer.md<cr>

"	Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>

"	Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l

"	Helper Functions
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("Ack \"" . l:pattern . "\" " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction


" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    en
    return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction


"Remove all trailing whitespace by pressing F5
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
let g:ycm_server_keep_logfiles = 1 
let g:ycm_server_log_level = 'debug'
