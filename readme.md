# nix-files

> [!WARNING]
> - This configuration is a work in progress, and is intended for personal use only
> - This configuration is only intended for use with a single user

## Contents

| Folder             | Description                |
| ------------------ | -------------------------- |
| [`system`](system) | System level configuration |
| [`home`](home)     | Home level configuration   |
| [`pkgs`](pkgs)     | Package definitions        |

## Acknowledgements

- [Misterio77](https://github.com/Misterio77/nix-starter-configs)
- [fufexan](https://github.com/fufexan/nix-files)

## todo

#### features

- secrets management
- color picker
- workspaces overview
- an alias for fd that searches home or root, ignoring persisted files / folders
- persistent configs inside relevant config files
- create warning for directories in /persist that aren't being used
- mouse buttons for workspace switching
- more intuitive keybinds and workspace management

#### styling

- waybar
- locker

#### organisation

- refactor modules
    - use options instead of imports for enabling modules
    - seperate optional and global modules
- document structure on readme
- replace hardcoded username
- write a module that takes a display scale, applys it for non wayland apps & disables xwayland scaling

#### issues
- autologin on other ttys means that locker is ineffective
- formatter builds too often
- steam folder permissions aren't set properly on install
- vscode can't find keyring - is keyring working?
- random audio spikes - i've noticed this in spin rhythm, once human and occasionally on the desktop
- proton games set to fullscreen in the game options will freeze / black screen when switching focus
- steam and vrchat seem to freeze when gta is running (only graphically)
- monospace fonts are not monospace on github
- trashing via thunar only works on persisted directories (low priority, i don't see why i'd need to move anything else to the trash)
- make steam games fullscreen by default
- cannot login to unity hub because xdg-open cannot recognise unity hub as the default application to open unity hub links
- not sure what hyprexpo does
- pre commit hooks not working

#### general

- look into tearing https://wiki.hyprland.org/Configuring/Tearing/
- look into why steam games seem to float by default
- tune pipewire latency https://nixos.wiki/wiki/PipeWire
- look into flake-parts and flake-root
- hypridle

#### wishlist

- slime vr server
- vrcx
- proton drive
- ente photos