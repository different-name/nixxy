# <img src="https://raw.githubusercontent.com/Different-Name/nix-files/master/assets/nixoscolorful.svg" height=26> nix-files

My NixOS configuration files

> [!WARNING]
> This flake is tailored for my personal setup and is under active development. I can’t guarantee that any modules, packages, or configurations are tested, stable, or maintained
> 
> Feel free to explore, adapt, or contribute as you like <3

- **Flake-based** NixOS configuration
- **Multi-host** and **multi-user**
- **Modular structure**, everything imported by [import-tree](https://github.com/vic/import-tree)
- **Declarative disk layout** with [disko](https://github.com/nix-community/disko) (**btrfs** + **LUKS**)
- **Ephemeral root and home** via [impermanence](https://github.com/nix-community/impermanence)
- **Declarative user environments** using [home-manager](https://github.com/nix-community/home-manager)
- **Hyprland-based** graphical session
- Package versions **tracked** with [nvfetcher](https://github.com/berberman/nvfetcher)

## Modules modules modules

Instead of choosing functionality through importing files, this flake utilizes **parts** - small, focused, reusable configuration files

These are:

- **Always imported**
- **toggleable** through `enable` options
- **Grouped logically** (e.g. `desktop`, `system`, `terminal`)

Common combinations of options are abstracted into **profiles**, which are preconfigured option sets that represent **high level** applications such as `graphical` or `laptop`

Users are defined as modules too, allowing complete user configurations to be enabled and disabled per host

With these abstractions, host files are declarative configurations that compose systems by toggling `users`, `profiles`, and `parts`

This enables:

- **Modularity** and reusability
- **Composition** from well-scoped building blocks
- **Deduplication** of configuration across hosts and users

### Option paths mirror file paths

In this flake, option paths directly mirror the directory structure:

- `nixos/` is the root for the system-level (NixOS) `nix-files` options
- `home/` is the root for the user-level (home-manager) `nix-files` options

For example, the system option:

```nix
nix-files.parts.system.hyprland.enable = true;
```

Is defined in:

```
nixos/parts/system/hyprland
```

## Special files

Files prefixed with `_` are ignored by `import-tree` and are imported manually instead

This prefix is reserved for Nix files that cannot be structured as modules because they are either:

- **Auto-generated**, such as `_hardware-configuration.nix`, or
- **Required in a fixed format** by external tools such as [disko](https://github.com/nix-community/disko) - e.g. `_disk-configuration.nix`

These special files are typically imported by a `default.nix` file in the same directory

The sole exception is `_special-imports.nix` in `nixos/hosts/<host>`, which is explicitly imported by `configurations.nix`. It is reserved for importing modules that cannot be configured, such as those in `nixos-hardware`

## Structure

### `configurations.nix`

NixOS configurations are defined in this file

Each NixOS configuration uses `import-tree` to import all modular files in the `nixos` directory, and activates a specific host module defined in `nixos/hosts/<host>` by setting:

```nix
nix-files.host = "hostname";
```

### `nixos/`

System-level modules for NixOS, imported by `configurations.nix` using `import-tree`

NixOS modules are organised as:

```
nixos
├── parts       # Reusable config files
├── profiles    # High-level presets for system roles
├── users       # System user definitions and settings
└── hosts       # Top-level host configurations
```

- Hosts and users are configured independently
- A user can be shared across multiple systems
- Hosts define which users are present, but don't embed user config

> *Each system defines which users it has, but users can share common configuration across systems*

### `home/`

home-manager modules for user environments, imported by `nixos/users/<user>` using `import-tree`

home-manager modules are organized **user first**:

```
home
├── parts           # Reusable config files
├── profiles        # High-level presets for system roles
└── users           # A user's home config, shared between hosts
    └── <user>
        └── hosts   # A user's home config, for a specific host
```

- Each user defines their base config
- Hosts are configured in the context of a specific user
- Configuration is shared across machines on a per-user basis

> *Each user defines their own home environment, which adapts depending on the machine they're on*

## Acknowledgements

- [Graham Christensen - Erase your darlings](https://grahamc.com/blog/erase-your-darlings/)
- [Misterio77/nix-starter-configs](https://github.com/Misterio77/nix-starter-configs)
- [fufexan/dotfiles](https://github.com/fufexan/dotfiles)