{pkgs, ...}: {
  imports = [
    ./imv.nix
    ./obs.nix
  ];

  home.packages = with pkgs; [
    ani-cli
    video-trimmer
  ];
}
