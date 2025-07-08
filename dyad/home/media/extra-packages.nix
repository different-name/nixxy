{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.dyad.media.extra-packages.enable = lib.mkEnableOption "extra media packages";

  config = lib.mkIf config.dyad.media.extra-packages.enable {
    home.packages = with pkgs; [
      # keep-sorted start
      ani-cli
      video-trimmer
      # keep-sorted end
    ];
  };
}
