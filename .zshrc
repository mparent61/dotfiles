export ZSH=$HOME/.oh-my-zsh
export ZSH_CUSTOM=$HOME/.zsh
export ZSH_THEME="phalanx"

# Disable oh-my-zsh title updating for tmux
export DISABLE_AUTO_TITLE="true"

# Disable bi-weekly auto-update checks
export DISABLE_AUTO_UPDATE="true"
# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Homebrewed Python
export PATH=/usr/local/bin:$PATH
# Some Homebrew installs (inc RabbitMQ)
export PATH=/usr/local/sbin:$PATH

plugins=(autojump
         brew
         fabric
         git
         history
         mercurial
         osx
         python
         tmux
         tmuxinator
         vi-mode
         virtualenv
         virtualenvwrapper)

source $ZSH/oh-my-zsh.sh

# CUSTOM OPTIONS

# Auto-correct sucks
unsetopt correct_all

alias reload='source ~/.zshrc'
alias x='chmod ugo+x'
alias top='top -o cpu'
alias hgv='hg vimdiff'
alias nt='nosetests'
alias nf='nt --failed'
alias v='vim'
alias vi='vim'
# Read-only VIM
alias vr='vim -M'
alias vimrc='vim ~/.vimrc'
alias zshrc='vim ~/.zshrc'
#alias plan='vim -O ~/Dropbox/TaskPaper/plan.taskpaper ~/Dropbox/TaskPaper/TODO.taskpaper'
alias plan='vim -O ~/plan.taskpaper ~/notes.txt'
alias brewcheck='brew update && brew outdated'
alias gs='git st'
alias gc='git commit'
alias gcv='git commit --no-verify'

# Filter processes (ignoring piped grep command)
pgrep(){ ps aux | grep -i "$@" | grep -v 'grep'; }
# Vim Directory Diff
ddiff() { vim '+next' "+execute \"DirDiff\" \"$1\" \"$2\""; }

export EDITOR=`which vim`

export GREP_OPTIONS='--color=auto'

export HISTSIZE=1000
export HISTFILESIZE=1000
export HISTCONTROL=erasedups
# Only store unique commands in history, delete older instances on add
setopt HIST_IGNORE_ALL_DUPS
source $ZSH/plugins/history-substring-search/history-substring-search.zsh
# Default is UP/DOWN arrows, but CTRL-J/K is faster
bindkey '^K' history-substring-search-up
bindkey '^J' history-substring-search-down

# View diffs on commit
export HGEDITOR=~/bin/hgeditor

# Reload latest crontab
if [[ -f ~/.crontab.$(hostname) ]]; then
    crontab ~/.crontab.$(hostname)
fi

# zsh-completions
fpath=(/usr/local/share/zsh-completions $fpath)

# Use setuptools by default, distribute deprecated
export VIRTUALENV_SETUPTOOLS=1
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/biz
if [ `uname` = "Darwin" ]; then
    source /usr/local/bin/virtualenvwrapper.sh
else
    # Ubuntu puts this in a weird spot
    source /etc/bash_completion.d/virtualenvwrapper
fi
## Auto-enable venv on entering directory with .venv file
#check_has_virtualenv() {
#    if [ -e .venv ]; then
#        workon `cat .venv`
#    fi
#}
#venv_cd () {
#    builtin cd "$@" && check_has_virtualenv
#}
#alias cd="venv_cd"

## Enable colored output (via homebrew's coreutils g* commands)
if [ `uname` = "Linux" ]; then
    eval `dircolors ~/.dir_colors/dircolors.ansi-light`
else
    eval `gdircolors ~/.dir_colors/dircolors.ansi-light`
    alias ls='gls --color'
fi

export NOSE_PROGRESSIVE_BAR_FILLED_COLOR=4  # BLUE (solarized)
