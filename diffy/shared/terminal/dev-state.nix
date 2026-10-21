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
      "go-build"
      "pip"
      "pnpm"
      "treefmt"
      "zig"
      # keep-sorted end
    ];

    configDirs = [
      "gcloud"
      "go"
      "hearth"
      "ncmb"
    ];

    dataDirs = [ "containers" ];

    stateDirs = [
      "hearth"
      "pnpm"
    ];
  };
}
