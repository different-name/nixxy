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
      ani-cli
      video-trimmer
    ];
  };
}
