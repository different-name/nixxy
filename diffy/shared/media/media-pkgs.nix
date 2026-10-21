{ bundleLib, lib, ... }:
bundleLib.mkEnableModule [ "dyad" "media" "extraPackages" ] {
  home-manager = { pkgs, ... }: {
    imports = lib.attrValues {
      # anime streamer
      ani-cli = {
        home.packages = [ pkgs.ani-cli ];
        keep.safe.stateDirs = [ "ani-cli" ];
      };
    };

    home.packages = with pkgs; [ video-trimmer ];
  };
}
