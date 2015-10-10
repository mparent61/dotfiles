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
         docker
         fabric
         git
         history
         mercurial
         osx
         python
         sudo
         tmux
         tmuxinator
         vagrant
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
alias brewcheck='brew update && brew outdated && brew doctor'
alias gs='git st'
alias gc='git commit'
alias gcv='git commit --no-verify'
# CD to current git repo root
alias cdr='$(git rev-parse --show-toplevel)'
# Use GitHub git wrapper
alias git=hub
# Travis CI
alias travislogin='travis login --auto --pro'
# Docker
alias dock=docker
alias dm=docker-machine
alias dc=docker-compose
# HTTPie (Curl Replacement)
alias http='http --style solarized'

# Filter processes (ignoring piped grep command)
pgrep(){ ps aux | grep -i "$@" | grep -v 'grep'; }
# Vim Directory Diff
ddiff() { vim '+next' "+execute \"DirDiff\" \"$1\" \"$2\""; }

export EDITOR=`which vim`

export GREP_OPTIONS='--color=auto'

# Save LOTS of history
export HISTSIZE=100000
export SAVEHIST=100000
source $ZSH/plugins/history-substring-search/history-substring-search.zsh
# Default is UP/DOWN arrows, but CTRL-J/K is faster
bindkey '^K' history-substring-search-up
bindkey '^J' history-substring-search-down

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

## Enable colored output (via homebrew's coreutils g* commands)
if [ `uname` = "Linux" ]; then
    eval `dircolors ~/.dir_colors/dircolors.ansi-light`
else
    eval `gdircolors ~/.dir_colors/dircolors.ansi-light`
    alias ls='gls --color'
fi

# Fast switch between VIM + SZH
# http://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/
fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

# added by travis gem
[ -f /Users/michaelparent/.travis/travis.sh ] && source /Users/michaelparent/.travis/travis.sh

# User Bin
export PATH=~/util/bin:$PATH

if [[ -f "${HOME}/.zshrc.local" ]]; then
    source "${HOME}/.zshrc.local"
fi

