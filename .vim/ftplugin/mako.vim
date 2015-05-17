setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2

" Match <tag></tag> and <%tag></%tag>
let b:match_words = '<\@<=\(\w\w*\):<\@<=/\1,' .
                   \ '<\@<=\([%\w]\w*\):<\@<=/\1,{:}'
