{
  lib,
  config,
  self,
  self',
  ...
}:
{
  options.dyad.applications.blender.enable = lib.mkEnableOption "blender config";

  config = lib.mkIf config.dyad.applications.blender.enable {
    hm = {
      imports = [
        self.homeModules.blender
      ];

      config = {
        programs.blender = {
          enable = true;
          addons = with self'.packages; [
            cats-blender-plugin-unofficial
          ];
        };

        home.perpetual.default.dirs = [
          "$cacheHome/blender"
          "$configHome/blender"
        ];
      };
    };
  };
}
