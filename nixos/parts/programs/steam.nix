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

  options.nix-files.parts.programs.steam.enable = lib.mkEnableOption "steam config";

  config = lib.mkIf config.nix-files.parts.programs.steam.enable {
    programs.steam = {
      enable = true;

      extraCompatPackages = with pkgs; [
        proton-ge-bin
        proton-ge-rtsp-bin
      ];
    };

    hardware.steam-hardware.enable = true;
  };
}
