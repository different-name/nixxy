# <img src="https://raw.githubusercontent.com/Different-Name/nix-files/master/assets/nixoscolorful.svg" height="26px" style="height: 26px;"> nix-files

My NixOS configuration files

> [!WARNING]
> This repo is my personal nixos configuration and is only intended for my use. I can’t guarantee that any modules, packages, or configurations are tested, stable, or maintained
>
> Feel free to explore, adapt, or contribute as you like <3

- Modular flake using [flake-parts](https://github.com/hercules-ci/flake-parts)
- Multi user to multi host
- LUKS & BTRFS using [disko](https://github.com/nix-community/disko)
- Ephemeral root and home with [impermanence](https://github.com/nix-community/impermanence)
- [Home Manager](https://github.com/nix-community/home-manager)
- [Hyprland](https://github.com/hyprwm/Hyprland) with [UWSM](https://github.com/Vladimir-csp/uwsm)
- Package sources tracked using [nvfetcher](https://github.com/berberman/nvfetcher)

## Structure

### `configurations/`

User and host configurations

```
configurations
├── hosts
│   └── <host>
│       ├── default.nix  # host nixos config
│       ├── disko.nix    # disk config
│       └── hardware.nix # hardware config
└── users
    └── <user>
        ├── default.nix  # user nixos config
        └── home
            ├── default.nix       # user home-manager config
            └── <user>@<host>.nix # user@host home-manager config
```

### `modules/`

NixOS and Home Manager modules, which are:

- Standard modules
- Reusable in other contexts
- Exposed by the flake
- Not guaranteed to be tested, stable or maintained

### `dyad/`

NixOS and Home Manager **configuration** modules, which:

- Apply configuration values
- Implement a feature
- Expose a single enable option
- Aren't reusable outside of my usecase

`dyad` modules are bulk imported using [import-tree](https://github.com/vic/import-tree/)

`dyad/*/profiles` contains profile modules that group other dyad modules by use case, e.g. `graphical`, `terminal`, `laptop`

### The rest

- `lib` - helper lambdas
- `packages` - packaged applications exposed by the flake
- `parts` - flake-parts configuration modules
- `patches` - .patch files
- `secrets` - secrets managed by agenix
- `_sources` & `nvfetcher.toml` - package sources tracked by nvfetcher

## Acknowledgements

- [Graham Christensen - Erase your darlings](https://grahamc.com/blog/erase-your-darlings/)
- [Misterio77/nix-starter-configs](https://github.com/Misterio77/nix-starter-configs)
- [fufexan/dotfiles](https://github.com/fufexan/dotfiles)
- [isabelroses/dotfiles](https://github.com/isabelroses/dotfiles)
