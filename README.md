<div align="center">
    <h1>D0TF1LES</h1>
    <b>hello stranger, you've reached my ~</b>
    <p></p>
</div>

My dotfiles are deployed by [dotinit](https://github.com/voidstarsh/dotinit).
You can mirror my setup with `sh -c "$(curl -fsSL git.io/voidstart)"`.

But before you do so, let me give you a tour of my ~.


## $XDG_CONFIG_HOME everything
I like to keep my ~ clean. So whatever can go in `$XDG_CONFIG_HOME` is in `$XDG_CONFIG_HOME`.
- `~/.gitconfig` moved to `~/.config/git/config`.
- `~/.tmux.conf` moved to `~/.config/tmux/tmux.conf`.
- `~/.xinitrc` made to live in `~/.config/x11/xinitrc` with `$XINITRC` variable.
    - NOTE: `startx` does not respect this variable. Specify filename as an argument to `startx` like `startx ~/.config/x11/xinitrc`.
- `~/.Xresources` moved to `~/.config/x11/Xresources`.
    - NOTE: Like above, you need to specify filename as an argument to `xrdb` like `xrdb ~/.config/x11/Xresources`.
- `~/.zshrc` made to live in `~/.config/zsh/.zshrc` with `$ZDOTDIR` variable.

Many programs like `git`, `neovim`, `zathura` already follow [XDG Base Directory Specification](https://wiki.archlinux.org/title/XDG_Base_Directory). So their config files resides where it's required by the program.

### Exceptions
Some files needs to be in ~ to ensure working of other programs (or when developers are too lazy to use `$XDG_CONFIG_HOME`).
- `~/.xprofile`: Read by display managers at login, basically an autostart file for your system.
- `~/.zprofile`: Sets environment variables (enabling other programs to use `$XDG_CONFIG_HOME`).


## Local customizations
Some of my dotfiles allow local customizations, which are files that are not checked out in git, to avoid some useless commits (like changing Xresources colorscheme) or to have private or temporary customizations.
- `git`: `~/.config/git/gitconfig_local`
- `tmux`: `~/.config/tmux/tmux_local.conf`
- `Xresources`: `~/.config/x11/Xresources_local`
- `zathura`: `~/.config/zathura/zathurarc_local`
- `zsh`: `~/.config/zsh/zshrc_local`


## License
Copyright (c) 2021 Jitesh. Released under the MIT License. See [LICENSE.md](LICENSE.md) for details.
