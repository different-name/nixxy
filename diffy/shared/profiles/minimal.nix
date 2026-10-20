{ bundleLib, lib, ... }:
bundleLib.mkEnableModule [ "dyad" "profiles" "minimal" ] {
  dyad = lib.mkDefault {
    # keep-sorted start block=yes newline_separated=yes
    hardware.fwupd.enable = true;

    nix = {
      # keep-sorted start
      nix.enable = true;
      patches.enable = true;
      substituters.enable = true;
      # keep-sorted end
    };

    services.openssh.enable = true;

    system = {
      # keep-sorted start
      boot.enable = true;
      locale.enable = true;
      networking.enable = true;
      security.enable = true;
      # keep-sorted end
    };

    terminal = {
      nh.enable = true;
      nushell.enable = true;
    };
    # keep-sorted end
  };
}
