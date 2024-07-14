{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin

    ../. # home
    ./persistence.nix

    ./programs/wayland/hyprland
    ./programs/wayland/waybar.nix
    ./programs/wayland/rofi.nix
    ./programs/wayland/hyprlock.nix
    ./programs/catppuccin.nix
    ./programs/gtk.nix
    ./programs/codium.nix

    ./terminal/kitty.nix
    ./terminal/git.nix

    ./services/network-manager-applet.nix
    ./services/mako.nix
    ./services/hyprpaper.nix
  ];

  home = {
    username = "different";
    homeDirectory = "/home/different";

    packages = with pkgs; [
    # programs
    vesktop
    brave
    pavucontrol
    slack
    gnome.gnome-calculator
    networkmanagerapplet
    mpv
    imv
    gimp-with-plugins
    unityhub
      libreoffice-qt6-fresh
    # (prismlauncher.override {
    #   jdks = [
    #     zulu17
    #     zulu21
    #   ];
    # })

    # terminal
    imagemagick
    ani-cli
    playerctl
    trashy
    btop
    ncdu

    # services
    libnotify
  ];

    # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.05";
  };
}
