{ lib, config, ... }:
{
  options.dyad.terminal.distrobox.enable = lib.mkEnableOption "distrobox config";

  config = lib.mkIf config.dyad.terminal.distrobox.enable {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [
          pkgs.distrobox
        ];

        virtualisation.podman.enable = true;
      };

    home-manager.home.perpetual.default.dirs = [
      "$dataHome/containers"
    ];
  };
}
