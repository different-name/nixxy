{pkgs, ...}: {
  imports = [
    ./hyprland
    ./hyprlock.nix
    ./rofi.nix
  ];

  home.packages = with pkgs; [
    wl-clipboard
  ];
}
