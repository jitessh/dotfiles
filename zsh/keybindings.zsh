# man zshzle
# vim binding for zsh
export KEYTIMEOUT=1 # reduce lag when switching vi mode (10 ms)
bindkey -v
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

# undo & redo in vicmd mode
bindkey -a 'u' undo
bindkey -a '^R' redo

# history shortcuts
bindkey '^R' history-incremental-search-backward
bindkey '^J' down-history
bindkey '^K' up-history

# remap clear-screen
# ...in viins mode
bindkey "^O" clear-screen
bindkey "^L" end-of-line
# ...in vicmd mode
bindkey -a "^O" clear-screen
bindkey -a "^L" end-of-line

# edit command in vim with ^E
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^E' edit-command-line
