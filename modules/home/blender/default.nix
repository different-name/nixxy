{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) types;
  cfg = config.programs.blender;
in
{
  options.programs.blender = {
    enable = lib.mkEnableOption "Blender";
    package = lib.mkPackageOption pkgs "blender" { nullable = true; };

    addons = lib.mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Addon packages to be installed";
      example = lib.literalExample ''
        with inputs.nix-files.packages; [
          cats-blender-plugin-unofficial
        ]
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.file =
      cfg.addons
      |> map (addon: {
        name = "${config.xdg.configHome}/blender/${addon.blenderInstallPath}";
        value = {
          source = addon + /share;
          recursive = true;
        };
      })
      |> lib.listToAttrs;

    home.packages = lib.mkIf (cfg.package != null) [ pkgs.blender ];
  };
}
