{pkgs, ...}: {
  programs.btop = {
    enable = true;
    catppuccin.enable = true;

    # Nvidia GPU support
    # https://github.com/aristocratos/btop/issues/426#issuecomment-2103598718
    package = pkgs.btop.override {cudaSupport = true;};

    settings = {
      shown_boxes = "proc cpu mem net gpu0";
      proc_gradient = false;
      proc_mem_bytes = false;
    };
  };
}
