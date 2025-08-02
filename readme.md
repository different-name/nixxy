# <img src="https://raw.githubusercontent.com/different-name/nix-files/master/assets/nixoscolorful.svg" height="26px" style="height: 26px;"> nix-files

My NixOS configuration files

> [!IMPORTANT]
> This repo is my personal nixos configuration and is only intended for my use. I can’t guarantee that any modules, packages, or configurations are tested, stable, or maintained
>
> Feel free to explore, adapt, or contribute as you like <3

- Modular flake using [flake-parts](https://github.com/hercules-ci/flake-parts)
- Multi user to multi host
- LUKS & BTRFS using [disko](https://github.com/nix-community/disko)
- Ephemeral root and home with [impermanence](https://github.com/nix-community/impermanence)
- [Home Manager](https://github.com/nix-community/home-manager)
- [Hyprland](https://github.com/hyprwm/Hyprland) with [UWSM](https://github.com/Vladimir-csp/uwsm)
- Secrets managed by [agenix](https://github.com/ryantm/agenix)
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

A set of configuration modules namespaced under `dyad` which:

- Are specific to my usecase
- Wrap features in enable options
- Implement a features through simple configuration
- Don't implement extra options or complex logic

`dyad` also provides profile modules that wrap feature enable options together by use case, e.g. `graphical`, `terminal`, `minimal`

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
