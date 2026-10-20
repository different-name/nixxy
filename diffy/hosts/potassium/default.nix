{
  lib,
  inputs,
  self,
  ...
}:
let
  machineId = "ea3a24c5b3a84bc0a06ac47ef29ef2a8";
in
{
  dyad = {
    users.diffy.enable = true;

    profiles = {
      # keep-sorted start
      graphical-extras.enable = true;
      graphical.enable = true;
      minimal.enable = true;
      terminal.enable = true;
      # keep-sorted end
    };

    hardware = {
      bluetooth.enable = true;
      nvidia.enable = true;
    };

    system = {
      btrfs.enable = true;
      perpetual.enable = true;
    };

    applications.discord.autoStart = false;

    nix.sodium-builder.enable = true;

    services = {
      printing.enable = true;
    };
  };

  nixos = {
    imports = [
      # keep-sorted start
      (inputs.import-tree ./_nixos)
      inputs.nixos-hardware.nixosModules.common-cpu-intel
      self.nixosModules.tty1Autologin
      # keep-sorted end
    ];

    networking = {
      hostName = "potassium";
      hostId = lib.substring 0 8 machineId;
    };

    environment.etc.machine-id.text = machineId;

    system.stateVersion = "26.05";

    services.tty1Autologin = {
      enable = true;
      user = "diffy";
    };

    hardware.nvidia.prime = {
      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:2:0";
    };
  };

  home-manager =
    { config, ... }:
    let
      inherit (config.lib.hyprland) mod bind exec;
    in
    {
      # display battery as notification
      wayland.windowManager.hyprland.settings.bind = [
        (bind "${mod} + B" (
          exec ''notify-send -t 5000 "Battery: $(cat /sys/class/power_supply/BAT0/capacity)%"''
        ))
      ];
    };
}
