{
  flake = {
    flakeModules = {
      # keep-sorted start
      hosts = import ./flake/hosts.nix;
      sources = import ./flake/sources.nix;
      # keep-sorted end
    };

    homeModules = {
      # keep-sorted start
      blender = ./home/blender.nix;
      disblockOrigin = ./home/disblock-origin.nix;
      perpetual = ./home/perpetual.nix;
      xdgDesktopPortalHyprland = ./home/xdg-desktop-portal-hyprland.nix;
      # keep-sorted end
    };

    nixosModules = {
      # keep-sorted start
      epht = ./nixos/epht;
      perpetual = ./nixos/perpetual.nix;
      tty1Autologin = ./nixos/tty1-autologin.nix;
      wireplumberScripts = ./nixos/wireplumber-scripts;
      # keep-sorted end
    };
  };
}
