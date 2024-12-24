# <img src="https://raw.githubusercontent.com/Different-Name/nix-files/master/assets/nix-snowflake-colours.svg" height=26> nix-files

My NixOS configuration files

> [!WARNING]
> This configuration is a work in progress, and is intended for personal use only

- Multi host & multi user
- Flake based
- Server and graphical system profiles
- Hyprland
- Declarative disk partitioning with [disko](https://github.com/nix-community/disko) with btrfs & luks full disk encryption
- Ephemeral root and home (state is opt in, managed by [impermanence](https://github.com/nix-community/impermanence))
- Declarative home with [home-manager](https://github.com/nix-community/home-manager)

## Structure

```
system - system level configuration
├── common - configuration modules
│   ├── core     - boot, networking, security, etc
│   ├── hardware - bluetooth, video cards, etc
│   ├── nix      - nix-related options
│   ├── programs - programs.* configuration
│   └── services - services.* configuration
├── hosts - host specific config
│   └── <host>
│       ├── default.nix
│       ├── hardware-configuration.nix
│       ├── disk-configuration.nix - disk partitions & filesystems
│       ├── fancontrol.nix - optional file for fan control
│       └── scripts - scripts specific to a host
├── profiles - configuration "presets"
└── users    - user configuration

home - home level configuration 
├── common - home configuration modules
│   ├── graphical - graphical programs.* configuration
│   ├── services  - services.* configuration
│   └── terminal  - terminal programs.* configuration
├── profiles - home configuration "presets"
└── users
    └── <name> - user home configuration
        ├──  hosts   - user@host home configuration
        └──  scripts - scripts specific to a user / user's host

secrets - age secrets
modules - NixOS modules
pkgs    - package definitions
assets  - images, etc
```

## Users

[./system/users](system/users) - user specific system configuration

[./home/users](home/users) - user specific home configuration

| User                                | Description                       |
| ----------------------------------- | --------------------------------- |
| [`different`](home/users/different) | Personal desktop environment user |
| [`iodine`](home/users/iodine)       | User for `iodine` server          |

## Hosts

[./system/hosts](system/hosts) - host specific system configuration

[./home/users/\<name\>/hosts](home/users/different/hosts) - host specific home configuration

| Host                                  | Description               |
| ------------------------------------- | ------------------------- |
| [`sodium`](system/hosts/sodium)       | Desktop - primary machine |
| [`potassium`](system/hosts/potassium) | Laptop                    |
| [`iodine`](system/hosts/iodine)       | Server                    |

## Acknowledgements

- [Graham Christensen - Erase your darlings](https://grahamc.com/blog/erase-your-darlings/)
- [Misterio77/nix-starter-configs](https://github.com/Misterio77/nix-starter-configs)
- [fufexan/dotfiles](https://github.com/fufexan/dotfiles)