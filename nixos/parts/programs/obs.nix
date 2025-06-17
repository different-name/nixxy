{
  lib,
  config,
  ...
}: {
  options.nix-files.parts.programs.obs.enable = lib.mkEnableOption "OBS config";

  config = lib.mkIf config.nix-files.parts.programs.obs.enable {
    programs.obs-studio = {
      enable = true;
      enableVirtualCamera = true;
    };
  };
}
