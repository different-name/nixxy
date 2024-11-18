{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./imv.nix
    ./mpv.nix
    ./obs.nix
  ];

  options.nix-files.graphical.media.enable = lib.mkEnableOption "Media packages";

  config = lib.mkIf config.nix-files.graphical.media.enable {
    home.packages = with pkgs; [
      ani-cli
      video-trimmer
    ];
  };
}
