{pkgs, ...}: {
  imports = [
    ./hyprpaper.nix
    ./mako.nix
    ./network-manager-applet.nix
    ./playerctld.nix
  ];

  home.packages = with pkgs; [
    libnotify
  ];
}
