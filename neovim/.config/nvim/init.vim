" Mike's Neovim Config
"
"======================================================================

" Vim-Plug automatic installation
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.local/share/nvim/plugged')

" Git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'

Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'

Plug 'will133/vim-dirdiff'
Plug 'justinmk/vim-sneak'

Plug 'bkad/CamelCaseMotion'

Plug 'lifepillar/vim-solarized8'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'mbbill/undotree'

""" Scratch buffer
Plug 'mtth/scratch.vim'

Plug 'romainl/vim-cool'   " Disable search highlighting when not searching

" Yank Ring
Plug 'bfredl/nvim-miniyank'

" Python
Plug 'psf/black', { 'branch': 'main' }
Plug 'fisadev/vim-isort'
Plug 'tell-k/vim-autoflake'

Plug 'airblade/vim-rooter'  " Set working directory to current file's repository root

" """ Markdown
" mparent(2022-01-10): - causes error during `checkhealth` about missing group `markdownError`
"Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'itspriddle/vim-marked', { 'for': 'markdown' }  " Integration with Marked2 viewer

" JSONC
Plug 'neoclide/jsonc.vim'

Plug 'hashivim/vim-terraform'


Plug 'rhysd/conflict-marker.vim'

call plug#end()


"======================================================================
" Leader keys
let mapleader = "\<Space>"
let maplocalleader = "\\"


"======================================================================
" File/Buffer Management
command! Q q            " Case insensitive Quit
command! W wqa          " Easy write/quit/all!
nmap <leader>w :wa!<CR>  " Force write all files
nmap <leader>x :x<CR>
nmap <leader>q :xa<CR>
nmap <leader>o :only<CR>
au FocusLost * silent! :wa    " Auto-save everything on lost focus
" Force-save file (useful if forget to run vim w/ sudo)
" http://stackoverflow.com/questions/1005/getting-root-permissions-on-a-file-inside-of-vi
cmap w!! w !sudo tee >/dev/null %

" Open previous buffer
nmap <C-e> :e#<CR>

" Quick-open Neovim config
nnoremap <silent> <leader>E :e $MYVIMRC<cr>

"======================================================================
" Colorscheme
set background=dark
let g:solarized_use16=1
let g:solarized_italics=0  " Prevent ugly gray highlight with 16-color mode
colorscheme solarized8
" Make sure NVIM recognizes 256-color support. Especially important for iTerm2
if $TERM == "xterm-256color" || $TERM == "screen-256color"
    set t_Co=256
endif

"---------- NetRW ----------
" Allow removal of non-empty local directories
let g:netrw_localrmdir="rm -r"
" Fixes file/copy commands by having current directory track browsing directory (see "help netrw-c")
"let g:netrw_keepdir=0

"======================================================================
" Editing
set noswapfile
set smartcase               " case-sensitive search if 1+ letters are uppercase
set backup
set backupdir=$HOME/tmp/nvim
set autoread                " Don't bother me when a file changes
set autowriteall            " Save as often as possible

" Copy/Paste
set clipboard+=unnamedplus  " Wire up to system clipboard
" Highlight yanked text
augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank { higroup='IncSearch', timeout=200 }
augroup END

" Windows
set equalalways                " New windows/splits are equal size
autocmd VimResized * wincmd =  " Always equalize windows on resize

" Find/Replace
set ignorecase              " Case insensitive
set incsearch               " Search as you type
set hlsearch                " Highlight all search term matches
"set infercase               " Completion recognizes capitalization
set gdefault                " :sub "all" flag on by default (don't need add 'g' on end of searches

set scrolloff=3   " Auto-scroll to show extra lines above/below current line

" Line Numbers - shows relative numbering with current line's absolute number
set relativenumber
set number

" Whitespace
set expandtab               " No tabs by default
set softtabstop=4
set shiftwidth=4            " Number of spaces to shift for auto-indent or >,<
set tabstop=4               " The One True Tab
set breakindent             " Wrapped text matches indent of line above
" Line-break marker
set showbreak=↪\            " Note: there's a trailing <Space> after the slash

"======================================================================
" Diffs
" Toggle some options that depend on whether we're in diff mode or not
function! ToggleDiffOptions()
    if &diff
        " Cursorline + Colorcolumn conflict with solarized colors
        setlocal nocursorline
        setlocal colorcolumn=
    else
        setlocal cursorline
        setlocal colorcolumn=+1
    endif
endfunction

augroup DiffModeOptions
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter,FilterWritePre,FilterWritePost * call ToggleDiffOptions()
    " Only show cursorline in active window
    autocmd WinLeave * setlocal nocursorline
augroup END

function! DiffToggle()
    if &diff
        " Turn off diff in all windows in current tab
        diffoff!
    else
        diffthis
    endif
endfunction

function! DiffWhitespaceToggle()
    if &diffopt =~ 'iwhite'
        set diffopt-=iwhite
    else
        set diffopt+=iwhite
    endif
endfunction
"
set diffopt+=vertical           " Prefer vertical diff splits

nnoremap <silent> <Leader>dt :call DiffToggle()<CR>
nnoremap <silent> <Leader>dw :call DiffWhitespaceToggle()<CR>

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
autocmd BufWritePre *.py,*.mako,*.js,*.css,*.tf,*.vim,*.yaml call DeleteTrailingWhitespace()
nnoremap <leader>W :call DeleteTrailingWhitespace()<CR>

"======================================================================
" Spelling
"
set spell spelllang=en_us

