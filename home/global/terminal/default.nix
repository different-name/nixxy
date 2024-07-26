{pkgs, ...}: {
  imports = [
    ./btop.nix
    ./fastfetch.nix
    ./fd.nix
    ./fish.nix
    ./git.nix
    ./kitty.nix
  ];

  home.packages = with pkgs; [
    imagemagick
    ani-cli
    trashy
    ncdu
  ];
}
