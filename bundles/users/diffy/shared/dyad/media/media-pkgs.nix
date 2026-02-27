{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "media" "extraPackages" ] {
  home-manager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        ani-cli
        video-trimmer
      ];
    };
}
