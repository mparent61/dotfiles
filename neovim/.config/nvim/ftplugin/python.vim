" Organize imports

aug python
    au!
    autocmd BufWritePre *.py Isort
    autocmd BufWritePre *.py Black
aug END

function! FormatPythonFile()
    " Run all standard Python auto-formatting tools
    "
    " Call Black/Isort first (even though they will runa gain on Save), to
    " ensure Autoflake works on formatted file.
    Black
    Isort
    call Autoflake()
    write
endfunction
nnoremap <silent> <localleader>f :call FormatPythonFile()<CR><CR>

" Autoflake
let g:autoflake_remove_all_unused_imports=1
let g:autoflake_remove_unused_variables=1
let g:autoflake_disable_show_diff=1
" Must point to our virtual enviroment binary
let g:autoflake_cmd=expand('~/.virtualenvs/neovim/bin/autoflake')



"======================================================================
" Toggle breakpoints
"----------------------------------------------------------------------
python3 << EOF
import vim
import re

ipdb_breakpoint = 'breakpoint()'

def set_breakpoint():
    breakpoint_line = int(vim.eval('line(".")')) - 1

    current_line = vim.current.line
    white_spaces = re.search('^(\s*)', current_line).group(1)

    vim.current.buffer.append(white_spaces + ipdb_breakpoint, breakpoint_line)

def remove_breakpoints():
    op = 'g/^.*%s.*/d' % ipdb_breakpoint
    vim.command(op)

def toggle_breakpoint():
    breakpoint_line = int(vim.eval('line(".")')) - 1
    if ipdb_breakpoint in vim.current.buffer[breakpoint_line]:
        remove_breakpoints()
    elif ipdb_breakpoint in vim.current.buffer[breakpoint_line-1]:
        remove_breakpoints()
    else:
        set_breakpoint()
    vim.command(':w')

vim.command('map <localleader>b :py3 toggle_breakpoint()<cr>')
EOF
"======================================================================
