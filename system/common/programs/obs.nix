{
  lib,
  config,
  ...
}: {
  options.nix-files.programs.obs.enable = lib.mkEnableOption "OBS config";

  config = lib.mkIf config.nix-files.programs.obs.enable {
    programs.obs-studio = {
      enable = true;
      enableVirtualCamera = true;
    };
  };
}