" Autocorrections
" My Nemesis!
iab recieve receive
iab Recieve Receive
iab RECIEVE RECEIVE
iab recieved received
iab Recieved Received
iab RECIEVED RECEIVED

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
" Providers
let g:python3_host_prog = "~/.virtualenvs/neovim/bin/python"
" Disabled (don't use these yet, makes `checkhealth` cleaner)
let g:loaded_node_provider = 0
let g:loaded_perl_provider = 0
let g:loaded_python_provider = 0  " Disable Python 2 (not installed on lastest OSX)
let g:loaded_ruby_provider = 0

"======================================================================
" Treesitter - WIP

" lua <<EOF
" require'nvim-treesitter.configs'.setup {
"   -- A list of parser names, or "all"
"   ensure_installed = { "python" },

"   -- Install parsers synchronously (only applied to `ensure_installed`)
"   sync_install = false,

"   -- Automatically install missing parsers when entering buffer
"   -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
"   auto_install = true,

"   -- List of parsers to ignore installing (for "all")
"   ignore_install = { "javascript" },

"   ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
"   -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

"   highlight = {
"     -- `false` will disable the whole extension
"     enable = true,

"     -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
"     -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
"     -- the name of the parser)
"     -- list of language that will be disabled
"     disable = { "c", "rust" },
"     -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
"     disable = function(lang, buf)
"         local max_filesize = 100 * 1024 -- 100 KB
"         local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
"         if ok and stats and stats.size > max_filesize then
"             return true
"         end
"     end,

"     -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
"     -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
"     -- Using this option may slow down your editor, and you may see some duplicate highlights.
"     -- Instead of true it can also be a list of languages
"     additional_vim_regex_highlighting = false,
"   },
" }
" EOF

"======================================================================
" Autoflake
" TODO: Move to ftplugin/python.vim ?
let g:autoflake_remove_all_unused_imports=1
let g:autoflake_remove_unused_variables=1
let g:autoflake_disable_show_diff=1

"---------- CamelCaseMotion ----------
map W <Plug>CamelCaseMotion_w
map B <Plug>CamelCaseMotion_b
map E <Plug>CamelCaseMotion_e
sunmap W
sunmap B
sunmap E

"======================================================================
" CoC
"----------------------------------------------------------------------

" Use <tab> and <S-tab> to navigate completion list: >
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction
" Insert <tab> when previous text is space, refresh completion if not.
inoremap <silent><expr> <TAB>
    \ coc#pum#visible() ? coc#pum#next(1):
    \ <SID>check_back_space() ? "\<Tab>" :
    \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"


" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()
" Open Diagnostics list
nnoremap <localleader>d :CocDiagnostics<CR>

"======================================================================
" Map <tab> for trigger completion, completion confirm, snippet expand and jump like VSCode: >
inoremap <silent><expr> <TAB>
    \ coc#pum#visible() ? coc#_select_confirm() :
    \ coc#expandableOrJumpable() ?
    \ "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
    \ <SID>check_back_space() ? "\<TAB>" :
    \ coc#refresh()


let g:coc_snippet_next = '<tab>'
"======================================================================


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

"======================================================================
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

let g:fzf_preview_window = ['hidden,right,50%,<70(up,40%)', 'ctrl-/']


nnoremap <silent> <leader>f :FZFRepoFiles<CR>
nnoremap <silent> <leader>F :FZFSiblingRepoFiles<CR>
nnoremap <silent> <leader>a :FZFRg<CR>
nnoremap <silent> <leader>A :FZFRgCurrentWord<CR>
nnoremap <silent> <localleader>a :FZFRgCurrentType<CR>
nnoremap <silent> <localleader>A :FZFRgCurrentTypeAndWord<CR>
" Search for word under cursor
nnoremap <silent> ; :Buffers<CR>

" Conflict Resolution
" Pull change from left
nnoremap gdh :diffget //2<CR>
" Pull change from right
nnoremap gdl :diffget //3<CR>


"======================================================================
"" Mini-Yank
map p <Plug>(miniyank-autoput)
map P <Plug>(miniyank-autoPut)
" "startput" will directly put the most recent item in the shared history:
map <leader>p <Plug>(miniyank-startput)
map <leader>P <Plug>(miniyank-startPut)
"Right after a put, use "cycle" to go through history:
map <leader>n <Plug>(miniyank-cycle)
" Stepped too far? You can cycle back to more recent items using:
map <leader>N <Plug>(miniyank-cycleback)
"Maybe the register type was wrong? Well, you can change it after putting:
map <Leader>c <Plug>(miniyank-tochar)
map <Leader>l <Plug>(miniyank-toline)
map <Leader>b <Plug>(miniyank-toblock)

"======================================================================
" Terraform
let g:terraform_fmt_on_save = 1


" function! CocNvimHighlight()
"     highlight CocErrorHighlight ctermfg=Red  guifg=#ff0000
"     highlight CocWarningHighlight ctermfg=Red  guifg=#ff0000
"     highlight CocInfoHighlight ctermfg=Red  guifg=#ff0000
"     highlight CocHintHighlight ctermfg=Red  guifg=#ff0000
"     highlight CocErrorLine ctermfg=Red  guifg=#ff0000
"     highlight CocWarningLine ctermfg=Red  guifg=#ff0000
"     highlight CocInfoLine ctermfg=Red  guifg=#ff0000
"     highlight CocHintLine ctermfg=Red  guifg=#ff0000

"     highlight CocHighlightText  guibg=#111111 ctermbg=223
" endfunction

" autocmd VimEnter function CocNvimHighlight()
