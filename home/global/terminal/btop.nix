{pkgs, ...}: {
  programs.btop = {
    enable = true;
    catppuccin.enable = true;

    # Nvidia GPU support
    # https://github.com/aristocratos/btop/issues/426#issuecomment-2103598718
    package = pkgs.btop.override {cudaSupport = true;};

    settings = {
      proc_gradient = false;
      proc_mem_bytes = false;
      update_ms = 1500;
    };
  };
}
