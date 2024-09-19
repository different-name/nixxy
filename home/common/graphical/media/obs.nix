{
  lib,
  config,
  ...
}: {
  options.nix-files.graphical.media.obs.enable = lib.mkEnableOption "OBS config";

  config = lib.mkIf config.nix-files.graphical.media.obs.enable {
    programs.obs-studio.enable = true;

    home.persistence."/persist${config.home.homeDirectory}".directories = [
      ".config/obs-studio"
    ];
  };
}
