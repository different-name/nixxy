{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
  ];

  options.dyad.programs.steam.enable = lib.mkEnableOption "steam config";

  config = lib.mkIf config.dyad.programs.steam.enable {
    programs.steam = {
      enable = true;

      extraCompatPackages = with pkgs; [
        # keep-sorted start
        proton-ge-bin
        proton-ge-rtsp-bin
        # keep-sorted end
      ];
    };

    hardware.steam-hardware.enable = true;
  };
}
