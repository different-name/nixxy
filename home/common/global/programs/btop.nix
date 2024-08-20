{pkgs, ...}: {
  programs.btop = {
    enable = true;
    # Nvidia GPU support
    # https://github.com/aristocratos/btop/issues/426#issuecomment-2103598718
    package = pkgs.btop.override {cudaSupport = true;};

    catppuccin.enable = true;

    settings = {
      proc_gradient = false;
      proc_mem_bytes = false;
      update_ms = 1500;
      # TODO exclude persisted directories
      disks_filter = "exclude=/boot /home/different/.steam /var/log /var/lib/nixos /var/lib/systemd/coredump /etc/zfs/keys /etc/NetworkManager/system-connections /var/lib/tailscale";
    };
  };
}
