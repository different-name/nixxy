{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "terminal" "dev-state" ] {
  home-manager.keep.safe = {
    dirs = [
      ".net"
      ".npm"
    ];

    cacheDirs = [
      # keep-sorted start
      "deno"
      "pip"
      "pnpm"
      "treefmt"
      "zig"
      # keep-sorted end
    ];

    configDirs = [
      "gcloud"
      "ncmb"
    ];

    dataDirs = [ "containers" ];
    stateDirs = [ "pnpm" ];
  };
}
