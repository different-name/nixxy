{pkgs, ...}: {
  imports = [
    ./kitty.nix
    ./unity.nix
    ./vscodium.nix
  ];

  home.packages = with pkgs; [
    android-tools
    blender
    brave
    gimp-with-plugins
    qalculate-gtk
    qbittorrent-qt5
    scrcpy
  ];
}
