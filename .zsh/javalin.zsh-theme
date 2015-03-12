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


# Called every time before prompt is set
function precmd {
    # On error, prompt is mostly red
    if [ $? -eq 0 ]; then
        # SUCCESS
        eval PR_COLOR_USER='%{$FG[061]%}'    # VIOLET
        eval PR_COLOR_HOST='%{$FG[033]%}'    # BLUE
        eval PR_COLOR_PROMPT='%{$FG[033]%}'  # BLUE
    else
        # FAILURE
        eval PR_COLOR_USER='%{$FG[160]%}'    # RED
        eval PR_COLOR_HOST='%{$FG[160]%}'    # RED
        eval PR_COLOR_PROMPT='%{$FG[160]%}'  # RED
    fi
}

if [ "x$OH_MY_ZSH_HG" = "x" ]; then
    OH_MY_ZSH_HG="hg"
fi

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

function hg_prompt_info {
    $OH_MY_ZSH_HG prompt --angle-brackets "\
< on %{$FG[125]%}<branch|quiet>%{$reset_color%}>\
< at %{$FG[136]%}<tags|%{$reset_color%|quiet}, %{$FG[136]%}>%{$reset_color%}>\
%{$FG[064]%}<status|modified|unknown><update>%{$reset_color%}<
patches: <patches|join( → )|pre_applied(%{$FG[136]%})|post_applied(%{$reset_color%})|pre_unapplied(%{$fg_bold[black]%})|post_unapplied(%{$reset_color%})>>" 2>/dev/null
}

function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || hostname -s
}

PROMPT='
[%{$PR_COLOR_USER%}%n%{$FG[245]%}|%{$PR_COLOR_HOST%}$(box_name)%{$reset_color%}] %{$FG[241]%}${PWD/#$HOME/~}%{$FG[033]%}$(git_prompt_info) $(virtualenv_info)%{$PR_COLOR_PROMPT%}%(?,,%{${FG[160]}%}[%?] )$%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$FG[125]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$FG[064]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$FG[064]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""

local return_status="%{$FG[160]%}%(?..✘)"
RPROMPT='${return_status}%{$reset_color%}'
