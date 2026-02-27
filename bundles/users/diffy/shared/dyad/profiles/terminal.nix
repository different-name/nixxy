{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "profiles" "terminal" ] {
  dyad = {
    # keep-sorted start block=yes newline_separated=yes
    services.tailscale.enable = true;

    style.catppuccin.enable = true;

    terminal = {
      # keep-sorted start
      btop.enable = true;
      fish.enable = true;
      git.enable = true;
      shellAliases.enable = true;
      television.enable = true;
      terminal-pkgs.enable = true;
      zellij.enable = true;
      # keep-sorted end
    };
    # keep-sorted end
  };

  nixos.programs.mosh.enable = true;

  home-manager.programs.fd.enable = true;
}
