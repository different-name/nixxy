{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) types;

  cfg = config.home.perpetual;

  baseOptions =
    lib.genAttrs [ "dirs" "files" ] (
      type:
      lib.mkOption {
        type = types.listOf types.str; # TODO support full config
        default = [ ];
        description = "${lib.toSentenceCase type} to pass to impermanence";
      }
    )
    // {
      enable = lib.mkEnableOption "perpetual";
    };

  xdgHomes = map (type: "${type}Home") [
    # keep-sorted start
    "cache"
    "config"
    "data"
    "state"
    # keep-sorted end
  ];

  xdgHomePaths = map (lib.removePrefix "${config.home.homeDirectory}/") (
    lib.attrVals xdgHomes config.xdg
  );
  xdgHomeVars = map (home: "\$${home}") xdgHomes;

  replaceXdgVars = lib.replaceStrings xdgHomeVars xdgHomePaths;
in
{
  options.home.perpetual = lib.mkOption {
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
                        description = "Package to install via home.packages";
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
    home.persistence = lib.mapAttrs (
      _: persistCfg:
      lib.mkIf persistCfg.enable {
        files = map replaceXdgVars persistCfg.files;
        directories = map replaceXdgVars persistCfg.dirs;
      }
    ) cfg;

    home.packages = lib.flatten (
      lib.mapAttrsToList (_: c: lib.mapAttrsToList (_: p: p.package) c.packages) cfg
    );
  };
}
