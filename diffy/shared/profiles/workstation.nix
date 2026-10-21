{ bundleLib, lib, ... }:
bundleLib.mkEnableModule [ "dyad" "profiles" "workstation" ] {
  dyad = lib.mkDefault {
    # keep-sorted start block=yes newline_separated=yes
    hardware.fwupd.enable = true;

    profiles.minimal.enable = true;

    system.networking.enable = true;

    terminal = {
      # keep-sorted start
      claude-code.enable = true;
      dev-state.enable = true;
      extraPackages.enable = true;
      nixpkgs-review.enable = true;
      shellAliases.enable = true;
      television.enable = true;
      zellij.enable = true;
      # keep-sorted end
    };
    # keep-sorted end
  };
}
