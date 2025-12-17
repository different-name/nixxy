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

          extraEntries = ''
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
