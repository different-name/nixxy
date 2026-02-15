{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "applications" "virt-manager" ] {
  nixos =
    { pkgs, ... }:
    {
      programs.virt-manager.enable = true;

      virtualisation.libvirtd = {
        enable = true;
        qemu = {
          # tpm support
          swtpm.enable = true;
          # file sharing between host & guest
          vhostUserPackages = [ pkgs.virtiofsd ];
        };
      };

      environment.perpetual.default.dirs = [
        "/var/lib/libvirt"
        "/var/lib/swtpm-localca"
      ];
    };
}
