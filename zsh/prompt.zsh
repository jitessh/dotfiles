# User customizable options
# PR_ARROW_CHAR="[character]"   - prompt character
# RPR_SHOW_USER=(true, false)   - show username in rhs prompt
# RPR_SHOW_HOST=(true, false)   - show host in rhs prompt
# RPR_SHOW_GIT=(true, false)    - show git status in rhs prompt
# PR_EXTRA() {stuff}            - extra content to add to prompt
# RPR_EXTRA() {stuff}           - extra content to add to rhs prompt

# Allow for variable/function substitution in prompt
setopt prompt_subst

# Load color variables to make it easier to color things
autoload -U colors && colors

# Customizable options
PR_ARROW_CHAR="->"
RPR_SHOW_GIT=true
RPR_SHOW_HOST=true
RPR_SHOW_USER=true

# Different preset prompts
# Define your own prompts in PCMD() & RCMD()
PROMPT_MODE=0
PROMPT_MODES=4

# Show select exported environment variables
# eg: _pr_var_list=("EDITOR" "TERMINAL")
_pr_var_list=()
_vars_multiline=false

# Make using 256 colors easier
if [[ "$(tput colors)" == "256" ]]; then
    typeset -Ag FX FG BG

    FX=(
        reset     "%{[00m%}"
        bold      "%{[01m%}" no-bold      "%{[22m%}"
        italic    "%{[03m%}" no-italic    "%{[23m%}"
        underline "%{[04m%}" no-underline "%{[24m%}"
        blink     "%{[05m%}" no-blink     "%{[25m%}"
        reverse   "%{[07m%}" no-reverse   "%{[27m%}"
    )

    for color in {000..255}; do
        FG[$color]="%{[38;5;${color}m%}"
        BG[$color]="%{[48;5;${color}m%}"
    done

    # change default colors
    fg[red]=$FG[160]
    fg[green]=$FG[040]
    fg[yellow]=$FG[214]
    fg[blue]=$FG[033]
    fg[magenta]=$FG[125]
    fg[cyan]=$FG[037]

    fg[teal]=$FG[041]
    fg[orange]=$FG[166]
    fg[violet]=$FG[061]
    fg[neon]=$FG[112]
    fg[pink]=$FG[183]
else
    fg[teal]=$fg[blue]
    fg[orange]=$fg[yellow]
    fg[violet]=$fg[magenta]
    fg[neon]=$fg[green]
    fg[pink]=$fg[magenta]
fi

