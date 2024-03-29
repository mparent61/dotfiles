# SOLARIZED HEX     16/8 TERMCOL  XTERM/HEX   L*A*B      RGB         HSB
# --------- ------- ---- -------  ----------- ---------- ----------- -----------
# base03    #002b36  8/4 brblack  234 #1c1c1c 15 -12 -12   0  43  54 193 100  21
# base02    #073642  0/4 black    235 #262626 20 -12 -12   7  54  66 192  90  26
# base01    #586e75 10/7 brgreen  240 #585858 45 -07 -07  88 110 117 194  25  46
# base00    #657b83 11/7 bryellow 241 #626262 50 -07 -07 101 123 131 195  23  51
# base0     #839496 12/6 brblue   244 #808080 60 -06 -03 131 148 150 186  13  59
# base1     #93a1a1 14/4 brcyan   245 #8a8a8a 65 -05 -02 147 161 161 180   9  63
# base2     #eee8d5  7/7 white    254 #e4e4e4 92 -00  10 238 232 213  44  11  93
# base3     #fdf6e3 15/7 brwhite  230 #ffffd7 97  00  10 253 246 227  44  10  99
# yellow    #b58900  3/3 yellow   136 #af8700 60  10  65 181 137   0  45 100  71
# orange    #cb4b16  9/3 brred    166 #d75f00 50  50  55 203  75  22  18  89  80
# red       #dc322f  1/1 red      160 #d70000 50  65  45 220  50  47   1  79  86
# magenta   #d33682  5/5 magenta  125 #af005f 50  65 -05 211  54 130 331  74  83
# violet    #6c71c4 13/5 brmagenta 61 #5f5faf 50  15 -45 108 113 196 237  45  77
# blue      #268bd2  4/4 blue      33 #0087ff 55 -10 -45  38 139 210 205  82  82
# cyan      #2aa198  6/6 cyan      37 #00afaf 60 -35 -05  42 161 152 175  74  63
# green     #859900  2/2 green     64 #5f8700 60 -20  65 133 153   0  68 100  60

eval COLOR_BASE03='%{$FG[234]%}'
eval COLOR_BASE02='%{$FG[235]%}'
eval COLOR_BASE01='%{$FG[240]%}'
eval COLOR_BASE00='%{$FG[241]%}'
eval COLOR_BASE0='%{$FG[244]%}'
eval COLOR_BASE1='%{$FG[245]%}'
eval COLOR_BASE2='%{$FG[254]%}'
eval COLOR_BASE3='%{$FG[230]%}'
eval COLOR_YELLOW='%{$FG[136]%}'
eval COLOR_ORANGE='%{$FG[166]%}'
eval COLOR_RED='%{$FG[160]%}'
eval COLOR_MAGENTA='%{$FG[125]%}'
eval COLOR_VIOLET='%{$FG[061]%}'
eval COLOR_BLUE='%{$FG[033]%}'
eval COLOR_CYAN='%{$FG[037]%}'
eval COLOR_GREEN='%{$FG[064]%}'

# Called every time before prompt is set
function precmd {
    # On error, prompt is mostly red
    if [ $? -eq 0 ]; then
        # SUCCESS
        eval PR_COLOR_USER='$COLOR_BLUE'
        eval PR_COLOR_HOST='$COLOR_BLUE'
    else
        # FAILURE
        eval PR_COLOR_USER='$COLOR_RED'   # RED
        eval PR_COLOR_HOST='$COLOR_RED'   # RED
    fi
}

# Display username if not default user
prompt_username() {
  if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    echo -n "%{$PR_COLOR_USER%}"
    echo -n "%n"
    echo -n "%{$reset_color%}"
    echo -n "@"
  fi
}

git_extra_info() {
  # Show git stash count
  local STASH_COUNT=`git stash list 2> /dev/null | wc -l | tr -d '[[:space:]]'`
  if [ "$STASH_COUNT" -gt 0 ]
  then
    echo -n " %{$COLOR_BLUE%}($STASH_COUNT stashed)"
  fi

  ## Show ahead/behind
  #local NUM_AHEAD="$(git log --oneline @{u}.. 2> /dev/null | wc -l | tr -d ' ')"
  #if [ "$NUM_AHEAD" -gt 0 ]; then
  #  echo -n "A"
  #fi

  #local NUM_BEHIND="$(git log --oneline ..@{u} 2> /dev/null | wc -l | tr -d ' ')"
  #if [ "$NUM_BEHIND" -gt 0 ]; then
  #  echo -n "B"
  #fi

}


PROMPT='
'  # Newline

# Display username if not default user
PROMPT+='$(prompt_username)'
PROMPT+='%{$PR_COLOR_HOST%}$(hostname -s)'
PROMPT+='%{$reset_color%} '
PROMPT+='%{$COLOR_ORANGE%}${PWD/#$HOME/~}'
PROMPT+='%{$reset_color%}$(git_prompt_info)$(git_extra_info)'
PROMPT+=' '
PROMPT+='%{$COLOR_CYAN%}%(?,,%{$COLOR_RED%}[%?] )'
PROMPT+='
'  # Newline
# Kubernetes
PROMPT+='$(kube_ps1)'
# Terraform
PROMPT+=$'%{$COLOR_VIOLET%}$(tf_prompt_info)%{$reset_color%}'
# Python
PROMPT+=$'%{$COLOR_YELLOW%}$(virtualenv_prompt_info)%{$reset_color%}'
# Input Prompt Character
PROMPT+='%{$COLOR_BLUE%}$%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$COLOR_VIOLET%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$COLOR_GREEN%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$COLOR_GREEN]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# # mparent(2021-04-23): Disabled, the right-justified "✘" is hard to see and messes up copy-paste
# local return_status="%{$COLOR_RED%}%(?..✘)"
# RPROMPT='${return_status}%{$reset_color%}'
