{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "terminal" "dev-state" ] {
  home-manager.home.perpetual.default.dirs = [
    # keep-sorted start
    "$cacheHome/deno"
    "$cacheHome/pip"
    "$cacheHome/pnpm"
    "$cacheHome/treefmt"
    "$cacheHome/zig"
    "$configHome/gcloud"
    "$dataHome/containers"
    "$stateHome/pnpm"
    ".net"
    ".npm"
    # keep-sorted end
  ];
}
