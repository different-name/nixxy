{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "terminal" "dev-state" ] {
  home-manager.keep.persist = {
    dirs = {
      ".net" = { };
      ".npm" = { };
    };

    xdg.cache.dirs = {
      # keep-sorted start
      "deno" = { };
      "pip" = { };
      "pnpm" = { };
      "treefmt" = { };
      "zig" = { };
      # keep-sorted end
    };

    xdg.config.dirs = {
      "gcloud" = { };
      "ncmb" = { };
    };

    xdg.data.dirs."containers" = { };
    xdg.state.dirs."pnpm" = { };
  };
}
