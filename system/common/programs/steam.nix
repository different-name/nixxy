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
          version = "GE-Proton9-22-rtsp17";
        in {
          pname = "proton-ge-rtsp-bin";
          inherit version;
          src = pkgs.fetchzip {
            url = "https://github.com/SpookySkeletons/proton-ge-rtsp/releases/download/${version}/${version}.tar.gz";
            hash = "sha256-1zj0y7E9JWrnPC9HllFXos33rsdAt3q+NamoxNTmHHM=";
          };
        }))
      ];
    };

    hardware.steam-hardware.enable = true;
  };
}
