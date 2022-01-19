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

" Add custom support for "autoflake" fixer (not supported by ALE until next release after 3.1.0)
function! PythonAutoFlake(buffer) abort
    return {
    \   'command': 'autoflake --in-place --remove-all-unused-imports %t',
    \   'read_temporary_file': 1,
    \}
endfunction
execute ale#fix#registry#Add('autoflake', 'PythonAutoFlake', ['python'], 'autoflake for python')

let b:ale_fixers = {'python': [ "black", "isort", "autoflake", "trim_whitespace"]}
let b:ale_linters = {'python': ['flake8', 'mypy']}
let b:ale_python_mypy_options = '--config-file equipment/mypy.ini'
" TODO: For post-3.1.0
"let b:ale_python_autoflake_options = "--remove-all-unused-imports"

" Disable trailing whitespace warnings, Black will fix
let b:ale_warn_about_trailing_whitespace = 0

" ----- Jedi -----
let g:jedi#rename_command = "<localleader>r"  " Remap away for Dispatch
let g:jedi#force_py_version = 3
" Use deoplete-jedi, which uses Jedi asynchronously
let g:jedi#completions_enabled = 0

" ----- Semshi Syntax Highlighting -----
function MyCustomHighlights()
    " https://github.com/soerenberg/.dotfiles/blob/de32f8f502397b06c0c3d671d2d3631d21846aaa/.vimrc
    hi semshiLocal           ctermfg=37 guifg=#00afaf
    hi semshiGlobal          ctermfg=160 guifg=#d70000
    hi semshiImported        ctermfg=166 guifg=#d75f00 cterm=bold gui=bold
    hi semshiFree            ctermfg=125 guifg=#af005f
    hi semshiParameter       ctermfg=37 guifg=#00afaf
    hi semshiParameterUnused ctermfg=166 guifg=#d75f00 cterm=reverse gui=reverse
    hi semshiBuiltin         ctermfg=136 guifg=#af8700 cterm=bold gui=bold
    hi semshiAttribute       ctermfg=64  guifg=#00afaf
    hi semshiSelf            ctermfg=249 guifg=#b2b2b2
    hi semshiUnresolved      ctermfg=red guifg=#dc322f cterm=underline gui=underline
    hi semshiSelected        ctermfg=231 guifg=#ffffff ctermbg=161 guibg=#d7005f
    hi semshiErrorSign       ctermfg=231 guifg=#ffffff ctermbg=160 guibg=#d70000
    hi semshiErrorChar       ctermfg=231 guifg=#ffffff ctermbg=160 guibg=#d70000
    " sign define semshiError text=E> texthl=semshiErrorSign

endfunction
autocmd FileType python call MyCustomHighlights()
autocmd ColorScheme * call MyCustomHighlights()



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
