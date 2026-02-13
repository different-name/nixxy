{
  lib,
  config,
  inputs',
  ...
}:
{
  options.dyad.programs.steam.enable = lib.mkEnableOption "steam config";

  config = lib.mkIf config.dyad.programs.steam.enable {
    nixos =
      { pkgs, ... }:
      {
        programs.steam = {
          enable = true;

          gamescopeSession.enable = true;
          protontricks.enable = true;

          extraCompatPackages = with pkgs; [
            inputs'.nixpkgs-xr.packages.proton-ge-rtsp-bin
            proton-ge-bin
          ];
        };

        programs.gamescope = {
          enable = true;
          capSysNice = false;
        };

        environment.systemPackages = [
          pkgs.gamescope-wsi # gamescope hdr support
        ];

        hardware.steam-hardware.enable = true;
      };
  };
}
