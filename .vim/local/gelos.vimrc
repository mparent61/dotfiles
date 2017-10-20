"--------------------------------------------------
" Local Onion Vim Settings
"--------------------------------------------------

" Global find over all repos
nnoremap <leader>F :Files ~/dev<CR>

set spelllang=en
set spellfile=$HOME/Dropbox/vim/spell/onion.utf-8.add

"--------------------------------------------------
" Work-Specific File Types
"--------------------------------------------------
autocmd BufRead,BufNewFile *.py.j2 set filetype=python

" Extends vim-ansible-yaml filetype checks
autocmd BufNewFile,BufRead *.yml,*.yaml,inventory  call s:SelectAnsibleCustomPaths()
" Detect based on additional base directories
fun! s:SelectAnsibleCustomPaths()
  let fp = expand("<afile>:p")

  " Match ".yaml", "*.yml" and "inventory" files within Ansible directories
  if fp =~ '/ansible.*/\(.*\.ya\?ml\|inventory\)$'
    set filetype=ansible
    return
  endif

endfun

" Match any conf files inside an 'icinga' directory
au BufNewFile,BufRead **/icinga/**/*.conf set filetype=icinga2

" univision/devops-dns Zone Files
autocmd BufRead,BufNewFile *.zone.txt set filetype=zonefile

" Docker
autocmd BufNewFile,BufRead Dockerfile-* set ft=Dockerfile
