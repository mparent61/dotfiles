" Distraction-free writing

setlocal nospell                " Spellcheck off by default
setlocal spelllang=en_us        " use U.S. English dictionary
nmap <silent> <localleader>s :set spell!<CR>

nmap <leader>w :!wc -w %<CR>

if has("gui_macvim")
    "set fullscreen 		        " Fullscreen editing mode
    colorscheme pencil
    set guifont=Cousine:h16     " iA Writer uses this font
endif

setlocal nocursorline

"" Initailize vim-pencil (does this work?)
"call pencil#init()
