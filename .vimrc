" Init {{
" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={{,}} foldlevel=1 foldmethod=marker:
"
"   Mike's VIM Config

    " Avoid VIM's attempts to be compatible with VI.
    " This must be the first line, because it affects other options.
    set nocompatible

    filetype off                " Force reloading *after* pathogen loaded

    " Use pathogen to load bundles
    execute pathogen#infect()
    " Load all bundle help docs
    execute pathogen#helptags()

    filetype plugin indent on   " Enable detection, plugins and indenting in one step
" }}

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
    " Enable me (before 'colorscheme command') for terminals without custom Solarized palette
    "let g:solarized_termcolors=256
    "let g:solarized_diffmode="high"
    colorscheme solarized
" }}

" General {{
    " Leaders
    let mapleader = ","
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

    " I always hit F1/Help key when I'm aiming for ESC
    inoremap <F1> <ESC>
    nnoremap <F1> <ESC>
    vnoremap <F1> <ESC>

    " SHIFT is optional when i save files (or any other ':' commands)
    "nnoremap ; :

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

    " 'wall' saves all open buffers if modified (vs 'update' which just applies to current buffer)
    nmap <leader>w :wall<CR>
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
    nnoremap <space> zA     " Open/close folds

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
    autocmd BufWritePre *.py,*.mako,*.js,*.css,*.less,*.sls,*.cpp,*.h,*.todo,*.txt,*.ini,*.taskpaper,*.vim,.vimrc call DeleteTrailingWhitespace()
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
    " Note: also used by CtrlP
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

" Restore Cursor Position (on window open) {{
    function! ResCur()
    if line("'\"") <= line("$")
        normal! g`"
        return 1
    endif
    endfunction

    augroup resCur
    autocmd!
    autocmd BufWinEnter * call ResCur()
    augroup END
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

    "----- CtrlP -----
    " YankRing already uses <c-p>
    let g:ctrlp_map = '<leader>f'
    " Fast buffer access
    nnoremap ; :CtrlPBuffer<CR>
    " Configure 'mixed' mode to show both buffers and files (relative
    " to project) so I don't have to remember if file is open or not
    " and choose corresponding 'file' or 'buffer' mode)
    let g:ctrlp_cmd = 'CtrlPMixed'
    let g:ctrlp_mruf_relative = 1   " Exclude files outside project
    " Include dotfiles
    let g:ctrlp_show_hidden = 1

    " Open X files in vertical splits, rest hidden. 'r' makes first file open in existing buffer (instead of new one)
    let g:ctrlp_open_multiple_files = '4vr'

    " Search upward for repository root
    let g:ctrlp_working_path_mode = 'ra'

    "let g:ctrlp_custom_ignore = {
    "    \ 'dir':  '\v[\/]\.(git|hg|svn)$|tmp$',
    "    \ 'file': '\v\.(exe|pyc|so|dll|yaml|DS_Store)$',
    "    \ }
    " Flip mappings, I use 'reset' a lot, never 'regex'
    let g:ctrlp_prompt_mappings = {
        \ 'ToggleRegex()':        ['<F5>'],
        \ 'PrtClearCache()':      ['<c-r>'],
        \ }

    " Always open files in new buffers
    let g:ctrlp_switch_buffer = 0

    " ----- Silver Searcher (fast grep) -----
    " Use Silver Searcher w/ 'grep' and 'CtrlP' (if available)
    if executable('ag')
        " Use ag over grep
        set grepprg=ag\ --nogroup\ --nocolor\ --hidden

        " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
        let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'

        " ag is fast enough that CtrlP doesn't need to cache
        let g:ctrlp_use_caching = 0
    endif

    " Fast find shortcut
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

    " ----- Vimux -----
    "nnoremap <leader>rp :update<CR>:VimuxPromptCommand<CR>
    "nnoremap <leader>rl :update<CR>:VimuxRunLastCommand<CR>
    ""nnoremap <leader>rl :update<CR>:VimuxPromptCommand<CR>!!<CR>
    "nnoremap <leader>rx :VimuxCloseRunner<CR>
    "nnoremap <leader>ri :VimuxInspectRunner<CR>
    "nnoremap <leader>rs :VimuxInterruptRunner<CR>
    ""nnoremap <leader>rc :VimuxClearRunnerHistory<CR>

    " ----- Gundo -----
    noremap <leader>U :GundoToggle<CR>

    " ----- Fugitive -----
    noremap <leader>gs :Gstatus<CR>
    " Git commit plays better with pre-commit hook (shows console output + "Gcommit" seems to trigger hook 2x, once
    " before commit message and once after).
    noremap <leader>gc :Git commit<CR>
    noremap <leader>gv :Git commit --no-verify<CR>
    noremap <leader>gl :Glog<CR>
    noremap <leader>gb :Gblame<CR>
    noremap <leader>gd :Gvdiff<CR>
    noremap <leader>ge :Gedit<CR>
    noremap <leader>gr :Gread<CR>
    noremap <leader>gw :Gwrite<CR>
    " mparent(2014-02-18): testing easy way to scroll through diffs
    "noremap ]d <C-N>:<C-U>execute <SID>StageDiff('Gvdiff')<CR><C-W>k
    "noremap ]d <C-N> D <C-W>k

    " ----- Indent Guides -----
    let g:indent_guides_auto_colors = 0
    autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=11
    autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=5

    " ----- Lightline -----
    "  See .vim/plugin/lightline.vim

    " ----- Local Vimrc -----
    " Local vimrc's complain about sandbox mode, so disable it (but need to use whitelist for security)
    let g:localvimrc_sandbox = 0
    " Only trust certain localvimrc files
    let g:localvimrc_whitelist = expand('$HOME/.lvimrc')

    " ----- NerdTree -----
    noremap <leader>n :NERDTreeToggle<CR>
    noremap <leader>N :NERDTreeFind<CR>
    let NERDTreeIgnore=[ '\.pyc$', '\.pyo$', '\.py\$class$', '\.obj$', '\.o$', '\.so$', '\.egg$', '^\.git$' ]
    " Show hidden files, too
    let NERDTreeShowFiles=1
    let NERDTreeShowHidden=1
    " Quit on opening files from the tree
    "let NERDTreeQuitOnOpen=1
    " Highlight the selected entry in the tree
    let NERDTreeHighlightCursorline=1

    " ----- NERDCommenter -----
    let g:NERDMenuMode = 0  " Disable menu

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
                               \ 'active_filetypes': [],
                               \ 'passive_filetypes': ['javascript', 'css', 'python'] }
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

" Miscellaneous {{

    " Highlight VCS conflict markers
    match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

    " cd to current buffer's directory
    nnoremap <silent> <leader>cd :cd %:p:h<CR>

    " Load optional local VIMRC
    if filereadable(expand("~/.vimrc.local"))
        source ~/.vimrc.local
    endif

" }}
