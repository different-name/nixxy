{
  lib,
  config,
  pkgs,
  self,
  ...
}: {
  options.nix-files.graphical.util.blender.enable = lib.mkEnableOption "Blender config";

  config = lib.mkIf config.nix-files.graphical.util.blender.enable {
    home.file = let
      addons = with self.packages.${pkgs.system}; [
        cats-blender-plugin-unofficial
      ];
    in
      addons
      |> map (addon: {
        name = "${config.xdg.configHome}/blender/${addon.blenderInstallPath}";
        value = {
          source = "${addon}/share";
          recursive = true;
        };
      })
      |> lib.listToAttrs;

    home.packages = [pkgs.blender];

    home.persistence."/persist${config.home.homeDirectory}" = lib.mkIf config.nix-files.persistence.enable {
      directories = [
        ".config/blender"
        ".cache/blender"
      ];
    };
  };
}
