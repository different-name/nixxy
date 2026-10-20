{
  lib,
  config,
  options,
  pkgs,
  ...
}:
let
  inherit (lib) types;

  cfg = config.environment.perpetual;

  baseOptions =
    lib.genAttrs [ "dirs" "files" ] (
      type:
      lib.mkOption {
        type = types.listOf types.anything; # leave typing to impermanence
        default = [ ];
        description = "${lib.toSentenceCase type} to pass to impermanence";
      }
    )
    // {
      enable = lib.mkEnableOption "perpetual";
    };
in
{
  options.environment.perpetual = lib.mkOption {
    description = "Named persistence stores, each mapped to an impermanence store of the same name";
    type = types.attrsOf (
      types.submodule (
        { config, ... }: {
          options = baseOptions // {
            packages = lib.mkOption {
              description = "Packages to install together with the state paths they need persisted";
              type = types.attrsOf (
                types.submodule (
                  { name, ... }: {
                    options = baseOptions // {
                      package = lib.mkOption {
                        type = types.package;
                        default = pkgs.${name};
                        description = "Package to install via environment.systemPackages";
                      };
                    };
                  }
                )
              );
              default = { };
            };
          };

          config =
            let
              packageStoragePaths = lib.zipAttrsWith (_: v: lib.flatten v) (lib.attrValues config.packages);
            in
            {
              dirs = packageStoragePaths.dirs or [ ];
              files = packageStoragePaths.files or [ ];
            };
        }
      )
    );
    default = { };
  };

  config = lib.mkMerge [
    {
      environment.systemPackages = lib.flatten (
        lib.mapAttrsToList (_: c: lib.mapAttrsToList (_: p: p.package) c.packages) cfg
      );
    }
    (lib.optionalAttrs (options.environment ? persistence) {
      environment.persistence = lib.mapAttrs (
        _: persistCfg:
        lib.mkIf persistCfg.enable {
          inherit (persistCfg) files;
          directories = persistCfg.dirs;
        }
      ) cfg;
    })
  ];
}
