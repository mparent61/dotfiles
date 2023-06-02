[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Use VI input mode
set -o vi

# Cleaner history without duplicate commands
export HISTCONTROL=ignoredups

alias pt="pytest"
alias ptp="pytest -n 2"
alias ptm="ptw --runner 'pytest --testmon'"
alias ptpm="ptw --runner 'pytest --testmon -n 2'"

alias grepi='grep -i'
alias loadenv='set -o allexport; source .env; set +o allexport'

alias hs='history | grepi'

complete -C /usr/local/bin/terraform terraform
