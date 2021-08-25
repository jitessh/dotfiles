function zsh_add_plugin() {
    # pretty output
    local c_reset="\033[0m" c_red="\033[1;31m" c_green="\033[1;32m"

    local PLUGIN_NAME="${1##*\/}"
    local PLUGIN_DIR="${ZDOTDIR:-$HOME/.config/zsh}/plugins/$PLUGIN_NAME"

    if [[ ! -d "$PLUGIN_DIR" ]]; then
        # clone plugin ($1) if it does not exists in $PLUGIN_DIR
        printf "%b==> [zsh-plugin]%b Getting plugin '%s'\n" "$c_green" "$c_reset" "$PLUGIN_NAME"

        git clone --depth 1 --recurse-submodules "https://github.com/${1}.git" "$PLUGIN_DIR" || \
        { printf "%b==> [zsh-plugin]%b Error getting plugin '%s'\n" "$c_red" "$c_reset" "$PLUGIN_NAME"; return 1; }
    fi

    # at this point, $PLUGIN_DIR will exist (except in
    # case of network issue), so source the plugin
    source "$PLUGIN_DIR/$PLUGIN_NAME.plugin.zsh" 2>/dev/null || \
    source "$PLUGIN_DIR/$PLUGIN_NAME.zsh" 2>/dev/null || \
    source "$PLUGIN_DIR/$PLUGIN_NAME.sh" 2>/dev/null || \
    { printf "%b==> [zsh-plugin]%b Error sourcing plugin '%s' from '%s'\n" "$c_red" "$c_reset" "$PLUGIN_NAME" "$PLUGIN_DIR"; return 1; }
}
