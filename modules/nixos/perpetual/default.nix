{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) types;

  cfg = config.environment.perpetual;

  baseOptions = lib.genAttrs [ "dirs" "files" ] (
    type:
    lib.mkOption {
      type = types.listOf types.anything; # leave typing to impermanence
      default = [ ];
      description = "${lib.toSentenceCase type} to pass to impermanence";
    }
  );
in
{
  options.environment.perpetual = lib.mkOption {
    type = types.attrsOf (
      types.submodule (
        { config, ... }:
        {
          options = baseOptions // {
            packages = lib.mkOption {
              type = types.attrsOf (
                types.submodule (
                  { name, ... }:
                  {
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
              packageStoragePaths = builtins.zipAttrsWith (_: v: lib.flatten v) (lib.attrValues config.packages);
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

  config = {
    environment.persistence = lib.mapAttrs (_: persistCfg: {
      inherit (persistCfg) files;
      directories = persistCfg.dirs;
    }) cfg;

    environment.systemPackages = lib.flatten (
      lib.mapAttrsToList (_: c: lib.mapAttrsToList (_: p: p.package) c.packages) cfg
    );
  };
}
