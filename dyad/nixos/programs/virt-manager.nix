{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.dyad.programs.virt-manager.enable = lib.mkEnableOption "virt-manager config";

  config = lib.mkIf config.dyad.programs.virt-manager.enable {
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
