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
├── users    - user configuration
└── modules  - NixOS modules


home - home level configuration 
├── common - home configuration modules
│   ├── graphical - graphical programs.* configuration
│   ├── services  - services.* configuration
│   └── terminal  - terminal programs.* configuration
├── profiles - home configuration "presets"
├── users
│   └── <name> - user home configuration
│       └──  hosts   - user@host home configuration
└── modules  - NixOS modules

pkgs    - package definitions, sources tracked with nvfetcher
patches - .patch files
secrets - age secrets
assets  - images, etc
```

### More options!

Here, every configuration file is always imported - **except** for host-specific and home-manager user-specific files

Instead of choosing functionality by importing configuration files, reusable configurations are bundled as modules, which can be enabled, disabled and overriden as desired. For example, to enable the hyprland configuration:

```nix
nix-files.programs.hyprland.enable = true;
```

To reduce boilerplate and simplify configuration, commonly used options are group into "profiles" based on their usecase. Instead of enabling `hyprland`, `xdg` & `pipewire` individually on all graphical systems, they are bundled into the `graphical` profile:

```nix
nix-files.profiles.graphical.enable = true;
```

As a result, host & user files mostly only work with high level `nix-files` options, where entire configurations and groups of configurations can be enabled and disabled

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