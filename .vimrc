" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={{,}} foldlevel=1 foldmethod=marker:
"
" Mike's VIM Config

" Avoid VIM's attempts to be compatible with VI. Must be first line.
set nocompatible

"======================================================================
" PLUGINS
"----------------------------------------------------------------------
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
Plug 'scrooloose/nerdcommenter'
Plug 'sjl/gundo.vim'
Plug 'sjl/vitality.vim'
Plug 'bkad/CamelCaseMotion'
Plug 'vim-scripts/matchit.zip'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
" Fuzzy finder
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" Git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'

Plug 'vim-scripts/DirDiff.vim'
Plug 'vim-scripts/YankRing.vim'
Plug 'itchyny/lightline.vim'
Plug 'docunext/closetag.vim'
Plug 'davidoc/taskpaper.vim'
Plug 'gabesoft/vim-ags'

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

" Language-specific
Plug 'davidhalter/jedi-vim', { 'for': 'python' }
Plug 'klen/python-mode', { 'for': 'python', 'branch': 'develop' }
Plug 'chase/vim-ansible-yaml', { 'for': 'ansible' }
Plug 'Icinga/icinga2', { 'rtp': 'tools/syntax/vim' }
Plug 'nginx/nginx', { 'rtp': 'contrib/vim' }

" Experimental
"Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
Plug 'idbrii/itchy.vim'
Plug 'idbrii/vim-diffusable'
"Plug 'mbbill/undotree'
"Plug '5long/pytest-vim-compiler'
"Plug 'altercation/vim-colors-solarized'
"Plug 'chrisbra/vim-diff-enhanced'
"Plug 'christoomey/vim-tmux-navigator'
"Plug 'tpope/vim-endwise'
"Plug 'unblevable/quick-scope'
"Plug 'scrooloose/syntastic'
"Plug 'tweekmonster/django-plus.vim'
Plug 'PeterRincker/vim-argumentative'
Plug 'dietsche/vim-lastplace'
Plug 'fisadev/vim-isort', { 'for': 'python' }
"Plug 'justinmk/vim-dirvish'
Plug 'justinmk/vim-sneak'
Plug 'kien/rainbow_parentheses.vim'
Plug 'nathanaelkane/vim-indent-guides'
"Plug 'terryma/vim-expand-region'
Plug 'tpope/vim-sensible'
"Plug 'dyng/ctrlsf.vim'
" mparent(2016-09-08): Tried to use this but requires 'python' (homebrew just has 'python3')
"Plug 'maralla/validator.vim'

call plug#end()
"======================================================================


" Syntax {{
    syntax on
    " Do syntax highlight syncing from start (more CPU, but worth it)
    autocmd BufEnter * :syntax sync fromstart
    " Don't try to highlight lines longer than N characters
    set synmaxcol=800
" }}

" Color {{
    " Make sure VIM recognizes 256-color support. Especially important for iTerm2
    if $TERM == "xterm-256color" || $TERM == "screen-256color" || $COLORTERM == "gnome-terminal"
        set t_Co=256
    endif

    set background=dark
    colorscheme solarized
    "colorscheme flattened_dark
" }}

