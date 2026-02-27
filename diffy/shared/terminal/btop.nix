{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "terminal" "btop" ] {
  home-manager.programs.btop = {
    enable = true;

    settings = {
      proc_gradient = false;
      proc_mem_bytes = false;
      show_swap = false;
    };
  };
}
