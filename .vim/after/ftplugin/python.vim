" PyTest/Django requires special plugin to use ipdb
" Must be loaded in '/after' to avoid python-mode plugin clobbering this setting
" when it auto-detects ipdb
" TODO: Could make this conditional depending on whether pytest is installed
let g:pymode_breakpoint_cmd = 'import pytest; pytest.set_trace()  # XXX BREAKPOINT'
