{pkgs, ...}: {
  # steam will fail on first install, with the error message
  # "Fatal Error: Failed to load steamui.so" relaunching appears
  # to fix the issue and steam will continue where it left off
  programs.steam = {
    enable = true;

    extraCompatPackages = with pkgs; [
      # add proton ge
      proton-ge-bin
      # proton ge with rtsp patch, for vrchat video players
      (proton-ge-bin.overrideAttrs (finalAttrs: {
        pname = "proton-ge-rtsp-bin";
        version = "GE-Proton9-10-rtsp14";
        src = pkgs.fetchzip {
          url = "https://github.com/SpookySkeletons/proton-ge-rtsp/releases/download/GE-Proton9-10-rtsp14/GE-Proton9-10-rtsp14.tar.gz";
          hash = "sha256-4Ii2vnnQcoAxjYrDl0gDhllVqfUOsZxkEMIsxSwgdN8=";
        };
      }))
    ];
  };
}
