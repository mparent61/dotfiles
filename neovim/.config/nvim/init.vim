" From nvim's ":help nvim-from-vim" guide
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" Experimental
" set termguicolors  " True color support

let g:python2_host_prog = '/usr/local/opt/python@2/bin/python2'
let g:python3_host_prog = '/usr/local/opt/python@3.8/bin/python3'
