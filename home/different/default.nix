{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin

    ../. # home
    ./persistence.nix

    ./programs/plasma
    ./programs/catppuccin.nix
    ./programs/gtk.nix
    ./programs/codium.nix
    ./programs/qt.nix

    ./terminal/kitty.nix
    ./terminal/git.nix
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
      mpv
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
      # libnotify
    ];

    # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "24.05";
  };
}
