[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Use VI input mode
set -o vi

# Cleaner history without duplicate commands
export HISTCONTROL=ignoredups

alias pt="pytest"
# Parallel testing
alias ptp="pytest -n 3"
alias ptm="ptw --runner 'pytest --testmon'"
alias ptpm="ptw --runner 'pytest --testmon -n 2'"

alias grepi='grep -i'
alias loadenv='set -o allexport; source .env; set +o allexport'

alias hs='history | grepi'

alias getvim='apt update && apt install -y vim'

complete -C /usr/local/bin/terraform terraform

# Auto-run pytest on file changes
function ptw() {
    ARGS="$@"
    echo "--------------------------------------------------"
    echo "PyTest auto-runner"
    echo "ARGS: $ARGS"
    echo "--------------------------------------------------"
    # Initial run
    pytest --ff $ARGS
    # Watch for changes
    watchmedo shell-command --ignore-directories --wait --drop --patterns "*.ini;*.py;*.yaml;*.csv" --recursive ../ --command "pytest --ff $ARGS"
}
