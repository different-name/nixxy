{
  lib,
  config,
  self,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    self.nixosModules.steam-launch-options
    inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
  ];

  options.nix-files.programs.steam.enable = lib.mkEnableOption "Steam config";

  config = lib.mkIf config.nix-files.programs.steam.enable {
    programs.steam = {
      enable = true;

      extraCompatPackages = with pkgs; [
        proton-ge-bin
        proton-ge-rtsp-bin
      ];

      launchOptions.enable = true;
    };

    hardware.steam-hardware.enable = true;
  };
}
