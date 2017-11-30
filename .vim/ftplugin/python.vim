" PEP-8 friendly settings, from http://henry.precheur.org/vim/python
setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal smarttab
setlocal expandtab

set foldlevel=1    " Open folds by default
set foldnestmax=1  " Max one-level folding (high-level only)

" nnoremap <localleader>l :wa<CR>:PymodeLint<CR>
" nnoremap <localleader>L :wa<CR>:PymodeLintAuto<CR>
"nnoremap <leader>l :!autopep8 --max-line-length=120 --in-place %<CR><CR>:w<CR>

" Trying out omni complete
"set omnifunc=pythoncomplete#Complete
inoremap <C-space> <C-x><C-o>

" Python-Mode
let g:pymode_run = 0  " I never use this, and it takes up a shortcut key
let g:pymode_folding = 0  " Disabled
"let g:pymode_lint_checker = 'pylint,pyflakes,pep8'
let g:pymode_lint = 0  " Use ALE instead
" CtrlP uses '<leader>b' already
"let g:pymode_breakpoint_key = '<localleader>b'
" Sets cursorcolumn (+ maybe other stuff)
let g:pymode_options_max_line_length = 100
let g:pymode_virtualenv = 1
let g:pymode_python = 'python3'

" Lots of ALE warnings
let g:pymode_rope = 0


let g:jedi#force_py_version = 3


" Force linters to use correct line length. Otherwise seem to always use '80' despite whatever
" set in config files.
let g:pymode_lint_options_pylint =
    \ {'max-line-length': g:pymode_options_max_line_length}
let g:pymode_lint_options_pep8 =
    \ {'max_line_length': g:pymode_options_max_line_length}


let g:ale_python_flake8_options = ''


" List of (non-pylint) errors to also ignore
" Ignore multiple whitespace before + after operator, as this can be
" useful for aligning code.
"   E201: whitespace after '{'
"   E202: whitespace before '}'
"   E221: multiple spaces before operator
"   E241: multiple spaces after operator
" I NEVER use multiple statements, except when debugging:
"       import pdb; pdb.set_trace()
" and these warnings are annoying.
"   E702: multiple statements on one line (semi-colon)
"   E501: Line length -- lots of legacy Onion code has long lines
" Overly verbose comment warnings, slows down development
"   E26  Fix spacing after comment hash.
" Flags valid SQLAlchemy filter statements: q.filter(User.name == None)
"   E711: comparison to None should be "if cond is None:"
"   E712: comparison to True should be "if cond is True:" or "if cond:"
"   C901: fucntion too complex
"   C0110: modules should have docstrings
"   C0302: Too many lines in module
"   C0330: Wrong continued indentation
"   R0901: Too many ancestors
"   R0912: Too many branches
"   R0915: Too many statements
"   R0924: Badly implemented container (eliminated from recent PyLint builds, python-mode is behind)
let g:pymode_lint_ignore = "E201,E202,E221,E241,E501,E702,E711,E712,C901,C0110,C0302,C0330,R0901,R0912,R0915,R0924"

let g:pymode_lint_sort = ['E', 'C', 'I']  " Sort errors by relevance

"" TESTING
"" Run tests for current module
"python << EOF
"def _PyRunModuleTest():
"    import os
"    import sys
"    import vim

"    b = vim.current.buffer
"    module_dir = os.path.dirname(b.name)
"    module = os.path.basename(b.name)

"    if module == '__init__.py':
"        # Special case: sub/dir/__init__.py has test file sub/dir/test_dir.py
"        module = os.path.basename(module_dir) + '.py'

"    if not module.startswith('test_'):
"        module = 'test_' + module

"    test_path = os.path.join(module_dir, module)
"    if os.path.exists(test_path):
"        # TODO: Set current virtual env
"        # TODO: Check if nose or py.test installed. Maybe use 'compiler' option?
"        #vim.command(':call VimuxRunCommand("dev && nosetests %s")' % test_path)
"        vim.command(':call VimuxRunCommand("py.test %s")' % test_path)
"    else:
"        sys.stderr.write('No test file exists!')
"EOF
"nnoremap <localleader>t :wa<CR>:python _PyRunModuleTest()<CR>
""nnoremap <localleader>u :wa<CR>:!fab unit<CR>

" Yapf auto-lint support
nnoremap <leader>y :0,$!yapf --style='{ COLUMN_LIMIT: 120}'<Cr>


" ----- Jedi -----
let g:jedi#rename_command = "<localleader>r"  " Remap away for Dispatch
let g:jedi#force_py_version = 3

" ----- ALE -----
let g:ale_python_flake8_executable = 'python3'

let g:ale_linters = {
\   'python': ['flake8'],
\}
