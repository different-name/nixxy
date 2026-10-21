{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "media" "extraPackages" ] {
  home-manager = { pkgs, ... }: {
    keep.persist.packages = {
      # anime streamer
      ani-cli.xdg.state.dirs."ani-cli" = { };
    };

    home.packages = with pkgs; [ video-trimmer ];
  };
}
