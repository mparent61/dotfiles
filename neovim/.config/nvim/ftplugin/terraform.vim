"------------------------------------------------------------------------------------------
" Standard whitespace cleanup plus replace multiple blank lines with single blank line
function! FixTerraformWhitespace()
    " First, call default whitespace cleanup (from .vimrc)
    call DeleteTrailingWhitespace()

    " Next, replace multiple blank lines with single line

    " Save current cursor position
    let save_cursor = getpos(".")
    " Save last search
    let _s=@/

    " Fix newlines!
    :silent! %s/\(\n\n\)\n\+/\1/

    " Restore last search
    let @/=_s
    " Restore cursor
    call setpos('.', save_cursor)

endfunction

autocmd BufWritePre *.tf call FixTerraformWhitespace()
"------------------------------------------------------------------------------------------
