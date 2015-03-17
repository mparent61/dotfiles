" Use for distraction-free writing
" Based on https://github.com/laktek/distraction-free-writing-vim
"
setlocal background=light

setlocal laststatus=0 		    " Hide status line
setlocal noruler 			    " Hide ruler
setlocal colorcolumn=           " No color column
setlocal linebreak 			    " Break lines on words
setlocal nonumber
setlocal norelativenumber       " Hide relative line numbering
setlocal wrap
setlocal showbreak=             " Disable wrap marker
setlocal foldenable             " Allow (chapter) folding
setlocal showtabline=0          " Never show tabline

setlocal nospell                " Spellcheck off by default
setlocal spelllang=en_us        " use U.S. English dictionary
nmap <silent> <localleader>s :set spell!<CR>

nmap <leader>w :!wc -w %<CR>

if has("gui_macvim")
    " mparent(2014-10-07): iawriter 'String' coloring (for dialog) is ugly
    colorscheme iawriter
    set fuoptions=background:#00f5f6f6  " Background color
    set fullscreen 		                " Fullscreen editing mode
    set guifont=Cousine:h16     " iA Writer uses this font
    set columns=80              " Size of editable area
    set linespace=5 		    " Spacing between lines
    set guioptions-=r 		    " Hide right scrollbar
"else
    "setlocal nocursorline       " Hide cursor line (messes up iawriter coloring in terminal)
endif
