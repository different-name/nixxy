{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # disko is required for boot & mounting
    inputs.disko.nixosModules.default
  ];

  options.nix-files.core.boot.enable = lib.mkEnableOption "Boot config";

  config = lib.mkIf config.nix-files.core.boot.enable {
    boot = {
      initrd = {
        # enable systemd in initial ramdisk
        systemd.enable = true;
        # ensure human input devices are functioning
        # need keyboard input to enter passphrase
        availableKernelModules = ["hid_generic"];
      };

      # using pinned nixpkgs version for latest zfs compatible zen kernel
      kernelPackages = let
        pkgs-kernel = import inputs.nixpkgs-kernel {
          inherit (pkgs.stdenv.hostPlatform) system;
          inherit (config.nixpkgs) config;
        };
      in
        pkgs-kernel.linuxPackages_zen;

      loader = {
        # systemd-boot on UEFI
        systemd-boot = {
          enable = true;

          memtest86.enable = true;
        };
        efi.canTouchEfiVariables = true;
        # Skip boot options after 3 seconds
        timeout = 3;
      };

      supportedFilesystems = ["zfs" "ntfs"];
    };
  };
}
