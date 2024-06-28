{inputs, pkgs, ...}: {
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin

    ../. # home
    ./persistence.nix

    ./programs/hyprland.nix
    ./programs/librewolf.nix
    ./programs/codium.nix
    ./programs/catppuccin.nix
    ./programs/waybar.nix
    ./programs/rofi.nix

    ./terminal/kitty.nix
    ./terminal/fd.nix
    ./terminal/git.nix

    ./services/network-manager-applet.nix
    ./services/mako.nix
  ];

  home.packages = with pkgs; [
    libnotify
    swww
    networkmanagerapplet
    imagemagick
    ani-cli
    vesktop
  ];

  home = {
    username = "different";
    homeDirectory = "/home/different";
  };

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}