{
  bundleLib,
  self,
  self',
  ...
}:
bundleLib.mkEnableModule [ "dyad" "applications" "blender" ] {
  home-manager = {
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
}
