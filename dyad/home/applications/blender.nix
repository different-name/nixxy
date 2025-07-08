{
  lib,
  config,
  self,
  self',
  ...
}:
{
  imports = [
    self.homeModules.blender
  ];

  options.dyad.applications.blender.enable = lib.mkEnableOption "blender config";

  config = lib.mkIf config.dyad.applications.blender.enable {
    programs.blender = {
      enable = true;
      addons = with self'.packages; [
        cats-blender-plugin-unofficial
      ];
    };

    home.persistence-wrapper.dirs = [
      # keep-sorted start
      ".cache/blender"
      ".config/blender"
      # keep-sorted end
    ];
  };
}
