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

## Usage

Coming soon - see https://github.com/Different-Name/nix-files/issues/45

## Structure

```
nix-files/
├── assets - images, etc
├── home   - Home level configuration 
│   ├── <category> - one of global, desktop, or extra
│   │   ├── assets   - images, etc
│   │   ├── programs - home programs.* configuration
│   │   └── services - home services.* configuration
│   └── users
│       └── <name> - user home configuration
│           └── hosts - user@host home configuration
├── modules - NixOS modules
├── pkgs    - package definitions
├── secrets - age secrets
└── system  - system level configuration
    ├── <category> - one of global, desktop, or extra
    │   ├── core     - boot, networking, security, etc
    │   ├── hardware - bluetooth, video cards, etc
    │   ├── nix      - nix-related options
    │   ├── programs - programs.* configuration
    │   └── services - services.* configuration
    └── hosts
        └── <host>
            ├── default.nix
            ├── disk-configuration.nix
            └── hardware-configuration.nix
```

## Users

[./system/extra/users](system/extra/users) - user specific system configuration

[./home/users](home/users) - user specific home configuration

| User                                | Description                       |
| ----------------------------------- | --------------------------------- |
| [`different`](home/users/different) | Personal desktop environment user |
| [`iodine`](home/users/iodine)       | User for `iodine` server          |

## Hosts

[./home/users/\<name\>/hosts](home/users/different/hosts) - host specific system configuration

[./system/hosts](system/hosts) - host specific home configuration

| Host                                  | Description               |
| ------------------------------------- | ------------------------- |
| [`sodium`](system/hosts/sodium)       | Desktop - primary machine |
| [`potassium`](system/hosts/potassium) | Laptop                    |
| [`iodine`](system/hosts/iodine)       | Server                    |

## Acknowledgements

- [Graham Christensen - Erase your darlings](https://grahamc.com/blog/erase-your-darlings/)
- [Misterio77/nix-starter-configs](https://github.com/Misterio77/nix-starter-configs)
- [fufexan/dotfiles](https://github.com/fufexan/dotfiles)