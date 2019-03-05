" Kinja uses Tabs
setlocal noexpandtab
setlocal tabstop=4
setlocal shiftwidth=4
setlocal softtabstop=4

" Enable vim-closer (auto match end on <ENTER>)
" Based on https://github.com/rstacruz/vim-closer/blob/e1dc398b181efb3f4b46d23113cdac8f6c52a29b/plugin/closer.vim#L13-L15
let b:closer = 1
let b:closer_flags = '([{'

" " TODO: What is this even for?
" function! SbtQuickfix()
" 	setlocal errorformat=%E\ %#[error]\ %#%f:%l:\ %m,%-Z\ %#[error]\ %p^,%-G\ %#[error]\ %m
" 	setlocal errorformat+=%W\ %#[warn]\ %#%f:%l:\ %m,%-Z\ %#[warn]\ %p^,%-G\ %#[warn]\ %m
" 	setlocal errorformat+=%C\ %#%m
" 	let file = "~/tmp/sbt.quickfix"
" 	call system("echo -n > " . file . "; for i in `find . | grep sbt.quickfix`; do grep -v '\\[warn\\]' $i >> " . file . "; done;")
" 	exe "cf " . file
" endfunction

" " TODO: Replace this with a plugin to call `sbt compile` which catches more errors
" function! ScalaC()
"     setlocal errorformat=%E%f:%l:\ %trror:\ %m
" 	setlocal errorformat+=%Z%p^
" 	setlocal errorformat+=%-G%.%#
" 	setlocal makeprg=scalac\ -Ystop-after:parser\ %
" 	silent! make
" 	redraw!
" 	cwindow
" endfunction

" nnoremap <buffer> <Leader>s :call SbtQuickfix()<CR>copen<CR>
" nnoremap <buffer> <leader>m :call ScalaC)<CR>