" General {{
    " Leaders
    let mapleader = "\<Space>"
    let maplocalleader = "\\"

    set encoding=utf-8
    set nomodeline          " Avoids security issues
    set ffs=unix,dos,mac    " Use Unix as standard filetype
    set scrolloff=3         " Keep some context above/below near screen edges
    set autoindent
    set showcmd
    set hidden              " Allow buffer switching without saving
    set visualbell          " Visual bell (instead of audible beep)
    set ttyfast             " better screen updates for faster terminals
    set ruler               " Statusbar ruler w/ line/column info
    set laststatus=2        " Always have status line
    set history=1000        " Lots of command history
    set title               " Set terminal title to VIM filename
    set shortmess+=aIfilmnrxoOstT  " Abbrev. of messages (avoids 'hit enter')
    if exists('+relativenumber')
        " Hybrid mode - shows relative numbering with current line's absolute number
        set relativenumber
        set number
    endif

    if exists("+shellslash")
        set shellslash    " expand filenames with forward slash (for Windows)
    endif

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

    " Time out on key codes but not mappings.Basically this makes terminal Vim work sanely.
    set notimeout
    set ttimeout
    set ttimeoutlen=10

    " No need VIM backups due to Version Control
    set nobackup
    set nowritebackup
    set noswapfile

    " Undo is great!
    if has('persistent_undo')
        set undofile
        set undolevels=1000    " Max changes that can be undone
        set undoreload=10000   " Max number of lines to save for undo on buffer reload
        if has("win32")
            set undodir=C:\WINDOWS\Temp\vim_undo
        else
            set undodir=~/.vim/tmp/undo
        endif
        if ! isdirectory(expand(&undodir))
            call mkdir(expand(&undodir), "p")
        endif
    endif

    " Better Completion
    set complete=.,w,b,u,t
    set completeopt=longest,menuone,preview

    " Easy visual-mode shifting (indent/unindent)
    vnoremap < <gv
    vnoremap > >gv

    " Disable entering the dreaded 'ex' mode (useless!)
    nnoremap Q <nop>

    " Make j/k move by 'screen line' instead of 'file line'
    nnoremap j gj
    nnoremap k gk

    " Swap BACKTICK and APOSTROPHE:
    "      -- 'APOSTROPHE A' will jump to line marked by 'ma'
    "      -- 'BACKTICK A' will jump to line AND COLUMN marked by 'ma'
    nnoremap ' `
    nnoremap ` '

    " Backspace key works in normal mode too
    " http://tech.groups.yahoo.com/group/vim/message/17237
    " NOTE: May need to use 'nnoremap' instead if this doesn't work as expected in Visual and Operator-pending modes
    " NOTE: This might be useless, and I can find some other use for 'backspace'
    noremap <BS> d<BS>

    " Pull word under cursor into LHS of a substitute (for quick search and
    " replace)
    nnoremap <leader>z :%s#\<<C-r>=expand("<cword>")<CR>\>#

    " Easy split movement
    nnoremap <C-h> <C-w>h
    nnoremap <C-j> <C-w>j
    nnoremap <C-k> <C-w>k
    nnoremap <C-l> <C-w>l

    " Auto-resize splits on window resize
    autocmd VimResized * wincmd =

    " Fast vertical split
    nnoremap <leader>v :vsplit<space>

    " Quickly edit/reload files
    nnoremap <leader>ef :e!<CR>                               " Fast reload current file
    nnoremap <leader>ev :n $MYVIMRC<CR>                       " Edit vimrc
    nnoremap <leader>ep :n $HOME/.vim/ftplugin/python.vim<CR> " Edit python settings
    nnoremap <leader>ez :n $HOME/.zshrc<CR>                   " Edit zshrc

    "nnoremap <leader>rv :source $MYVIMRC<CR>:redraw<CR>:echo $MYVIMRC 'reloaded'<CR>
    " Auto-reload VIMRC on change
    augroup reload_vimrc
        autocmd!
        " 2013-06-13: Need to use 'nested' autocmd to avoid breaking vim-powerline
        autocmd BufWritePost $MYVIMRC nested source $MYVIMRC
    augroup END

    " Open previous buffer
    nmap <C-e> :e#<CR>

    " Make <C-a> and <C-x> play well with zero-padded numbers (i.e. don't consider them octal or hex)
    set nrformats=

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
" }}

" Save/Quit {{

    " Force-save file (useful if I forget to run vim w/ sudo)
    cmap w!! w !sudo tee % >/dev/null

    " Force write current file
    nmap <leader>w :w!<CR>
    nmap <leader>x :x<CR>
    nmap <leader>q :xa<CR>
    nmap <leader>o :only<CR>

    " Save as often as possible
    au FocusLost * silent! :wa    " Auto-save everything on lost focus (GUI-mode only)
    set autowriteall
    set autoread
" }}


" Quickfix {{
    " Quickfix window always on bottom taking up entire horizontal space
    au FileType qf wincmd J

    " Auto resize QF window to fit contents
    au FileType qf call AdjustWindowHeight(3, 20)
    function! AdjustWindowHeight(minheight, maxheight)
        exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
    endfunction
" }}

" Tab/Space/Wrap {{
    set tabstop=4
    set shiftwidth=4
    set softtabstop=4
    set expandtab
    set shiftround          " use multiple of shiftwidth when indenting with '<' and '>'

    set textwidth=120       " Standard '80 is too small. Screens are bigger these days.

    set nojoinspaces        " Insert only one space after '.', '?', '!' when joining lines
    set nolist              " Don't show special characters for whitespace (tab, eol, etc)
    set showmode            " Always show the current editing mode

    set backspace=indent,eol,start  " Allow backspacing over everything (insert)

    set nowrap              " Don't wrap lines
    set formatoptions+=1    " Don't break a line after a one-letter word.
    set formatoptions+=c    " Auto-wrap comments using textwidth
    set formatoptions+=n    " When formatting text, recognize numbered lists
    set formatoptions+=q    " Allow formatting of comments with "gq".
    set formatoptions-=r    " Don't auto-insert current comment leader with newline
    set formatoptions-=t    " Don't auto-wrap text using textwidth
    set showbreak=↪         " Wrapped line marker

    " Folding
    set foldenable          " Auto fold code
    "set foldnestmax=1       " Max 1-level deep (I just want high-level overview)
    "set foldlevelstart=999  " All fold levels open at start

    " Quick insertion of newline in normal mode with <CR>
    if has("autocmd")
    nnoremap <silent> <CR> :put=''<CR>
    augroup newline
        autocmd!
        autocmd BufReadPost quickfix nnoremap <buffer> <CR> <CR>
        autocmd CmdwinEnter * nnoremap <buffer> <CR> <CR>
    augroup END
    endif

    " Change cursor to vertical bar in insert mode when using iTerm2
    if $TERM_PROGRAM == 'iTerm.app'
        if exists('$TMUX')
            let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
            let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
        else
            let &t_SI = "\<Esc>]50;CursorShape=1\x7"
            let &t_EI = "\<Esc>]50;CursorShape=0\x7"
        endif
    endif
" }}

" Whitespace {{
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
" }}

" Spelling {{
    " Enable spellcheck in commit messages
    autocmd FileType gitcommit setlocal spell
    autocmd FileType hgcommit  setlocal spell
    autocmd FileType svn       setlocal spell
" }}

" Copy/Paste {{
    " Make Y consistent with C and D by yanking up to end of line
    noremap Y y$

    " Toggle paste mode (preferred over 'pastetoggle' to echo current state
    noremap <leader>p :set paste! paste?<CR>

    " OSX Copy/Paste w/ system clipboard. Should work in console VIM on OSX...
    " Note: requires tmux + reattach-to-user-namespace support.
    set clipboard=unnamed   " yank go straight to system clipboard
    set go+=a               " auto-copy visual selection to system clipboard
" }}

" Wild Menu  {{
    set wildmenu
    set wildmode=list:longest  "Only complete up to point of ambiguity
    if exists ("&wildignorecase")
        set wildignorecase
    endif
    set wildignore+=.hg,.git,.svn               " Version control
    set wildignore+=*.o,*.a,*.swp,*.so,*.so.*   " C/C++
    set wildignore+=*.pyc                       " Python byte code
    set wildignore+=*.png,*.jpg,*.ico           " Images
    set wildignore+=*.orig                      " Merge resolution files
    set wildignore+=*.DS_Store                  " OSX finder/spotlight crap
    set wildignore+=*.lock,*.cache
    set wildignore+=node_modules
" }}

" Search {{
    set wrapscan    " Wrap around when searching
    set ignorecase
    set smartcase   " case-sensitive search if 1+ letters are uppercase
    set gdefault    " :sub "all" flag on by default (don't need add 'g' on end of searches)
    set incsearch
    set hlsearch
    " Fast disable search highlight
    nmap <silent> <leader>/ :nohlsearch<CR>

    set showmatch
    set matchpairs+=<:>         " Make < and > match
" }}

" Unicode {{
    " Prefer unicode (UTF-8)
    " Reference: htte://vim.wikia.com/wiki/Working_with_Unicode
    if has("multi_byte")
        " Save locale keyboard encoding before changing 'encoding' value.
        if &termencoding == ""
            let &termencoding = &encoding
        endif
        " Use UTF-8
        set encoding=utf-8
        setglobal fileencoding=utf-8
        set fileencodings=ucs-bom,utf-8,latin1
    endif
" }}


" Diff {{

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
" }}


" Marks {{
    " Quick jump to previous file type
    autocmd BufLeave *.css,*.less,*scss             normal! mC
    autocmd BufLeave *.html                         normal! mH
    autocmd BufLeave *.js                           normal! mJ
    autocmd BufLeave *.py                           normal! mP
    autocmd BufLeave tests.py,test_*.py,*.tests.js  normal! mT
    autocmd BufLeave *.sass                         normal! mS
    autocmd BufLeave *.yml                          normal! mY
    autocmd BufLeave Dockerfile                     normal! mD
" }}

" Plugins {{

    " ----- DirDiff -----
    let g:DirDiffExcludes = ".hg,.git"
    " My modified Solarized 'DiffChange' color clashes with DirDiff, so use something else:
    hi def link DirDiffSelected     Underlined

    " ----- Yankring -----
    set viminfo+=n~/.vim/tmp/viminfo
    let g:yankring_history_dir = '$HOME/.vim/tmp'
    nnoremap <silent> <leader>Y :YRShow<CR>     " Yankring history menu

    "--------------------------------
    " CamelCaseMotion
    map W <Plug>CamelCaseMotion_w
    map B <Plug>CamelCaseMotion_b
    map E <Plug>CamelCaseMotion_e
    sunmap W
    sunmap B
    sunmap E

    "----- FZF -----
    nmap <leader>f :Files<CR>
    nmap ; :Buffers<CR>
    nmap <leader>l :Lines<CR>
    " Fast virtualenv file lookup (chooses correct Python version via wildcard, can only be 1 though)
    nnoremap <leader>V :Files $VIRTUAL_ENV/lib/*/site-packages<CR>

    " Silver Searcher (via vim-ags)
    nnoremap <leader>a :Ags<space>

    " Find word under cursor
    nnoremap <leader>K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

    " ----- Dispatch -----
    nnoremap <leader>R :Focus<space>
    "  Auto-save then run
    nnoremap <leader>r :wa<CR>:Dispatch<CR>

    " ----- Easy Motion -----
    " Faster than default 2-key press of <leader><leader>
    let g:EasyMotion_leader_key = '<localleader>'

    " ----- Expand Region -----
    vmap v <Plug>(expand_region_expand)
    vmap <C-v> <Plug>(expand_region_shrink)

    " ----- Goyo / Limelight -----
    autocmd! User GoyoEnter Limelight
    autocmd! User GoyoLeave Limelight!
    let g:limelight_conceal_ctermfg = 240

    " ----- Gundo -----
    noremap <leader>U :GundoToggle<CR>
    let g:gundo_prefer_python3 = 1  " Python 3 support

    " ----- Fugitive -----

    " Delete Fugitive buffers when I leave them so they don't pollute BufExplorer
    " REF: https://github.com/tpope/vim-fugitive/issues/81#issuecomment-1245830
    autocmd BufReadPost fugitive://* set bufhidden=delete

    nnoremap <leader>ga :Git add %:p<CR><CR>
    nnoremap <leader>gs :Gstatus<CR>
    nnoremap <leader>gb :Gblame<CR>
    nnoremap <leader>gc :Gcommit --no-verify<CR>
    nnoremap <leader>gv :Gcommit --no-verify -q<CR>
    nnoremap <leader>gt :Gcommit --no-verify -q %:p<CR>
    nnoremap <leader>gd :Gdiff<CR>
    "nnoremap <leader>gd :Gvdiff<CR>
    nnoremap <leader>ge :Gedit<CR>
    nnoremap <leader>gR :Gremove<CR>
    nnoremap <leader>gr :Gread<CR>
    nnoremap <leader>gw :Gwrite<CR><CR>
    nnoremap <leader>gl :silent! Glog<CR>:bot copen<CR>
    nnoremap <leader>gp :Ggrep<Space>
    nnoremap <leader>gm :Gmove<Space>
    nnoremap <leader>gb :Git branch<Space>
    nnoremap <leader>go :Git checkout<Space>
    nnoremap <leader>gps :Dispatch! git push<CR>
    nnoremap <leader>gpl :Dispatch! git pull<CR>

    " ----- Jedi -----
    let g:jedi#rename_command = "<localleader>r"  " Remap away for Dispatch

    " ----- Indent Guides -----
    let g:indent_guides_auto_colors = 0
    autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=11
    autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=5

    " ----- Rainbow Parens -----
    " Always Just Python For now (Messes up AGS search results for one)
    au VimEnter *.py RainbowParenthesesToggle
    au Syntax *.py RainbowParenthesesLoadRound
    au Syntax *.py RainbowParenthesesLoadSquare
    au Syntax *.py RainbowParenthesesLoadBraces
    " Parentheses colors using Solarized
    let g:rbpt_colorpairs = [
                \ [ '4',  '#268bd2'],
                \ [ '13', '#6c71c4'],
                \ [ '5',  '#d33682'],
                \ [ '1',  '#dc322f'],
                \ [ '9',  '#cb4b16'],
                \ [ '3',  '#b58900'],
                \ [ '2',  '#859900'],
                \ [ '6',  '#2aa198'],
                \ ]

    " ----- Syntastic -----
    " Show errors in location list buffer
    let g:syntastic_auto_loc_list=1
    " NOTE: 'passive' mode was simplest way I could find to disable Python auto-checking
    let g:syntastic_mode_map = { 'mode': 'active',
                               \ 'active_filetypes': ['javascript'],
                               \ 'passive_filetypes': ['css', 'python'] }
    " TODO: Move to plugin file(s)
    " https://github.com/scrooloose/syntastic/wiki/HTML:---tidy
    let g:syntastic_html_tidy_ignore_errors = [ '<input> proprietary attribute "ng-model"' ]

    "" ----- Tabular -----
    nmap <leader>T= :Tabularize /^[^=]*\zs<CR>
    vmap <leader>T= :Tabularize /^[^=]*\zs<CR>
    "nmap <Leader>T= :Tabularize /=<CR>
    "vmap <Leader>a= :Tabularize /=<CR>
    "nmap <Leader>a: :Tabularize /:\zs<CR>
    "vmap <Leader>a: :Tabularize /:\zs<CR>

    " ----- Taskpaper -----
    " Solarized colors:
    "   Completed tasks -> Violet
    hi link taskpaperDone Underlined
    "   Canceled tasks -> Yellow
    hi link taskpaperCancelled Type

    " ----- UltiSnips -----
    " Edit window is horizontal split (default is vertical)
    let g:UltiSnipsEditSplit = 'horizontal'
    let g:UltiSnipsExpandTrigger = "<tab>"
    " Tab is easier than default c-j/c-k movement
    let g:UltiSnipsJumpForwardTrigger = "<tab>"
    let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
    " Fast snippet editing
    noremap <leader>ue :UltiSnipsEdit<CR>
" }}

" Spelling {{
    " Autocorrections
    " My Nemesis!
    iab recieve receive
    iab Recieve Receive
    iab RECIEVE RECEIVE
    iab recieved received
    iab Recieved Received
    iab RECIEVED RECEIVED
" }}

" Load optional local VIMRC
if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif
