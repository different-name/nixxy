{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "profiles" "terminal" ] {
  dyad = {
    # keep-sorted start block=yes newline_separated=yes
    style.catppuccin.enable = true;

    terminal = {
      # keep-sorted start
      btop.enable = true;
      extraPackages.enable = true;
      git.enable = true;
      nixpkgs-review.enable = true;
      nushell.enable = true;
      shellAliases.enable = true;
      television.enable = true;
      zellij.enable = true;
      # keep-sorted end
    };
    # keep-sorted end
  };

  nixos.programs.mosh.enable = true;

  home-manager.programs.fd.enable = true;
}
