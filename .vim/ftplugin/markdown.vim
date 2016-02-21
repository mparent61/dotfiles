" Distraction-free writing

setlocal spell                " Spellcheck on by default
setlocal spelllang=en_us      " Use U.S. English dictionary
nmap <silent> <localleader>s :set spell!<CR>

nmap <leader>w :!wc -w %<CR>


" Goyo Auto-Starter
function! s:auto_goyo()
if &ft == 'markdown'
    Goyo 80
elseif exists('#goyo')
    let bufnr = bufnr('%')
    Goyo!
    execute 'b '.bufnr
endif
endfunction

if has("gui_macvim")
    "set fullscreen 		        " Fullscreen editing mode
    colorscheme pencil
    set guifont=Cousine:h16     " iA Writer uses this font

    " Enable Goyo Distraction-Free Mode
    augroup goyo_markdown
        autocmd!
        autocmd BufNewFile,BufRead * call s:auto_goyo()
    augroup END

endif

setlocal nocursorline

"" Initailize vim-pencil (does this work?)
"call pencil#init()