# Current directory, truncated to 2 path elements (or 3 when one of them is "~")
# The number of elements to keep can be specified as ${1}
function PR_DIR() {
    local sub="${1}"
    [[ -z "${sub}" ]] && sub=2

    local len="$(( ${sub} + 1 ))"
    local full="$(print -P "%d")"
    local relfull="$(print -P "%~")"
    local shorter="$(print -P "%${len}~")"
    local current="$(print -P "%${len}(~:.../:)%${sub}~")"
    local last="$(print -P "%1~")"

    # Longer path for '~/...'
    [[ "${shorter}" == \~/* ]] && current="${shorter}"

    local truncated="${current%/*}/"

    # Handle special case of directory '/' or '~something'
    [[ "${truncated}" == "/" || "${relfull[1,-2]}" != */* ]] && truncated=""

    # Handle special case of last being '/...' one directory down
    [[ "${full[2,-1]}" != "" && "${full[2,-1]}" != */* ]] && { truncated="/"; last="${last[2,-1]}"; }

    echo "%{$fg[cyan]%}%B${truncated}%b%{$fg[blue]%}%B${last}%b%{$reset_color%}"
}

# An exclamation point if the previous command did not complete successfully
function PR_ERROR() {
    echo "%(?..%(!.%{$fg[violet]%}.%{$fg[red]%})%B!%b%{$reset_color%} )"
}

# The arrow in red (for root) or teal (for regular user)
function PR_ARROW() {
    echo "%(!.%{$fg[red]%}.%{$fg[teal]%})%B${PR_ARROW_CHAR}%b%{$reset_color%}"
}

# Set custom rhs prompt
# User in red (for root) or pink (for regular user)
function RPR_USER() {
    if [[ "${RPR_SHOW_USER}" == "true" ]]; then
        echo "%(!.%{$fg[red]%}.%{$fg[pink]%})%B%n%b%{$reset_color%}"
    fi
}

# Host in pink
function RPR_HOST() {
    if [[ "${RPR_SHOW_HOST}" == "true" ]]; then
        echo "%{$fg[pink]%}%B%m%b%{$reset_color%}"
    fi
}

# ' at ' in cyan outputted only if both user and host enabled
function RPR_AT() {
    if [[ "${RPR_SHOW_USER}" == "true" && "${RPR_SHOW_HOST}" == "true" ]]; then
        echo "%{$fg[cyan]%} at %{$reset_color%}"
    fi
}

# Build the rhs prompt
function RPR_INFO() {
    echo "$(RPR_USER)$(RPR_AT)$(RPR_HOST)"
}

# Set RHS prompt for git repositories
DIFF_SYMBOL="-"
GIT_PROMPT_SYMBOL=""
GIT_PROMPT_SEPERATOR="%{$fg[violet]%}%B/%b%{$reset_color%}"
GIT_PROMPT_PREFIX="%{$fg[violet]%}%B(%b%{$reset_color%}"
GIT_PROMPT_SUFFIX="%{$fg[violet]%}%B)%b%{$reset_color%}"
GIT_PROMPT_AHEAD="%{$fg[blue]%}%B$DIFF_SYMBOL%b%{$reset_color%}"
GIT_PROMPT_BEHIND="%{$fg[magenta]%}%B$DIFF_SYMBOL%b%{$reset_color%}"
GIT_PROMPT_MERGING="%{$fg[cyan]%}%B$DIFF_SYMBOL%b%{$reset_color%}"
GIT_PROMPT_UNTRACKED="%{$fg[red]%}%B$DIFF_SYMBOL%b%{$reset_color%}"
GIT_PROMPT_MODIFIED="%{$fg[yellow]%}%B$DIFF_SYMBOL%b%{$reset_color%}"
GIT_PROMPT_STAGED="%{$fg[green]%}%B$DIFF_SYMBOL%b%{$reset_color%}"
GIT_PROMPT_STASHED="%{$fg[pink]%}%B$DIFF_SYMBOL%b%{$reset_color%}"
GIT_PROMPT_DETACHED="%{$fg[neon]%}%B@%b%{$reset_color%}"

# Show Git branch/tag, or name-rev if on detached head
function parse_git_branch() {
    (git symbolic-ref -q HEAD || git name-rev --name-only --no-undefined --always HEAD) 2> /dev/null
}

function parse_git_detached() {
    if ! git symbolic-ref HEAD >/dev/null 2>&1; then
        echo "${GIT_PROMPT_DETACHED}"
    fi
}

# Show different symbols as appropriate for various Git repository states
# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh
# (<AHEAD><BEHIND><MERGING><SEPERATOR><UNTRACKED><MODIFIED><STAGED><STASHED>)(<branch>)
function parse_git_state() {
    # Compose this value via multiple conditional appends
    local GIT_STATE="" GIT_DIFF=""

    [[ -n "$(git log --oneline @{upstream}.. 2> /dev/null)" ]] && GIT_STATE="$GIT_STATE$GIT_PROMPT_AHEAD"

    [[ -n "$(git log --oneline ..@{upstream} 2> /dev/null)" ]] && GIT_STATE="$GIT_STATE$GIT_PROMPT_BEHIND"

    [[ -r "$(git rev-parse --git-dir 2> /dev/null)/MERGE_HEAD" ]] && GIT_STATE="$GIT_STATE$GIT_PROMPT_MERGING"

    [[ -n "$(git ls-files --other --exclude-standard :/ 2> /dev/null)" ]] && GIT_DIFF="$GIT_PROMPT_UNTRACKED"

    if ! git diff --quiet 2> /dev/null; then
        GIT_DIFF="$GIT_DIFF$GIT_PROMPT_MODIFIED"
    fi

    if ! git diff --cached --quiet 2> /dev/null; then
        GIT_DIFF="$GIT_DIFF$GIT_PROMPT_STAGED"
    fi

    if git rev-parse --verify --quiet refs/stash > /dev/null 2>&1; then
        GIT_DIFF="$GIT_DIFF$GIT_PROMPT_STASHED"
    fi

    [[ -n "$GIT_STATE" && -n "$GIT_DIFF" ]] && GIT_STATE="$GIT_STATE$GIT_PROMPT_SEPERATOR"
    GIT_STATE="$GIT_STATE$GIT_DIFF"

    [[ -n "$GIT_STATE" ]] && echo "$GIT_PROMPT_PREFIX$GIT_STATE$GIT_PROMPT_SUFFIX"
}

# If inside a Git repository, print its branch and state
function git_prompt_string() {
    if [[ "${RPR_SHOW_GIT}" == "true" ]]; then
        local git_where="$(parse_git_branch)"
        local git_detached="$(parse_git_detached)"
        [[ -n "$git_where" ]] && \
        echo "$GIT_PROMPT_SYMBOL$(parse_git_state)$GIT_PROMPT_PREFIX$git_detached%{$fg[magenta]%}%B${git_where#(refs/heads/|tags/)}%b%{$reset_color%}$GIT_PROMPT_SUFFIX"
    fi
}

# Function to toggle between prompt modes
function tog() {
    PROMPT_MODE=$(( (PROMPT_MODE + 1) % PROMPT_MODES))
}

function PR_EXTRA() {
    # do nothing by default
}

function vshow() {
    local v
    for v in "$@"; do
        if [[ "${v}" =~ '[A-Z_]+' ]]; then
            if [[ ${_pr_var_list[(i)${v}]} -gt ${#_pr_var_list} ]]; then
                _pr_var_list+=("${v}")
            fi
        fi
    done
}

function vhide() {
    local v
    for v in "$@"; do
        _pr_var_list[${_pr_var_list[(i)${v}]}]=()
    done
}

function vmultiline() {
    if $_vars_multiline; then
        _vars_multiline=false
    else
        _vars_multiline=true
    fi
}

function PR_VARS() {
    local i v spc nl
    if $_vars_multiline; then
        spc=""
        nl="\n"
    else
        spc=" "
        nl=""
    fi
    for ((i=1; i <= ${#_pr_var_list}; i++)) do
        local v=${_pr_var_list[i]}
        if [[ -v "${v}" ]]; then
            # if variable is set
            if export | grep -Eq "^${v}="; then
                # if exported, show regularly
                printf '%s' "$spc%{$fg[cyan]%}${v}=${(P)${v}}%{$reset_color%}$nl"
            else
                # if not exported, show in red
                printf '%s' "$spc%{$fg[red]%}${v}=${(P)${v}}%{$reset_color%}$nl"
            fi
        fi
    done
    # show project-specific vars
    while read v; do
        if [[ "${v}" =~ '[A-Z_]+' ]]; then
            # valid environment variable
            if [[ ${_pr_var_list[(i)${v}]} -gt ${#_pr_var_list} ]]; then
                # not shown yet
                if export | grep -Eq "^${v}="; then
                    # exported
                    printf '%s' "$spc%{$fg[cyan]%}${v}=${(P)${v}}%{$reset_color%}$nl"
                fi
            fi
        fi
    done < <(git exec cat .showvars 2>/dev/null)
}

# Prompt
function PCMD() {
    if (( PROMPT_MODE == 0 )); then
        if $_vars_multiline; then
            echo "$(PR_VARS)$(PR_EXTRA)$(PR_DIR) $(PR_ERROR)$(PR_ARROW) " # space at the end
        else
            echo "$(PR_EXTRA)$(PR_DIR)$(PR_VARS) $(PR_ERROR)$(PR_ARROW) " # space at the end
        fi
    elif (( PROMPT_MODE == 1 )); then
        echo "$(PR_DIR 1) $(PR_ERROR)$(PR_ARROW) " # space at the end
    else
        echo "$(PR_DIR 2) $(PR_ERROR)$(PR_ARROW) " # space at the end
    fi
}

PROMPT='$(PCMD)' # single quotes to prevent immediate execution
RPROMPT='' # set asynchronously and dynamically

function RPR_EXTRA() {
    # do nothing by default
}

# Right-hand prompt
function RCMD() {
    if (( PROMPT_MODE == 0 )); then
        echo "$(RPR_EXTRA)$(git_prompt_string) $(RPR_INFO)"
    elif (( PROMPT_MODE == 1 )); then
        echo "$(git_prompt_string)"
    else
        echo "$(RPR_EXTRA)"
    fi
}

ASYNC_PROC=0
function precmd() {
    function async() {
        # save to temp file
        printf "%s" "$(RCMD)" > "/tmp/zsh_prompt_$$"

        # signal parent
        kill -s USR1 $$
    }

    # do not clear RPROMPT, let it persist

    # kill child if necessary
    if [[ "${ASYNC_PROC}" != 0 ]]; then
        kill -s HUP $ASYNC_PROC >/dev/null 2>&1 || :
    fi

    # start background computation
    async &!
    ASYNC_PROC=$!
}

function TRAPUSR1() {
    # read from temp file
    RPROMPT="$(cat /tmp/zsh_prompt_$$)"

    # reset proc number
    ASYNC_PROC=0

    # redisplay
    zle && zle reset-prompt
}
