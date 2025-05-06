{
  lib,
  config,
  pkgs,
  ...
}: {
  options.nix-files.programs.steam.enable = lib.mkEnableOption "Steam config";

  config = lib.mkIf config.nix-files.programs.steam.enable {
    nixpkgs.overlays = [
      # proton ge with rtsp patch, for vrchat video players
      # credit: https://github.com/PassiveLemon/lemonake/blob/2902889d1ac94721d262eae34cbcd8bfe82f009b/pkgs/proton-ge-rtsp/default.nix#L3-L10
      (final: prev: {
        proton-ge-rtsp = let
          version = "GE-Proton9-22-rtsp17";
        in
          (prev.proton-ge-bin.overrideAttrs {
            pname = "proton-ge-rtsp-bin";
            inherit version;
            src = pkgs.fetchzip {
              url = "https://github.com/SpookySkeletons/proton-ge-rtsp/releases/download/${version}/${version}.tar.gz";
              hash = "sha256-1zj0y7E9JWrnPC9HllFXos33rsdAt3q+NamoxNTmHHM=";
            };
          }).override {steamDisplayName = "GE-Proton-rtsp";};
      })
    ];

    programs.steam = {
      enable = true;

      extraCompatPackages = with pkgs; [
        proton-ge-bin
        proton-ge-rtsp
      ];
    };

    hardware.steam-hardware.enable = true;
  };
}
