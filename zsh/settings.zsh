# initialize completions
autoload -Uz compinit && compinit -i
zstyle ':completion:*' menu select
zmodload zsh/complist

# tab complete hidden files
_comp_options+=(globdots)

# man zshcompsys for matcher-list
# match case insensitively
# allow partial completion before ., _ or -
# allow completing on the left side of the written text
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# better history
export HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh_history"
export HISTSIZE=1000000000
export SAVEHIST=$HISTSIZE
setopt extendedhistory histignorespace histsavenodups histignorealldups

# better completion
setopt alwaystoend completeinword

# better cd
setopt autocd autopushd pushdignoredups pushdminus

# other useful options (see man zshoptions)
setopt interactivecomments

# disable ^S to freeze terminal
stty stop undef

# disable auto-setting terminal title
DISABLE_AUTO_TITLE="true"

# disable highlighting pasted text
zle_highlight=('paste:none')

# this speeds up pasting with autosuggestions
# https://github.com/zsh-users/zsh-autosuggestions/issues/238#issuecomment-389324292
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish
