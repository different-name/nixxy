{ lib, config, ... }:
{
  options.dyad.media.media-pkgs.enable = lib.mkEnableOption "extra media packages";

  config = lib.mkIf config.dyad.media.media-pkgs.enable {
    hm =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          ani-cli
          video-trimmer
        ];
      };
  };
}
