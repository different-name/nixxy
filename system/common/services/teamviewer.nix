{
  lib,
  config,
  ...
}: {
  options.nix-files.services.teamviewer.enable = lib.mkEnableOption "TeamViewer config";

  config = lib.mkIf config.nix-files.services.teamviewer.enable {
    services.teamviewer.enable = true;
  };
}
