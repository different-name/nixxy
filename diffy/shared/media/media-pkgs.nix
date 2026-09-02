{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "media" "extraPackages" ] {
  home-manager = { pkgs, ... }: {
    home.perpetual.default.packages = {
      # anime streamer
      ani-cli.dirs = [
        "$stateHome/ani-cli"
      ];
    };

    home.packages = with pkgs; [
      video-trimmer
    ];
  };
}
