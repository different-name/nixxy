{pkgs, ...}: {
  imports = [
    ./hyprpaper
    ./mako.nix
    ./playerctld.nix
  ];

  home.packages = with pkgs; [
    libnotify
  ];
}
