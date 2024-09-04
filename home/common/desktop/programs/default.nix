{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./wayland
    ./fastfetch.nix
    ./gtk.nix
    ./imv.nix
    ./kitty.nix
    ./mpv.nix
    ./obs.nix
    ./qt.nix
    ./steam.nix
    ./vscodium.nix
    ./zathura.nix
    ./xdg.nix
  ];

  home.packages = with pkgs; [
    # util
    brave
    pavucontrol
    qalculate-gtk
    gimp-with-plugins
    scrcpy
    android-tools
    blender
    ani-cli
    vrc-get
    qbittorrent-qt5
    polychromatic

    # games
    vesktop
    unityhub
    lutris
    heroic
    wlx-overlay-s
    (prismlauncher.override {
      jdks = [
        zulu8
        zulu17
        zulu21
      ];
    })
    osu-lazer-bin

    # work
    slack
    libreoffice-qt6-fresh

    inputs.hyprpicker.packages.${pkgs.system}.default
  ];
}
