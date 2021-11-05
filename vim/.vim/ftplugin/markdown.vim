" Distraction-free writing

setlocal spell                " Spellcheck on by default
setlocal spelllang=en_us      " Use U.S. English dictionary
nmap <silent> <localleader>s :set spell!<CR>

" Open preview
nmap <leader>mo :MarkedOpen<CR>

setlocal wrap
setlocal nolinebreak
setlocal nocursorline

"---------- Markdown Plugin Config ----------
" Auto-folding is annoying, I like to see entire doc
let g:vim_markdown_folding_disabled = 1
