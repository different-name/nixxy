{
  lib,
  config,
  ...
}:
{
  options.dyad.applications.librewolf.enable = lib.mkEnableOption "librewolf config";

  config = lib.mkIf config.dyad.applications.librewolf.enable {
    programs.librewolf = {
      enable = true;
      profiles = {
        default = {
          id = 0;
          name = "default";
          isDefault = true;
        };
      };
    };

    xdg.mimeApps.defaultApplications = {
      "application/pdf" = "librewolf.desktop";
    };

    home.perpetual.default.dirs = [
      "$cacheHome/librewolf"
      ".librewolf"
    ];
  };
}
