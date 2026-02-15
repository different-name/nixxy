{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "media" "media-pkgs" ] {
  home-manager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        ani-cli
        video-trimmer
      ];
    };
}
