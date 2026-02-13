{ lib, inputs, ... }:
let
  inherit (lib) types;

  getInput = name: inputs.${name} or (throw "No ${name} input found");

  nixpkgs = getInput "nixpkgs";
  nix-darwin = getInput "nix-darwin";
  home-manager = inputs.home-manager or (throw "No home-manager input found");
  hjem = inputs.hjem or (throw "No hjem input found");
in
{
  options.nixxy = {
    systemClasses = lib.mkOption {
      type = types.attrsOf (
        types.submodule (
          { name, ... }:
          {
            options = {
              namespace = lib.mkOption {
                type = types.str;
                default = name;
                # TODO documentation
              };

              flakeAttribute = lib.mkOption {
                type = types.str;
                # TODO documentation
              };

              mkSystem = lib.mkOption {
                type = types.raw;
                # TODO documentation
              };
            };
          }
        )
      );
      default = { };
      # TODO documentation
    };

    homeClasses = lib.mkOption {
      type = types.attrsOf (
        types.submodule (
          { name, config, ... }:
          {
            options = {
              namespace = lib.mkOption {
                type = types.str;
                default = name;
                # TODO documentation
              };

              attrPath = lib.mkOption {
                type = types.listOf types.str;
                # TODO documentation
              };

              systemClasses = lib.mkOption {
                type = types.attrsOf (
                  types.submodule {
                    options = {
                      module = lib.mkOption {
                        type = types.deferredModule;
                        # TODO documentation
                      };

                      attrPath = lib.mkOption {
                        type = types.listOf types.str;
                        default = config.attrPath;
                        # TODO documentation
                      };
                    };
                  }
                );
                # TODO documentation
              };
            };
          }
        )
      );
      default = { };
      # TODO documentation
    };
  };

  config.nixxy = {
    systemClasses = {
      nixos = {
        mkSystem = nixpkgs.lib.nixosSystem;
        flakeAttribute = "nixosConfigurations";
      };

      darwin = {
        mkSystem = nix-darwin.lib.darwinSystem;
        flakeAttribute = "darwinConfigurations";
      };
    };

    homeClasses = {
      home-manager = {
        namespace = "hm";

        attrPath = [
          "home-manager"
          "users"
        ];

        systemClasses = {
          nixos.module = home-manager.nixosModules.default;
          darwin.module = home-manager.darwinModules.default;
        };
      };

      hjem = {
        attrPath = [
          "hjem"
          "users"
        ];

        systemClasses = {
          nixos.module = hjem.nixosModules.default;
          darwin.module = hjem.darwinModules.default;
        };
      };
    };
  };
}
