# <img src="https://raw.githubusercontent.com/Different-Name/nix-files/master/assets/nixoscolorful.svg" height=26> nix-files

My NixOS configuration files

> [!WARNING]
> This flake is being actively developed for my specific use case. I don't guarantee that any of the packages, modules, or configurations have been tested or will be maintained
> 
> Please feel free to have a look around, contribute, or borrow ideas for your own project!

- Multi host & multi user
- Flake based
- Server and graphical system profiles
- Hyprland
- Declarative disk partitioning with [disko](https://github.com/nix-community/disko) with btrfs & luks full disk encryption
- Ephemeral root and home (state is opt in, managed by [impermanence](https://github.com/nix-community/impermanence))
- Declarative home with [home-manager](https://github.com/nix-community/home-manager)
- Package sources tracked using nvfetcher

## Structure

> [!WARNING]
> This section is under construction following [cb28266](https://github.com/different-name/nix-files/commit/cb28266f5dfc95054a26952e705f68c19a309756)

```
configurations
└── <host>
    ├── default
    ├── hardware-configuration
    └── disk-configuration

nixos
├── parts
│   ├── desktop
│   ├── hardware
│   ├── nix
│   ├── programs
│   ├── services
│   ├── system
│   └── theming
├── profiles
│   ├── global
│   ├── graphical
│   └── laptop
├── users
└── hosts

home
├── parts
│   ├── applications
│   ├── desktop
│   ├── games
│   ├── hardware
│   ├── media
│   ├── system
│   ├── terminal
│   ├── theming
│   └── xr
├── profiles
│   ├── global
│   └── graphical
└── users
    └── <user>
        └── hosts

modules
pkgs
secrets
patches
assets
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