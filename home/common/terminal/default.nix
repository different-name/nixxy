{pkgs, ...}: {
  imports = [
    ./fastfetch
    ./btop.nix
    ./fish.nix
    ./git.nix
    ./yazi.nix
  ];

  home.packages = with pkgs; [
    imagemagick
    ffmpeg
    trashy
    ncdu
    aspell
    aspellDicts.en
    libqalculate
    sshfs
    magic-wormhole
    exiftool
    alejandra
  ];
}
