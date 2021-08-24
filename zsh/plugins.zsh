function zsh_add_plugin() {
    # pretty output
    local c_reset="\033[0m"
    local c_red="\033[1;31m"
    local c_green="\033[1;32m"

    local PLUGIN_NAME="${1##*\/}"
    local PLUGIN_DIR="${ZDOTDIR:-$HOME/.config/zsh}/plugins/$PLUGIN_NAME"

    if [ ! -d "$PLUGIN_DIR" ]; then
        # clone plugin ($1) if it does not exists in $PLUGIN_DIR
        printf "%b==> [zsh-plugin]%b Getting plugin '%s'\n" "$c_green" "$c_reset" "$PLUGIN_NAME"
        git clone --depth 1 --recurse-submodules "https://github.com/${1}.git" "$PLUGIN_DIR" || \
            { printf "%b==> [zsh-plugin]%b Error getting plugin '%s'\n" "$c_red" "$c_reset" "$PLUGIN_NAME"; return 1; }
    fi

    # at this point, $PLUGIN_DIR will exist, so source the plugin
    source "$PLUGIN_DIR/$PLUGIN_NAME.plugin.zsh" || source "$PLUGIN_DIR/$PLUGIN_NAME.zsh" || source "$PLUGIN_DIR/$PLUGIN_NAME.sh"
}
