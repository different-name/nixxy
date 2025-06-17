{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.self.nixosModules.steam-launch-options
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

      launchOptions = {
        enable = true;

        games = {
          # workaround for vrchat using incorrect timezone
          VRChat.unsetVariables = [ "TZ" ];
        };
      };
    };

    hardware.steam-hardware.enable = true;
  };
}
