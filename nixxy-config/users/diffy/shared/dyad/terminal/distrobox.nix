{ lib, config, ... }:
{
  options.dyad.programs.distrobox.enable = lib.mkEnableOption "distrobox config";

  config = lib.mkIf config.dyad.programs.distrobox.enable {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [
          pkgs.distrobox
        ];

        virtualisation.podman.enable = true;
      };

    hm.home.perpetual.default.dirs = [
      "$dataHome/containers"
    ];
  };
}
