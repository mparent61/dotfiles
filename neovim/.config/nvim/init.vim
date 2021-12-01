" Mike's Neovim Config
"
"======================================================================
call plug#begin('~/.local/share/nvim/plugged')

"Plug 'davidhalter/jedi-vim'

" Git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'

Plug 'will133/vim-dirdiff'
Plug 'justinmk/vim-sneak'

Plug 'lifepillar/vim-solarized8'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'hashivim/vim-terraform'

Plug 'idbrii/itchy.vim'  " Scratch buffer

call plug#end()


"======================================================================
" Leader keys
let mapleader = "\<Space>"
let maplocalleader = "\\"


"======================================================================
" Save/Quit
command! Q q            " Case insensitive Quit
command! W wqa          " Easy write/quit/all!
nmap <leader>w :w!<CR>  " Force write current file
nmap <leader>x :x<CR>
nmap <leader>q :xa<CR>
nmap <leader>o :only<CR>
au FocusLost * silent! :wa    " Auto-save everything on lost focus
" Force-save file (useful if forget to run vim w/ sudo)
" http://stackoverflow.com/questions/1005/getting-root-permissions-on-a-file-inside-of-vi
cmap w!! w !sudo tee >/dev/null %

" Quick-open Neovim config
nnoremap <silent> <leader>E :e $MYVIMRC<cr>

"======================================================================
" Colorscheme
set background=light
let g:solarized_use16=1
colorscheme solarized8
" Make sure NVIM recognizes 256-color support. Especially important for iTerm2
if $TERM == "xterm-256color" || $TERM == "screen-256color"
    set t_Co=256
endif

"======================================================================
" Editing
set noswapfile
set nobackup                " No backups left after done editing
set smartcase               " case-sensitive search if 1+ letters are uppercase
set autoread                " Don't bother me when a file changes
set autowriteall            " Save as often as possible

" Copy/Paste
set clipboard+=unnamedplus  " Wire up to system clipboard
" Highlight yanked text
augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
augroup END


" Search
set ignorecase              " Case insensitive
set incsearch               " Search as you type
set hlsearch                " Highlight all search term matches
"set infercase               " Completion recognizes capitalization

" Line Numbers - shows relative numbering with current line's absolute number
set relativenumber
set number

" Whitespace
set expandtab               " No tabs by default
set softtabstop=4
set shiftwidth=4            " Number of spaces to shift for autoindent or >,<
set tabstop=4               " The One True Tab

" Diffs
set diffopt+=vertical           " Prefer vertical diff splits

"---------- Whitespace ----------
" Delete trailing whitespace on save
function! DeleteTrailingWhitespace()
    " Save current cursor position
    let save_cursor = getpos(".")
    " Save last search
    let _s=@/
    " Delete empty lines at end of file
    :silent! %s#\($\n\s*\)\+\%$##
    " Delete trailing whitepace and ^M (in non-empty lines)
    :silent! %s/\(\|\s\)\+$//e
    " Restore last search
    let @/=_s
    " Restore cursor
    call setpos('.', save_cursor)
endfunction
autocmd BufWritePre *.py,*.mako,*.js,*.css,*.tf,*.vim call DeleteTrailingWhitespace()
nnoremap <leader>W :call DeleteTrailingWhitespace()<CR>

"======================================================================
" Autocorrections
" My Nemesis!
iab recieve receive
iab Recieve Receive
iab RECIEVE RECEIVE
iab recieved received
iab Recieved Received
iab RECIEVED RECEIVED
" Convenience
iab TD TODO

"======================================================================
" Undo is great!
set undofile
set undolevels=1000    " Max changes that can be undone
set undoreload=10000   " Max number of lines to save for undo on buffer reload
set undodir=~/.config/nvim/tmp/undo
if ! isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif


"======================================================================
" Python
let g:python3_host_prog = "~/.virtualenvs/neovim/bin/python"

"======================================================================
" CoC
" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

"======================================================================
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<tab>'

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

"======================================================================
" Fugitive
nnoremap <leader>gs :G<CR>
nnoremap <leader>gc :Git commit<CR>
nnoremap <leader>gC :Git commit --no-verify -q<CR>
nnoremap <leader>gd :Gdiff<CR>

" FZF
" Repository siblings - Automatically find parent directory of my root Git project
function! s:find_git_root()
  return system('git rev-parse --show-toplevel 2> /dev/null')[:-2]
endfunction

command! FZFRepoFiles execute 'Files' s:find_git_root()
command! FZFSiblingRepoFiles execute 'Files' fnamemodify(s:find_git_root(), ':h')


let fzf_rg_base_command = 'rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore-vcs --hidden --follow --glob "!.git/*" --color "always" '

command! -bang -nargs=* FZFRg
  \ call fzf#vim#grep(fzf_rg_base_command.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview({'options': []}, 'up:60%', 'ctrl-p'), <bang>0)
" Same as above but with <cword> option
command! -bang -nargs=* FZFRgCurrentWord
  \ call fzf#vim#grep(fzf_rg_base_command.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview({'options': ['-q', expand('<cword>')]}, 'up:60%', 'ctrl-p'), <bang>0)

au FileType * call SetFzfRgCurrentTypeCommand()
function! SetFzfRgCurrentTypeCommand()
	command! -bang -nargs=* FZFRgCurrentType
	\ call fzf#vim#grep((fzf_rg_base_command."--type " . &filetype . " ").shellescape(<q-args>), 1,
	\   fzf#vim#with_preview({'options': []}, 'up:60%', 'ctrl-p'), <bang>0)
    " Same as above but with <cword> option
	command! -bang -nargs=* FZFRgCurrentTypeAndWord
	\ call fzf#vim#grep((fzf_rg_base_command."--type " . &filetype . " ").shellescape(<q-args>), 1,
	\   fzf#vim#with_preview({'options': ['-q', expand('<cword>')]}, 'up:60%', 'ctrl-p'), <bang>0)
endfunction


nnoremap <silent> <leader>f :FZFRepoFiles<CR>
nnoremap <silent> <leader>F :FZFSiblingRepoFiles<CR>
nnoremap <silent> <leader>a :FZFRg<CR>
nnoremap <silent> <leader>A :FZFRgCurrentWord<CR>
nnoremap <silent> <localleader>a :FZFRgCurrentType<CR>
nnoremap <silent> <localleader>A :FZFRgCurrentTypeAndWord<CR>
" Search for word under cursor
nnoremap <silent> ; :Buffers<CR>


" Terraform
let g:terraform_fmt_on_save = 1
