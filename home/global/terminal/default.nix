{pkgs, ...}: {
  imports = [
    ./btop.nix
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
