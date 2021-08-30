# man zshzle
# vim binding for zsh
export KEYTIMEOUT=1 # reduce lag when switching vi mode (10 ms)
bindkey -v
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

# other vicmd bindings
bindkey -a 'H' vi-beginning-of-line
bindkey -a 'J' down-history
bindkey -a 'K' up-history
bindkey -a 'L' vi-end-of-line
bindkey -a 'U' vi-swap-case
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

# fix weird behaviour of backspace not working in viins
# https://github.com/spaceship-prompt/spaceship-prompt/issues/91
bindkey -v '^?' backward-delete-char

# different cursors to indicate vi mode
# https://ttssh2.osdn.jp/manual/4/en/usage/tips/vim.html for cursor shapes
cursor_mode() {
    # cursor_beam='\e[6 q'
    cursor_block='\e[2 q'
    cursor_uline='\e[4 q'

    function zle-keymap-select {
        if [[ ${KEYMAP} == vicmd ]]; then
            echo -ne $cursor_uline
        elif [[ ${KEYMAP} == main ]] ||
            [[ ${KEYMAP} == viins ]] ||
            [[ ${KEYMAP} = '' ]]; then
            echo -ne $cursor_block
        fi
    }

    zle-line-init() {
        echo -ne $cursor_block
    }

    zle -N zle-keymap-select
    zle -N zle-line-init
}
cursor_mode
