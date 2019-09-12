" Distraction-free writing

setlocal spell                " Spellcheck on by default
setlocal spelllang=en_us      " Use U.S. English dictionary
nmap <silent> <localleader>s :set spell!<CR>

" Open preview
nmap <leader>mo :MarkedOpen<CR>

set wrap

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

"---------- Markdown Plugin Config ----------
" Auto-folding is annoying, I like to see entire doc
let g:vim_markdown_folding_disabled = 1
