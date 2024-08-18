{pkgs, ...}: {
  imports = [
    ./hyprpaper.nix
    ./mako.nix
    ./playerctld.nix
  ];

  home.packages = with pkgs; [
    libnotify
  ];
}
