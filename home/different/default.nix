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
    ./terminal/fd.nix
    ./terminal/git.nix

    ./services/network-manager-applet.nix
    ./services/mako.nix
    ./services/hyprpaper.nix
  ];

  home.packages = with pkgs; [
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

  home = {
    username = "different";
    homeDirectory = "/home/different";
  };

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
