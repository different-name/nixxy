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
        # add proton ge
        proton-ge-bin
        # proton ge with rtsp patch, for vrchat video players
        (proton-ge-bin.overrideAttrs (finalAttrs: {
          pname = "proton-ge-rtsp-bin";
          version = "GE-Proton9-10-rtsp15";
          src = pkgs.fetchzip {
            url = "https://github.com/SpookySkeletons/proton-ge-rtsp/releases/download/GE-Proton9-10-rtsp15/GE-Proton9-10-rtsp15.tar.gz";
            hash = "sha256-4Ii2vnnQcoAxjYrDl0gDhllVqfUOsZxkEMIsxSwgdN8=";
          };
        }))
      ];
    };
  };
}
