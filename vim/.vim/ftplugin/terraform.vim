"g:ale_terraform_fmt_options =

autocmd BufWritePre *.tf call DeleteTrailingWhitespace()
