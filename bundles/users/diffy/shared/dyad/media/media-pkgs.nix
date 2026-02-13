{ lib, config, ... }:
{
  options.dyad.media.media-pkgs.enable = lib.mkEnableOption "extra media packages";

  config = lib.mkIf config.dyad.media.media-pkgs.enable {
    home-manager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          ani-cli
          video-trimmer
        ];
      };
  };
}
