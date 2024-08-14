{pkgs, ...}: {
  imports = [
    ./btop.nix
    ./fd.nix
    ./fish.nix
    ./fzf.nix
    ./git.nix
    ./yazi.nix
  ];

  home.packages = with pkgs; [
    imagemagick
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
