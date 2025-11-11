{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.dyad.programs.distrobox.enable = lib.mkEnableOption "distrobox config";

  config = lib.mkIf config.dyad.programs.distrobox.enable {
    environment.systemPackages = [
      pkgs.distrobox
    ];

    virtualisation.podman.enable = true;

    home-manager.sharedModules = lib.singleton {
      home.perpetual.default.dirs = [
        "$dataHome/containers"
      ];
    };
  };
}
