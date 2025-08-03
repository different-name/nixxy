{
  description = "Diffy's nix-files";

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        # keep-sorted start
        # manually import all flake modules, since they can't be imported through `self`
        (inputs.import-tree ./modules/flake)
        ./dyad
        ./formatter.nix
        ./hosts
        ./modules
        ./packages
        ./sources
        inputs.home-manager.flakeModules.home-manager
        # keep-sorted end
      ];

      systems = import inputs.systems;
    };

  inputs = {
    # keep-sorted start block=yes newline_separated=yes
    # secrets management
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        # keep-sorted start
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        # keep-sorted end
      };
    };

    # launcher
    anyrun = {
      url = "github:fufexan/anyrun/launch-prefix";
      inputs = {
        # keep-sorted start
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        # keep-sorted end
      };
    };

    # color theme
    # fork with support for userstyles
    catppuccin = {
      url = "github:different-name/catppuccin-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # portable file server
    copyparty = {
      url = "github:9001/copyparty";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # declarative partitioning and formatting
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix flakes framework
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # manages user environment
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hypr community scripts
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
    };

    # hyprland compositor
    hyprland.url = "github:hyprwm/hyprland";

    # hypr session locker
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs = {
        # keep-sorted start
        hyprgraphics.follows = "hyprland/hyprgraphics";
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
        # keep-sorted end
      };
    };

    # hypr wallpaper utility
    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs = {
        # keep-sorted start
        hyprgraphics.follows = "hyprland/hyprgraphics";
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
        # keep-sorted end
      };
    };

    # hypr color picker utility
    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs = {
        # keep-sorted start
        hyprutils.follows = "hyprland/hyprutils";
        hyprwayland-scanner.follows = "hyprland/hyprwayland-scanner";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
        # keep-sorted end
      };
    };

    # manage persistent state
    # TODO switch back to master once merged https://github.com/nix-community/impermanence/pull/272
    impermanence = {
      url = "github:nix-community/impermanence/home-manager-v2";
      inputs = {
        # keep-sorted start
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
        # keep-sorted end
      };
    };

    # import modules recursively
    import-tree.url = "github:vic/import-tree";

    # moonlight discord mod
    moonlight = {
      url = "github:moonlight-mod/moonlight";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixos helper
    nh = {
      url = "github:nix-community/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # weekly updated nix-index database
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # better minecraft server module
    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # vscode extensions
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # collection of image builders
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hardware configurations
    nixos-hardware.url = "github:nixos/nixos-hardware";

    # used for cudaSupport for wivrn flake
    nixpkgs-unfree = {
      url = "github:numtide/nixpkgs-unfree";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix xr/ar/vr packages
    nixpkgs-xr = {
      url = "github:nix-community/nixpkgs-xr";
      inputs = {
        # keep-sorted start
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
        # keep-sorted end
      };
    };

    # nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # nix user repository
    nur = {
      url = "github:nix-community/NUR";
      inputs = {
        # keep-sorted start
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        # keep-sorted end
      };
    };

    # manage steam game launch options and other local config
    steam-config-nix = {
      url = "github:different-name/steam-config-nix";
      inputs = {
        # keep-sorted start
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        # keep-sorted end
      };
    };

    # list of systems
    systems.url = "github:nix-systems/x86_64-linux";

    # formatter module for flake-parts
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "treefmt-nix";
    };

    # slimevr solarxr protocol patches for wivrn
    wivrn-solarxr = {
      url = "github:notpeelz/WiVRn/6e15951add57138243ff3698c1f30517de1d639e";
      inputs = {
        # keep-sorted start
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs-unfree";
        # keep-sorted end
      };
    };
    # keep-sorted end
  };
}
