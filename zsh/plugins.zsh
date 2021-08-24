function zsh_add_plugin() {
    local PLUGIN_NAME="${1##*\/}"
    local PLUGIN_DIR="${ZDOTDIR:-$HOME/.config/zsh}/plugins/$PLUGIN_NAME"

    if [ ! -d "$PLUGIN_DIR" ]; then
        # clone plugin ($1) if it does not exists in $PLUGIN_DIR
        printf "==> [zsh-plugin] Getting plugin '%s'\n" "$PLUGIN_NAME"
        git clone --depth 1 --recurse-submodules "https://github.com/${1}.git" "$PLUGIN_DIR" || \
            { printf "==> [zsh-plugin] Error getting plugin '%s'\n" "$PLUGIN_NAME"; return 1; }
    fi

    # at this point, $PLUGIN_DIR will exist, so source the plugin
    source "$PLUGIN_DIR/$PLUGIN_NAME.plugin.zsh" || source "$PLUGIN_DIR/$PLUGIN_NAME.zsh" || source "$PLUGIN_DIR/$PLUGIN_NAME.sh"
}
