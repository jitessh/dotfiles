#!/bin/sh
# profile - runs on login

# XDG base directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# this variable is respected by xinit, but not by startx
# instead specify filename as an argument to startx like
# startx "${XDG_CONFIG_HOME:-$HOME/.config}/x11/xinitrc"
export XINITRC="${XDG_CONFIG_HOME:-$HOME/.config}/x11/xinitrc"

# zsh config dir
export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

# default apps
export BROWSER="firefox"
export EDITOR="vim"
export TERMINAL="st"
