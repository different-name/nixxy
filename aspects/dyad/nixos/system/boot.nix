{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.default
  ];

  options.dyad.system.boot.enable = lib.mkEnableOption "boot config";

  config = lib.mkIf config.dyad.system.boot.enable {
    boot = {
      initrd = {
        systemd.enable = true;
        availableKernelModules = [ "hid_generic" ];
      };

      kernelPackages = pkgs.linuxPackages_zen;

      loader = {
        limine = {
          enable = true;
          maxGenerations = 25;

          additionalFiles = {
            "efi/memtest86/memtest.efi" = "${pkgs.memtest86plus}/memtest.efi";
            "efi/netbootxyz/netboot.xyz.efi" = "${pkgs.netbootxyz-efi}";
          };

          extraEntries = ''
            /+Tools
            //MemTest86
              protocol: efi
              path: boot():/limine/efi/memtest86/memtest.efi
            //Netboot.xyz
              protocol: efi
              path: boot():/limine/efi/netbootxyz/netboot.xyz.efi

            /+Windows
            //Windows 10
              protocol: efi
              path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
          '';
        };

        efi.canTouchEfiVariables = true;
        timeout = 3;
      };

      supportedFilesystems = [ "ntfs" ];
    };
  };
}
