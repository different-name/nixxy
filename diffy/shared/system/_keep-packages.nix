{ inputs, format }:
{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) types;

  entryOptions = inputs.keep-nix.lib.entryOptions { inherit lib format; };

  isHome = format == "home-manager";
  cfg = config.keep;

  volume = { config, ... }: {
    options.packages = lib.mkOption {
      type = types.attrsOf (
        types.submodule (
          { name, ... }: {
            options = entryOptions // {
              package = lib.mkOption {
                type = types.package;
                default = pkgs.${name};
                defaultText = lib.literalExpression "pkgs.<name>";
                description = "Package to install alongside its persisted state";
              };
            };
          }
        )
      );
      default = { };
      description = "Packages installed together with the state they need persisted";
    };

    config =
      let
        packages = lib.attrValues config.packages;
      in
      {
        dirs = lib.mkMerge (map (p: p.dirs) packages);
        files = lib.mkMerge (map (p: p.files) packages);
      }
      // lib.optionalAttrs isHome { xdg = lib.mkMerge (map (p: p.xdg) packages); };
  };

  packages = lib.concatMap (v: lib.mapAttrsToList (_: p: p.package) v.packages) (lib.attrValues cfg);
in
{
  options.keep = lib.mkOption { type = types.attrsOf (types.submodule volume); };

  config =
    if isHome then { home.packages = packages; } else { environment.systemPackages = packages; };
}
