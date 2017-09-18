# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/mparent/.fzf/bin* ]]; then
  export PATH="$PATH:/Users/mparent/.fzf/bin"
fi

# Man path
# --------
if [[ ! "$MANPATH" == */Users/mparent/.fzf/man* && -d "/Users/mparent/.fzf/man" ]]; then
  export MANPATH="$MANPATH:/Users/mparent/.fzf/man"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/Users/mparent/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/Users/mparent/.fzf/shell/key-bindings.zsh"

