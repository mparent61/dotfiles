" Extends vim-ansible-yaml filetype checks
autocmd BufNewFile,BufRead *.yml,inventory  call s:SelectAnsibleCustomPaths()

" Detect based on additional base directories
fun! s:SelectAnsibleCustomPaths()
  let fp = expand("<afile>:p")

  " TODO: Combine into single regex (or even a variable, set by vimrc + vimrc local), but need to figure out the syntax
  if fp =~ '/ansible-.*/.*\.yml$'
    set filetype=ansible
    return
  endif

  if fp =~ '/ansible-.*/inventory$'
    set filetype=ansible
    return
  endif

endfun
