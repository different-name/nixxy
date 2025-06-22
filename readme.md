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

## Module structure

Every configuration file in this flake is a **module**. This allows the entire `nixos/` and `home/` directories to be imported using `import-tree`, and for configuration to be toggled, instead of imported

With a lot of modules, organization is important. Typically configuration files are organized in one of two ways:

- **By use-case** (e.g. `core`, `graphical`, `laptop`, `server`, `extra`), easy to import logical groups of configuration files, however forces every configuration to fit into a single rigid category, which can be awkward
- **By function** (e.g. `hardware`, `programs`, `services`), mirrors the structure of NixOS options (e.g. `programs.fish`, `services.openssh`), making it clean and intuitive, but harder to import sets of related modules

Rather than picking a single approach, this flake uses two types of modules - **`parts`** and **`profiles`** - to get the best of both

### Parts

`parts` are the most granular modules, they:

- Configure NixOS / home-manager options
- Are toggleable & disabled by default
- Implement a single function

Because `parts` are focused on a specific function, they are organized by function, not use-case. This avoids common issues like:

- Modules that don't clearly belong to a single use-case
- Multi-purpose modules being forced into one category

### Profiles

`Profiles` can be thought of as "import sets", they are high level modules that:

- Do not deal with lower level configuration
- Enables various `parts`
- Creates use-case based option sets

For example, a `graphical` profile could enable the `hyprland`, `uwsm` & `xdg` `parts`, but does not configure any of those modules directly

Through this approach, a single `part` can appear in multiple profiles, or none

### Option paths

In this flake, configuration options are namespaced under `nix-files.*`

Because `parts` follow a function based directory structure, all options paths can cleanly match the file paths, for example:

```
nixos
├── parts
│   ├── hardware
│   │   └── nvidia.nix
│   └── services
│       └── openssh.nix
└── profiles
    └── graphical.nix
```

```nix
nix-files = {
    parts = {
        hardware.nvidia.enable = true;
        services.openssh.enable = true;
    };
    profiles.graphical.enable = true;
};
```

## Excluded files

### Manual imports

Some files shouldn't be imported automatically by `import-tree`. This includes files that are auto-generated, required in a fixed format, or are directly imported as part of another expression. For example:

- [`_moonlight-config.nix`](https://github.com/different-name/nix-files/blob/fa7434ff3bf07b2e5062f904f8fc89f8db8afcfa/home/parts/applications/discord/_moonlight-config.nix) is auto-generated moonlight configuration imported directly by [`discord/default.nix`](https://github.com/different-name/nix-files/blob/fa7434ff3bf07b2e5062f904f8fc89f8db8afcfa/home/parts/applications/discord/default.nix#L22) so it is not a configuration module and shouldn't be imported by `import-tree`
- [`_disk-configuration.nix`](https://github.com/different-name/nix-files/blob/fa7434ff3bf07b2e5062f904f8fc89f8db8afcfa/nixos/hosts/sodium/_disk-configuration.nixhttps://github.com/different-name/nix-files/blob/fa7434ff3bf07b2e5062f904f8fc89f8db8afcfa/nixos/hosts/sodium/_disk-configuration.nix) is required in a specific layout by the `disko` command, and so cannot be structured as a module

Any manually imported files like these are prefixed with `_`, which causes `import-tree` to ignore them

### Special imports

`_special-imports.nix`, located in `nixos/hosts/<host>`, is a special file that imported exclusively by `configurations.nix` for the host it belongs to

This is used for modules that both:

- Cannot be imported by `import-tree` as they lack enable options
- Cannot be manually imported as they define options

For example:

- Modules from [`nixos-hardware`](https://github.com/NixOS/nixos-hardware), which lack enable options and define options of their own
- [`_hardware-configuration.nix`](https://github.com/different-name/nix-files/blob/fa7434ff3bf07b2e5062f904f8fc89f8db8afcfa/nixos/hosts/sodium/_hardware-configuration.nix) which lacks an enable option and contains an `imports` field. Handling `imports` manually would require a partial reimplementation of [`lib.modules.evalModules`](https://github.com/hsjobeki/nixpkgs/blob/f0efec9cacfa9aef98a3c70fda2753b9825e262f/lib/modules.nix#L84)

## Layout

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

Each system defines which users it has, but users can share common configuration across systems

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

Each user defines their own home environment, which adapts depending on the machine they're on

## Acknowledgements

- [Graham Christensen - Erase your darlings](https://grahamc.com/blog/erase-your-darlings/)
- [Misterio77/nix-starter-configs](https://github.com/Misterio77/nix-starter-configs)
- [fufexan/dotfiles](https://github.com/fufexan/dotfiles)