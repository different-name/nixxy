{
  lib,
  config,
  pkgs,
  ...
}: {
  options.nix-files.programs.steam.enable = lib.mkEnableOption "Steam config";

  config = lib.mkIf config.nix-files.programs.steam.enable {
    programs.steam = {
      enable = true;

      extraCompatPackages = with pkgs; [
        proton-ge-bin

        # proton ge with rtsp patch, for vrchat video players
        (proton-ge-bin.overrideAttrs (finalAttrs: let
          version = "GE-Proton9-22-rtsp17-1";
        in {
          pname = "proton-ge-rtsp-bin";
          inherit version;
          src = pkgs.fetchzip {
            url = "https://github.com/SpookySkeletons/proton-ge-rtsp/releases/download/${version}/${version}.tar.gz";
            hash = "sha256-GeExWNW0J3Nfq5rcBGiG2BNEmBg0s6bavF68QqJfuX8=";
          };
        }))
      ];
    };

    hardware.steam-hardware.enable = true;
  };
}
