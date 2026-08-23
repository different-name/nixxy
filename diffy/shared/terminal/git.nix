{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "terminal" "git" ] {
  home-manager.programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      init.defaultBranch = "main";

      user = {
        name = "diffy";
        email = "hello@different-name.dev";
      };
    };
  };
}
