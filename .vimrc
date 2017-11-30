" vim: set sw=4 ts=4 sts=4 et tw=78 foldmethod=marker:
"        _
" __   _(_)_ __ ___  _ __ ___
" \ \ / / | '_ ` _ \| '__/ __|
"  \ V /| | | | | | | | | (__
"   \_/ |_|_| |_| |_|_|  \___|
"
" Mike's VIM Config
"
"======================================================================
" Section: Plugins {{{1
"======================================================================
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-sensible'
Plug 'sjl/vitality.vim'
Plug 'bkad/CamelCaseMotion'
Plug 'vim-scripts/matchit.zip'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

Plug 'justinmk/vim-sneak'

" Auto-close/end on ENTER
Plug 'tpope/vim-endwise'
" Adds support for "{", "(" etc. (compliments vim-endwise)
Plug 'rstacruz/vim-closer'

" Scratch buffer
Plug 'idbrii/itchy.vim'

" Fire events on TMUX window switch, allowing auto-save
Plug 'sjl/gundo.vim'

" Fuzzy finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'

" Grep (Ack plugin used with Silver Searcher)
Plug 'mileszs/ack.vim'

Plug 'vim-scripts/DirDiff.vim'
Plug 'vim-scripts/YankRing.vim'
Plug 'itchyny/lightline.vim'
"Plug 'docunext/closetag.vim'
Plug 'junegunn/rainbow_parentheses.vim'

" File Syntax
Plug 'smerrill/vcl-vim-plugin'  " Varnish syntax
Plug 'Keithbsmiley/tmux.vim'    " TMUX syntax

" Markdown
Plug 'tpope/vim-markdown', { 'for': 'markdown' }
Plug 'itspriddle/vim-marked', { 'for': 'markdown' }
Plug 'nelstrom/vim-markdown-folding', { 'for': 'markdown' }

" Javascript
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'maksimr/vim-jsbeautify', { 'for': 'javascript'}

" Python
Plug 'davidhalter/jedi-vim', { 'for': 'python' }
Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
Plug 'fisadev/vim-isort', { 'for': 'python' }

" Other Languages
Plug 'chase/vim-ansible-yaml', { 'for': 'ansible' }
Plug 'Icinga/icinga2', { 'rtp': 'tools/syntax/vim' }
Plug 'nginx/nginx', { 'rtp': 'contrib/vim' }
Plug 'davidoc/taskpaper.vim'

" Async Linting
Plug 'w0rp/ale'

" HTML, JS, CSS Beautify
Plug 'maksimr/vim-jsbeautify'

" Disable search highlighting when not searching
Plug 'romainl/vim-cool'

" Easily shift function arguments
Plug 'PeterRincker/vim-argumentative'

" Experimental Scala Stuff
"Plug 'derekwyatt/vim-scala'
"Plug 'jceb/vim-hier'

"---------- Experimental ----------
Plug 'tpope/vim-abolish'
Plug 'idbrii/vim-diffusable'
Plug 'dietsche/vim-lastplace'
" Intelligently re-open files at last edit position
Plug 'nathanaelkane/vim-indent-guides'
" Distraction-free writing
Plug 'junegunn/goyo.vim'

" Deoplete Auto-Compelete
" if has('nvim')
"   Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" else
"   Plug 'Shougo/deoplete.nvim'
"   Plug 'roxma/nvim-yarp'
"   Plug 'roxma/vim-hug-neovim-rpc'
" endif

call plug#end()

"======================================================================
" Section: Key Mappings {{{1
"======================================================================

" Leaders
let mapleader = "\<Space>"
let maplocalleader = "\\"

" Close QuickFix window
nmap \x :cclose<CR>

" Edit last (most recent) file
nmap <C-e> :e#<CR>

" TODO: shortcut to toggle folds
" nnoremap <space> za
" vnoremap <space> zf


" Case insensitive Write + Quit
command! Q q
command! W w

" Force-save file (useful if forget to run vim w/ sudo)
" http://stackoverflow.com/questions/1005/getting-root-permissions-on-a-file-inside-of-vi
cmap w!! w !sudo tee >/dev/null %
" Force write current file
nmap <leader>w :w!<CR>
nmap <leader>x :x<CR>
nmap <leader>q :xa<CR>
nmap <leader>o :only<CR>
au FocusLost * silent! :wa    " Auto-save everything on lost focus (via Vitality plugin event on console VIM)

" Easy visual-mode shifting (indent/unindent)
vnoremap < <gv
vnoremap > >gv

" Disable entering the dreaded 'ex' mode (useless!)
nnoremap Q <nop>

" Make j/k move by 'screen line' instead of 'file line'
nnoremap j gj
nnoremap k gk

" Open previous buffer
nmap <C-e> :e#<CR>

" Fast reload current file
nnoremap <leader>ef :e!<CR>

" Swap BACKTICK and APOSTROPHE:
"      -- 'APOSTROPHE A' will jump to line marked by 'ma'
"      -- 'BACKTICK A' will jump to line AND COLUMN marked by 'ma'
nnoremap ' `
nnoremap ` '

" Quick insertion of newline in normal mode with <CR>
if has("autocmd")
nnoremap <silent> <CR> :put=''<CR>
augroup newline
    autocmd!
    autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
    autocmd CmdwinEnter * nnoremap <buffer> <CR> <CR>
augroup END
endif

"======================================================================
" Section: Syntax + Coloring {{{1
"======================================================================
set background=dark
colorscheme solarized
" mparent(2017-10-26): Trying this out
"let g:solarized_underline = 1
" Make sure VIM recognizes 256-color support. Especially important for iTerm2
if !has('gui_running')
    if $TERM == "xterm-256color" || $TERM == "screen-256color" || $COLORTERM == "gnome-terminal"
        set t_Co=256
    endif
    " Disable Background Color Erase when within tmux - https://stackoverflow.com/q/6427650/102704
    if $TMUX != ""
        set t_ut=
    endif
endif

syntax on
" Do syntax highlight syncing from start (more CPU, but worth it)
autocmd BufEnter * :syntax sync fromstart
" Don't try to highlight lines longer than N characters
set synmaxcol=800

" Toggles the background color, and reloads the colorscheme.
command! ToggleBackground call <SID>ToggleBackground()
function! <SID>ToggleBackground()
    let &background = ( &background == "dark"? "light" : "dark" )
    " mparent(2014-01-30): Not sure if this is necessary...
    if exists("g:colors_name")
        exe "colorscheme " . g:colors_name
    endif
endfunction
nmap <leader>BG :ToggleBackground<CR>

" Distraction-free Writing Mode
function! ProseMode()
  "set formatoptions=1an
  call goyo#execute(0, [])
  set spell noci nosi noai nolist noshowmode noshowcmd
  set complete+=s
  set bg=light
  if !has('gui_running')
    let g:solarized_underline = 1
    let g:solarized_termcolors=256
  endif
  colors solarized
endfunction
command! ProseMode call ProseMode()

"======================================================================
" Section: VIM options {{{1
"======================================================================

set autoindent                  " Carry over indenting from previous line
set autoread                    " Don't bother me when a file changes
set autowriteall                " Save as often as possible
set backspace=indent,eol,start  " Allow backspace beyond insertion point
set cindent                     " Automatic program indenting
set cinkeys-=0#                 " Comments don't fiddle with indenting
set cino=                   " See :h cinoptions-values
set commentstring=\ \ #%s   " When folds are created, add them to this
set copyindent              " Make autoindent use the same chars as prev line
set directory-=.            " Don't store temp files in cwd
set encoding=utf8           " UTF-8 by default
set expandtab               " No tabs by default
set foldenable              " I like folding
set fileformats=unix,dos,mac  " Prefer Unix
set fillchars=vert:\ ,stl:\ ,stlnc:\ ,fold:-,diff:┄ " Unicode chars for diffs/folds, and rely on Colors for window borders
silent! set foldmethod=marker " Use braces by default
set formatoptions+=t    " Don't auto-wrap text using textwidth
set formatoptions+=c    " Auto-wrap comments using textwidth
set formatoptions+=q    " Allow formatting of comments with "gq".
set formatoptions+=1    " Don't break a line after a one-letter word.
set formatoptions+=n    " When formatting text, recognize numbered lists
set gdefault                " :sub "all" flag on by default (don't need add 'g' on end of searches)
set hidden                  " Don't prompt to save hidden windows until exit
set history=1000             " How many lines of history to save
set hlsearch                " Hilight searching
set ignorecase              " Case insensitive
set incsearch               " Search as you type
set infercase               " Completion recognizes capitalization
set laststatus=2            " Always show the status bar
set linebreak               " Break long lines by word, not char
set matchpairs+=<:>         " Make < and > match
set modelines=3             " How many lines of head & tail to look for ml's

" No need VIM backups due to Version Control
set nobackup                " No backups left after done editing
set nojoinspaces        " Insert only one space after '.', '?', '!' when joining lines
set nolist              " Don't show special characters for whitespace (tab, eol, etc)
set nonumber                " No line numbers to start
set noswapfile
set notitle                 " Don't set the title of the Vim window
set nowrap              " Don't wrap lines
set nowritebackup           " No backups made while editing
set nrformats=                " Make <C-a> and <C-x> play well with zero-padded numbers (i.e. don't consider them octal or hex)
set printoptions=paper:letter " US paper
set ruler                   " Show row/col and percentage
set scroll=4                " Number of lines to scroll with ^U/^D
set scrolloff=15            " Keep cursor away from this many chars top/bot
set shiftround          " use multiple of shiftwidth when indenting with '<' and '>'
set shiftwidth=4            " Number of spaces to shift for autoindent or >,<
set shortmess+=aIfilmnrxoOstT  " Abbrev. of messages (avoids 'hit enter')
set showbreak=↪         " Wrapped line marker
set showmatch
set sidescrolloff=3         " Keep cursor away from this many chars left/right
set smartcase   " case-sensitive search if 1+ letters are uppercase
set softtabstop=4
set tabstop=4               " The One True Tab
set textwidth=120       " Standard '80 is too small. Screens are bigger these days.
set visualbell t_vb=        " No flashing or beeping at all
set wildmenu
set wildmode=list:longest,full " List all options and complete
set wildignorecase
set wildignore+=.hg,.git,.svn               " Version control
set wildignore+=*.o,*.a,*.swp,*.so,*.so.*   " C/C++
set wildignore+=*.pyc                       " Python byte code
set wildignore+=*.png,*.jpg,*.ico           " Images
set wildignore+=*.orig                      " Merge resolution files
set wildignore+=*.DS_Store                  " OSX finder/spotlight crap
set wildignore+=*.lock,*.cache
set wildignore+=node_modules
set wrapscan                    " Wrap around when searching

"======================================================================
" Section: Copy/Paste {{{1
"======================================================================
" Make Y consistent with C and D by yanking up to end of line
noremap Y y$
" Toggle paste mode (preferred over 'pastetoggle' to echo current state
noremap <leader>p :set paste! paste?<CR>
" OSX Copy/Paste w/ system clipboard. Should work in console VIM on OSX...
" Note: requires tmux + reattach-to-user-namespace support.
set clipboard=unnamed   " yank go straight to system clipboard
set go+=a               " auto-copy visual selection to system clipboard

"======================================================================
" Section: Diff {{{1
"======================================================================
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

nnoremap <silent> <Leader>dt :call DiffToggle()<CR>
nnoremap <silent> <Leader>dw :call DiffWhitespaceToggle()<CR>
nnoremap <silent> <leader>du :diffupdate<CR>

" Prefer vertical diff splits
set diffopt+=vertical

"======================================================================
" Section: Marks {{{1
"======================================================================
" Quick jump to previous file type
autocmd BufLeave *.css,*.less,*sass             normal! mC
autocmd BufLeave *.html                         normal! mH
autocmd BufLeave *.js                           normal! mJ
autocmd BufLeave *.py                           normal! mP
autocmd BufLeave tests.py,test_*.py,*.tests.js  normal! mT
autocmd BufLeave *.scala                        normal! mS
autocmd BufLeave *.yml                          normal! mY
autocmd BufLeave Dockerfile                     normal! mD

"======================================================================
" Section: Spelling {{{1
"======================================================================

" Enable spellcheck in commit messages
autocmd FileType gitcommit setlocal spell

" Autocorrections
" My Nemesis!
iab recieve receive
iab Recieve Receive
iab RECIEVE RECEIVE
iab recieved received
iab Recieved Received
iab RECIEVED RECEIVED

"======================================================================
" Section: Undo {{{1
"======================================================================
" Undo is great!
if has('persistent_undo')
    set undofile
    set undolevels=1000    " Max changes that can be undone
    set undoreload=10000   " Max number of lines to save for undo on buffer reload
    set undodir=~/.vim/tmp/undo
    if ! isdirectory(expand(&undodir))
        call mkdir(expand(&undodir), "p")
    endif
endif


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
autocmd BufWritePre *.py,*.mako,*.js,*.css,*.less,*.cpp,*.h,*.todo,*.txt,*.ini,*.taskpaper,*.vim,.vimrc call DeleteTrailingWhitespace()
nnoremap <leader>W :call DeleteTrailingWhitespace()<CR>

" Fix mixed EOLs (^M)
"noremap <silent> <leader>$ :let b:s=@/ | %s/<C-V><CR>//e | let @/=b:s<CR>``

" Highlight non-whitespace trailing characters (except when typing at end of line)
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
" Ensure highlight group set on color scheme change, background change, etc.
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()     " Workaround for 'match' command memory leak

"======================================================================
" Section: Windows {{{1
"======================================================================
" Easy split movement
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" Auto-resize splits on window resize
autocmd VimResized * wincmd =
" Fast vertical split
nnoremap <leader>v :vsplit<space>

"======================================================================
" Section: Plugin Settings {{{1
"======================================================================

"---------- Ack ----------
nnoremap <leader>a :Ack<space>
" Use Silver Searcher if available
if executable('ag')
    let g:ackprg = 'ag --nogroup --hidden --nocolor --column'
    set grepprg=ag\ --nogroup\ --nocolor\ --column
    set grepformat=%f:%l:%c%m
endif
" " Grep word undercusor
" mparent(2017-11-09): This was buggy!
" nmap <M-k>    :Ack! "\b<cword>\b" <CR>
" nmap <Esc>k   :Ack! "\b<cword>\b" <CR>
" nmap <M-S-k>  :Ggrep! "\b<cword>\b" <CR>
" nmap <Esc>K   :Ggrep! "\b<cword>\b" <CR>

"---------- ALE ----------
let g:ale_sign_warning = '▲'
let g:ale_sign_error = '✗'
highlight link ALEWarningSign String
highlight link ALEErrorSign Title

"---------- CamelCaseMotion ----------
map W <Plug>CamelCaseMotion_w
map B <Plug>CamelCaseMotion_b
map E <Plug>CamelCaseMotion_e
sunmap W
sunmap B
sunmap E


"---------- Deoplete (Async auto-completion) ----------
let g:deoplete#enable_at_startup = 1  " On by default

"---------- DirDiff ----------
let g:DirDiffExcludes = ".hg,.git"
" My modified Solarized 'DiffChange' color clashes with DirDiff, so use something else:
hi def link DirDiffSelected     Underlined

"---------- Dispatch ----------
nnoremap <leader>R :Focus<space>
"  Auto-save then run
nnoremap <leader>r :wa<CR>:Dispatch<CR>

"---------- Easy Motion ----------
" Faster than default 2-key press of <leader><leader>
let g:EasyMotion_leader_key = '<localleader>'
"---------- Expand Region ----------
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

"---------- Fugitive ----------
" Delete Fugitive buffers when I leave them so they don't pollute BufExplorer
" REF: https://github.com/tpope/vim-fugitive/issues/81#issuecomment-1245830
autocmd BufReadPost fugitive://* set bufhidden=delete

nnoremap <leader>ga :Git add %:p<CR><CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gv :Gcommit --no-verify -q<CR>
nnoremap <leader>gt :Gcommit --no-verify -q %:p<CR>
nnoremap <leader>gd :Gdiff<CR>
"nnoremap <leader>gd :Gvdiff<CR>
nnoremap <leader>ge :Gedit<CR>
nnoremap <leader>gR :Gremove<CR>
nnoremap <leader>gr :Gread<CR>:w!<CR>
nnoremap <leader>gw :Gwrite<CR><CR>
nnoremap <leader>gl :silent! Glog<CR>:bot copen<CR>
nnoremap <leader>gp :Ggrep<Space>
nnoremap <leader>gm :Gmove<Space>
nnoremap <leader>gb :Git branch<Space>
nnoremap <leader>go :Git checkout<Space>
nnoremap <leader>gps :Dispatch! git push<CR>
nnoremap <leader>gpl :Dispatch! git pull<CR>

"---------- FZF ----------
" Automatically find top-level directory (https://github.com/junegunn/fzf/issues/369)
function! s:FZF_Root_Files()
    for vcs in ['.git', '.svn', '.hg']
        let dir = finddir(vcs.'/..', ';')
        if !empty(dir)
            " Exclude home directory (dotfiles repo)
            if dir != expand('~')
                execute 'Files' dir
                return
            endif
        endif
    endfor
    Files
endfunction
command! RootFiles call s:FZF_Root_Files()

nmap ; :Buffers<CR>
nmap <leader>l :Lines<CR>
nmap <leader>t :Tags<CR>
nmap <leader>f :RootFiles<CR>
" Fast virtualenv file lookup (chooses correct Python version via wildcard, can only be 1 though)
nnoremap <leader>V :Files $VIRTUAL_ENV/lib/*/site-packages<CR>

" Find word under cursor
nnoremap <leader>K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

"---------- Gundo ----------
noremap <leader>U :GundoToggle<CR>
let g:gundo_prefer_python3 = 1  " Python 3 support

"---------- Indent Guides ----------
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=11
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=5

"---------- Lightline ----------
let g:lightline = {
\ 'colorscheme': 'wombat',
\ 'active': {
\   'left': [['mode', 'paste'], ['filename', 'modified']],
\   'right': [['lineinfo'], ['percent'], ['readonly', 'linter_warnings', 'linter_errors', 'linter_ok']]
\ },
\ 'component_expand': {
\   'linter_warnings': 'LightlineLinterWarnings',
\   'linter_errors': 'LightlineLinterErrors',
\   'linter_ok': 'LightlineLinterOK'
\ },
\ 'component_type': {
\   'readonly': 'error',
\   'linter_warnings': 'warning',
\   'linter_errors': 'error'
\ },
\ }

function! LightlineLinterWarnings() abort
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors
    return l:counts.total == 0 ? '' : printf('%d ◆', all_non_errors)
endfunction

function! LightlineLinterErrors() abort
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors
    return l:counts.total == 0 ? '' : printf('%d ✗', all_errors)
endfunction

function! LightlineLinterOK() abort
    let l:counts = ale#statusline#Count(bufnr(''))
    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors
    return l:counts.total == 0 ? '✓ ' : ''
endfunction

autocmd User ALELint call s:MaybeUpdateLightline()

" Update and show lightline but only if it's visible (e.g., not in Goyo)
function! s:MaybeUpdateLightline()
    if exists('#lightline')
        call lightline#update()
    end
endfunction

"---------- NetRW ----------
" Allow removal of non-empty local directories
let g:netrw_localrmdir="rm -r"

"---------- Rainbow Parens ----------
augroup rainbow_dev
  autocmd!
  autocmd FileType scala,python RainbowParentheses
augroup END

"---------- Sneak ----------
" Label mode
let g:sneak#label = 1
" Hit "s" again to goto next match
let g:sneak#s_next = 1

"---------- Taskpaper ----------
" Custom Solarized colors:
"   Completed tasks -> Violet
hi link taskpaperDone Underlined
"   Canceled tasks -> Yellow
hi link taskpaperCancelled Type

"---------- UltiSnips ----------
" Edit window is horizontal split (default is vertical)
let g:UltiSnipsEditSplit = 'horizontal'
let g:UltiSnipsExpandTrigger = "<tab>"
" Tab is easier than default c-j/c-k movement
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
" Fast snippet editing
noremap <leader>ue :UltiSnipsEdit<CR>

"---------- Yankring ----------
set viminfo+=n~/.vim/tmp/viminfo
let g:yankring_history_dir = '$HOME/.vim/tmp'
nnoremap <silent> <leader>Y :YRShow<CR>     " Yankring history menu

"======================================================================
" Section: Local Config {{{1
"======================================================================
" Now load host-specific config
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif

"======================================================================
" Section: Legacy Settings (pre-Nov 2017) {{{1
"======================================================================

" if exists('+relativenumber')
"   " Hybrid mode - shows relative numbering with current line's absolute number
"   set relativenumber
"   set number
"endif

" " Backspace key works in normal mode too
" " http://tech.groups.yahoo.com/group/vim/message/17237
" " NOTE: May need to use 'nnoremap' instead if this doesn't work as expected in Visual and Operator-pending modes
" " NOTE: This might be useless, and I can find some other use for 'backspace'
" noremap <BS> d<BS>

""nnoremap <leader>rv :source $MYVIMRC<CR>:redraw<CR>:echo $MYVIMRC 'reloaded'<CR>
"" Auto-reload VIMRC on change
"augroup reload_vimrc
"    autocmd!
"    " 2013-06-13: Need to use 'nested' autocmd to avoid breaking vim-powerline
"    autocmd BufWritePost $MYVIMRC nested source $MYVIMRC
"augroup END

" Quickfix window always on bottom taking up entire horizontal space
au FileType qf wincmd J
" Auto resize QF window to fit contents
au FileType qf call AdjustWindowHeight(3, 20)
function! AdjustWindowHeight(minheight, maxheight)
    exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction
