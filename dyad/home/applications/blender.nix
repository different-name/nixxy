{
  lib,
  config,
  pkgs,
  self',
  ...
}:
{
  options.dyad.applications.blender.enable = lib.mkEnableOption "blender config";

  config = lib.mkIf config.dyad.applications.blender.enable {
    home.file =
      let
        addons = with self'.packages; [
          cats-blender-plugin-unofficial
        ];
      in
      addons
      |> map (addon: {
        name = "${config.xdg.configHome}/blender/${addon.blenderInstallPath}";
        value = {
          source = addon + /share;
          recursive = true;
        };
      })
      |> lib.listToAttrs;

    home.packages = [ pkgs.blender ];

    dyad.system.persistence = {
      directories = [
        ".config/blender"
        ".cache/blender"
      ];
    };
  };
}
