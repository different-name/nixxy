{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "terminal" "shellAliases" ] {
  home-manager.home.shellAliases = {
    ytdl = "yt-dlp -t mp4 --no-playlist --cookies-from-browser firefox";
  };
}
