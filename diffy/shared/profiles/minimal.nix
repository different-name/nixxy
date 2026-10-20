{ bundleLib, lib, ... }:
bundleLib.mkEnableModule [ "dyad" "profiles" "minimal" ] {
  dyad = lib.mkDefault {
    # keep-sorted start block=yes newline_separated=yes
    nix = {
      # keep-sorted start
      nix.enable = true;
      patches.enable = true;
      substituters.enable = true;
      # keep-sorted end
    };

    services = {
      openssh.enable = true;
      tailscale.enable = true;
    };

    style.catppuccin.enable = true;

    system = {
      # keep-sorted start
      boot.enable = true;
      locale.enable = true;
      security.enable = true;
      # keep-sorted end
    };

    terminal = {
      # keep-sorted start
      btop.enable = true;
      git.enable = true;
      nh.enable = true;
      nushell.enable = true;
      # keep-sorted end
    };
    # keep-sorted end
  };

  nixos.programs.mosh.enable = true;

  home-manager.programs.fd.enable = true;
}
