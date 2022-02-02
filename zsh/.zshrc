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

#======================================================================
# OH-MY-ZSH
#======================================================================

export ZSH=$HOME/.oh-my-zsh
export ZSH_CUSTOM=$HOME/.zsh
export ZSH_THEME="phalanx"

# Disable oh-my-zsh title updating for tmux
export DISABLE_AUTO_TITLE="true"

# Silently update
export DISABLE_UPDATE_PROMPT=true
# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# This should automatically trigger periodic `brew cleanup` housekeeping
export HOMEBREW_INSTALL_CLEANUP="true"

plugins=(
  autojump
  brew
  direnv
  docker
  fzf
  git
  gitfast
  history
  kubectl
  macos
  python
  terraform
  tmux
  vi-mode
  virtualenv
)

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
alias v='vim'
alias vi='vim'
alias vimdiff='vim -d'
# Sudo VIM
alias sv='sudo vim'
alias svi='sudo vim'
alias svim='sudo vim'
alias vimrc='vim ~/.vimrc'
alias zshrc='vim ~/.zshrc'
alias brewcheck='brew update && brew outdated && brew doctor'
alias g='git'
alias gi='git'
alias gs='git st'
alias gc='git commit'
alias gcv='git commit --no-verify'
# CD to current git repo root
alias cdr='$(git rev-parse --show-toplevel)'
# Use GitHub git wrapper
alias git=hub
# Common typo
alias gti=git
# Docker
alias dock=docker
alias dm=docker-machine
alias dc=docker-compose
# Terraform
alias tf=terraform
# HTTPie (Curl Replacement)
alias http='http --style solarized'
# OSX HTOP requires sudo
alias htop='sudo htop'
# Include hidden files by default
alias ag='ag --hidden'
# The default -I uses a HEAD request, which sometimes behaves differently than GET
alias curli='curl -I -XGET'
## Fancy Diff
#alias diff="diff-so-fancy"
# Modern CLI replacements
# https://github.com/ibraheemdev/modern-unix
alias ls="exa"
alias l="exa -lahF"
alias du="dust"
alias df="duf"
alias tree="broot"
alias bat="bat --theme GitHub"
alias cat="bat"
alias find="fd"
# Run local webserver serving local directory
alias webserver="ruby -run -e httpd . -p 80"

# Filter processes (ignoring piped grep command)
pgrep(){ ps aux | grep -i "$@" | grep -v 'grep'; }
# Vim Directory Diff
ddiff() { vim '+next' "+execute \"DirDiff\" \"$1\" \"$2\""; }

export EDITOR=`which nvim`

export GREP_OPTIONS='--color=auto'

# Save LOTS of history
export HISTSIZE=100000
export SAVEHIST=100000
# Skip duplicates
setopt HIST_FIND_NO_DUPS
source $ZSH/plugins/history-substring-search/history-substring-search.zsh
# Default is UP/DOWN arrows, but CTRL-J/K is faster
bindkey '^K' history-substring-search-up
bindkey '^J' history-substring-search-down
# Use this to remove duplicates from history (shouldn't be anymore now that I've set disabled dupes)
# https://github.com/zsh-users/zsh-history-substring-search/issues/19#issuecomment-366102754
function dedupHistory() {
    cp ~/.zsh_history{,-old}
    tmpFile=`mktemp`
    awk -F ";" '!seen[$2]++' ~/.zsh_history > $tmpFile
    mv $tmpFile ~/.zsh_history
}

# Reload latest crontab
if [[ -f ~/.crontab.$(hostname) ]]; then
    crontab ~/.crontab.$(hostname)
fi

# Always use Python 3 (no more 2)
export VIRTUAL_ENV_DIR=$HOME/.virtualenvs
workon() {
  source $VIRTUAL_ENV_DIR/$1/bin/activate
}
mkvenv() {
    python3 -m venv $VIRTUAL_ENV_DIR/$1
    workon $1
}

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
mkcd(){
    if [[ -d $1 ]]; then
        echo "It already exists! cd to the directory."
        cd $1
    else
        mkdir -p $1 && cd $1
    fi
}

# Easy Curl + JQ
jcurl () {
    curl $@ | jq
}

whatismyip () {
    dig TXT +short o-o.myaddr.l.google.com @ns1.google.com  | sed 's/"//g'
}

# Easy DNS flush on OSX (works w/ High Sierra)
flushdns () {
  sudo killall -HUP mDNSResponder && echo "DNS cache has been flushed"
}

unalias z 2> /dev/null
z() {
  [ $# -gt 0 ] && fasd_cd -d "$*" && return
  local dir
  dir="$(fasd -Rdl "$1" | fzf -1 -0 --no-sort +m)" && cd "${dir}" || return 1
}


#----------------------------------------------------------------------
# FZF
#----------------------------------------------------------------------
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Customize FZF command to use RipGrep
# --files: List files that would be searched but do not search
# --no-ignore-vcs: Do not respect .gitignore, etc...
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
# --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
export FZF_DEFAULT_COMMAND='rg --files --no-ignore-vcs --hidden --follow --glob "!.git/*"'

#----------------------------------------------------------------------
# Auto-completion
#----------------------------------------------------------------------

# Look for completion scripts in ~/.zsh
fpath=(~/.zsh $fpath)

# Init shell auto-completion functionality
autoload -Uz compinit && compinit

# Add Kubernetes info to prompt
source "/opt/homebrew/opt/kube-ps1/share/kube-ps1.sh"
export KUBE_PS1_SYMBOL_USE_IMG=true

# McFly shell history search
eval "$(mcfly init zsh)"
export MCFLY_KEY_SCHEME=vim
export MCFLY_FUZZY=true
export MCFLY_LIGHT=true

# RipGrep requires you point to your config file
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# McFly history search - fix colors to work with Solarized
export MCFLY_LIGHT=TRUE

# Terraform auto-complete
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform

source /Users/mparent/.config/broot/launcher/bash/br

# Load host-specific config (ex: work stuff)
if [[ -f "${HOME}/.zshrc.${HOST}" ]]; then
    source "${HOME}/.zshrc.${HOST}"
fi
