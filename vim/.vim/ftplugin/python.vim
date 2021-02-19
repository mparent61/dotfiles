" PEP-8 friendly settings, from http://henry.precheur.org/vim/python
setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal smarttab
setlocal expandtab

set foldlevel=1    " Open folds by default
set foldnestmax=1  " Max one-level folding (high-level only)


" ----- ALE -----
" Less jarring to have it always open (must set global "g:" option for some reason)
let g:ale_sign_column_always = 1

let b:ale_fixers = {'python': [ "black", "isort", "trim_whitespace"]}
let b:ale_linters = {'python': ['flake8']}

" Disable trailing whitespace warnings, Black will fix
let b:ale_warn_about_trailing_whitespace = 0

" ----- Jedi -----
let g:jedi#rename_command = "<localleader>r"  " Remap away for Dispatch
let g:jedi#force_py_version = 3
" Use deoplete-jedi, which uses Jedi asynchronously
let g:jedi#completions_enabled = 0


"======================================================================
" Toggle breakpoints
"----------------------------------------------------------------------
python << EOF
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

vim.command('map <localleader>b :py toggle_breakpoint()<cr>')
EOF
"======================================================================
