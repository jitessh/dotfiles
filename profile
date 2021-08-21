#!/bin/sh
# profile - runs on login

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

# default apps
export BROWSER="firefox"
export EDITOR="vim"
export TERMINAL="st"
