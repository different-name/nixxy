{
  description = "diffy's nixos configuration files";

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./bundle.nix
        ./checks.nix
        ./formatter.nix
        ./modules
        ./pkgs
      ];

      systems = import inputs.systems;
    };

  nixConfig = {
    trusted-substituters = [
      "https://cache.nixos.org?priority=10"

      "https://nix-community.cachix.org"
      "https://cache.nixos-cuda.org"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="

      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
    ];
  };

  inputs = {
    # keep-sorted start block=yes newline_separated=yes
    # secrets management
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # firefox user.js for privacy & security
    betterfox = {
      url = "github:HeitorAugustoLN/betterfox-nix";
      inputs = {
        flake-parts.follows = "flake-parts";
        import-tree.follows = "import-tree";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    # bundle nixos, darwin, home-manager, and other config together
    bundle.url = "github:different-name/bundle-of-nix";

    # color theme
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # assorted diffy slop
    diffys-attic = {
      url = "github:different-name/diffys-attic?dir=bone";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # discord ad blocker theme
    disblock-origin = {
      url = "git+https://git.allpurposem.at/mat/Disblock-Origin.git";
      flake = false;
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

    # import modules recursively
    import-tree.url = "github:vic/import-tree";

    # persisted state on the ephemeral root
    keep-nix = {
      url = "github:different-name/keep-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        home-manager.follows = "home-manager";
      };
    };

    # weekly updated nix-index database
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # vscode extensions
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hardware configurations
    nixos-hardware = {
      url = "github:nixos/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # extra xr packages
    nixpkgs-xr = {
      url = "github:nix-community/nixpkgs-xr";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        treefmt-nix.follows = "treefmt-nix";
      };
    };

    # nixpkgs!
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # nix user repository
    nur = {
      url = "github:nix-community/NUR";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };

    # cli tool for interacting with slimevr server
    solarxr-cli = {
      url = "git+https://github.com/notpeelz/solarxr-cli?submodules=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    # spotify modifications
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    # dwm-like workspaces across monitors, used as a lua library
    split-monitor-workspaces = {
      url = "github:zjeffer/split-monitor-workspaces/release/0.56.x";
      flake = false;
    };

    # manage steam game launch options and other local config
    steam-config-nix = {
      url = "github:different-name/steam-config-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        flake-parts.follows = "flake-parts";
      };
    };

    # list of systems
    systems.url = "github:nix-systems/x86_64-linux";

    # formatter module for flake-parts
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # launcher
    vicinae = {
      url = "github:vicinaehq/vicinae";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    # launcher extensions
    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        vicinae.follows = "vicinae";
      };
    };

    # resolve vrchat's video urls, remuxing youtube for its players
    vrchat-video-resolver = {
      url = "github:different-name/vrchat-video-resolver";
      inputs = {
        flake-parts.follows = "flake-parts";
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
        steam-config-nix.follows = "steam-config-nix";
        systems.follows = "systems";
      };
    };

    # convenience lib for creating wrappers
    wrappers = {
      url = "github:lassulus/wrappers";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # keep-sorted end
  };
}
