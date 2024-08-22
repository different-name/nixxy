# <img src="https://raw.githubusercontent.com/Different-Name/nix-files/master/assets/nix-snowflake-colours.svg" height=26> nix-files

My NixOS configuration files

> [!WARNING]
> This configuration is a work in progress - see [issues](https://github.com/Different-Name/nix-files/issues), and is intended for personal use only

- Multi host & multi user
- Flake based
- Desktop environment configurations with Hyprland
- Server configurations
- Declarative disk partitioning with [disko](https://github.com/nix-community/disko) with zfs full disk encryption
- Ephemeral root and home (state is opt in, managed by [impermanence](https://github.com/nix-community/impermanence))
- Declarative home with [home-manager](https://github.com/nix-community/home-manager)

## Structure

```
system - system level configuration
├── common - system config shared between systems
│   └── <category> - [ global, desktop, server, extra ]
│       ├── core     - boot, networking, security, etc
│       ├── hardware - bluetooth, video cards, etc
│       ├── nix      - nix-related options
│       ├── programs - programs.* configuration
│       └── services - services.* configuration
├── hosts - host specific system config
│   └── <host>
│       ├── default.nix
│       ├── disk-configuration.nix - disk partitions & filesystems
│       └── hardware-configuration.nix
└── users - user system configuration

home - home level configuration 
├── common - home config shared between systems
│   └── <category> - [ global, desktop, extra ]
│       ├── assets   - images, etc
│       ├── programs - home programs.* configuration
│       └── services - home services.* configuration
└── users
    └── <name> - user home configuration
        └── hosts - user@host home configuration

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