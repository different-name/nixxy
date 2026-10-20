{
  bundleLib,
  inputs,
  lib,
  ...
}:
bundleLib.mkEnableModule [ "dyad" "system" "boot" ] {
  nixos = { config, pkgs, ... }: {
    imports = [ inputs.disko.nixosModules.default ];

    config.boot = {
      initrd = {
        systemd.enable = true;
        availableKernelModules = [ "hid_generic" ];
      };

      kernelPackages = lib.mkDefault pkgs.linuxPackages_zen;

      loader = {
        limine = {
          enable = true;
          maxGenerations = 25;
        };

        efi.canTouchEfiVariables = config.boot.loader.limine.efiSupport;
        timeout = 3;
      };

      supportedFilesystems = [ "ntfs" ];
    };
  };
}
