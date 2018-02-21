# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/michaelparent/.fzf/bin* ]]; then
  export PATH="$PATH:/Users/michaelparent/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/Users/michaelparent/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/Users/michaelparent/.fzf/shell/key-bindings.bash"

