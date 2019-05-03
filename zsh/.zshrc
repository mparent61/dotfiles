# vim:ft=zsh:ts=2:sw=2:sts:et:
#
# Mike's ZSH Config

#======================================================================
# INTERNAL UTILITY FUNCTIONS
#======================================================================


# Returns whether the given command is executable or aliased.
_has() {
  return $( whence $1 >/dev/null )
}

# Returns whether the given statement executed cleanly. Try to avoid this
# because this slows down shell loading.
_try() {
  return $( eval $* >/dev/null 2>&1 )
}

# Returns whether the current host type is what we think it is. (HOSTTYPE is
# set later.)
_is() {
  return $( [ "$HOSTTYPE" = "$1" ] )
}

# Returns whether out terminal supports color.
_color() {
  return $( [ -z "$INSIDE_EMACS" ] )
}


#======================================================================
# OH-MY-ZSH
#======================================================================

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
export PATH="/usr/local/opt/python/libexec/bin:$PATH"
# Some Homebrew installs (inc RabbitMQ)
export PATH=/usr/local/sbin:$PATH
# For some reason this was missing...
export PATH=/usr/local/bin:$PATH

# This should automatically trigger periodic `brew cleanup` housekeeping
export HOMEBREW_INSTALL_CLEANUP="true"

plugins=(autojump
         brew
         docker
         fabric
         fzf
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



# PATH MODIFICATIONS

# Functions which modify the path given a directory, but only if the directory
# exists and is not already in the path. (Super useful in ~/.zshlocal)

_prepend_to_path() {
  if [ -d $1 -a -z ${path[(r)$1]} ]; then
    path=($1 $path);
  fi
}

_append_to_path() {
  if [ -d $1 -a -z ${path[(r)$1]} ]; then
    path=($path $1);
  fi
}

_force_prepend_to_path() {
  path=($1 ${(@)path:#$1})
}

# Aliases

alias reload='source ~/.zshrc'
alias x='chmod ugo+x'
# Switch to neovim
alias vim='nvim'
alias v='nvim'
alias vi='nvim'
alias vimdiff='nvim -d'
# Read-only VIM
alias vr='nvim -M'
# Sudo VIM
alias sv='sudo nvim'
alias svi='sudo nvim'
alias svim='sudo nvim'
alias vimrc='nvim ~/.vimrc'
alias zshrc='nvim ~/.zshrc'
alias plan='nvim -O ~/plan.taskpaper ~/notes.txt'
alias spacevim='nvim -u ~/.SpaceVim/init.vim'
alias brewcheck='brew update && brew outdated && brew doctor'
alias g='git'
alias gs='git st'
alias gc='git commit'
alias gcv='git commit --no-verify'
# CD to current git repo root
alias cdr='$(git rev-parse --show-toplevel)'
# Use GitHub git wrapper
alias git=hub
# Docker
alias dock=docker
alias dm=docker-machine
alias dc=docker-compose
# HTTPie (Curl Replacement)
alias http='http --style solarized'
# OSX HTOP requires sudo
alias htop='sudo htop'
# Include hidden files by default
alias ag='ag --hidden'
alias curli='curl -I -XGET'

# Filter processes (ignoring piped grep command)
pgrep(){ ps aux | grep -i "$@" | grep -v 'grep'; }
# Vim Directory Diff
ddiff() { nvim '+next' "+execute \"DirDiff\" \"$1\" \"$2\""; }

export EDITOR=`which nvim`

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
# Default to Python 3
export WORKON_HOME=$HOME/.virtualenvs
source `which virtualenvwrapper.sh`
mkvirtualenv2() {
    mkvirtualenv -p python2.7 "$@"
}
mkvirtualenv3() {
    mkvirtualenv -p python3 "$@"
}

# Use idpb for breakpoints
export PYTHONBREAKPOINT=ipdb.set_trace

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

# User Bin
export PATH=~/util/bin:$PATH

if [[ -f "${HOME}/.zshrc.local" ]]; then
    source "${HOME}/.zshrc.local"
fi


# fzf via Homebrew
if [ -e /usr/local/opt/fzf/shell/completion.zsh ]; then
  source /usr/local/opt/fzf/shell/key-bindings.zsh
  source /usr/local/opt/fzf/shell/completion.zsh
fi

# fzf + ag configuration
if _has fzf && _has ag; then
  export FZF_DEFAULT_COMMAND='ag --hidden --nocolor -g ""'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_DEFAULT_OPTS='
  --color fg:242,bg:236,hl:65,fg+:15,bg+:239,hl+:108
  --color info:108,prompt:109,spinner:108,pointer:168,marker:168
  '
fi


# Make Directory + CD to it
mkcdir ()
{
    mkdir -p -- "$1" &&
      cd -P -- "$1"
}

# Easy Curl + JQ
jcurl () {
    curl $@ | jq
}

whatismyip () {
    dig TXT +short o-o.myaddr.l.google.com @ns1.google.com
}

# Easy DNS flush on OSX (works w/ High Sierra)
flushdns () {
  sudo killall -HUP mDNSResponder && echo "DNS cache has been flushed"
}

#----------------------------------------------------------------------
# TESTING
#----------------------------------------------------------------------
# Ranger
function ranger-cd {
  tempfile='/tmp/chosendir'
  ranger --choosedir="$tempfile" "${@:-$(pwd)}"
  test -f "$tempfile" &&
  if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
    cd -- "$(cat "$tempfile")"
  fi
  rm -f -- "$tempfile"
}


#----------------------------------------------------------------------
# FZF
#----------------------------------------------------------------------
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
