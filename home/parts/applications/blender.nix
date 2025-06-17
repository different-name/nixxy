{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  options.nix-files.parts.applications.blender.enable = lib.mkEnableOption "Blender config";

  config = lib.mkIf config.nix-files.parts.applications.blender.enable {
    home.file =
      let
        addons = with inputs.self.packages.${pkgs.system}; [
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

    home.packages = [ pkgs.blender ];

    nix-files.parts.system.persistence = {
      directories = [
        ".config/blender"
        ".cache/blender"
      ];
    };
  };
}
