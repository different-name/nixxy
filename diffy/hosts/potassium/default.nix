{ lib, inputs, ... }:
let
  machineId = "ea3a24c5b3a84bc0a06ac47ef29ef2a8";
in
{
  dyad = {
    users.diffy.enable = true;

    profiles.graphical-extras.enable = true;

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
      inputs.nixos-hardware.nixosModules.common-pc-laptop
      # keep-sorted end
    ];

    networking = {
      hostName = "potassium";
      hostId = lib.substring 0 8 machineId;
    };

    environment.etc.machine-id.text = machineId;

    system.stateVersion = "26.05";

    services.thermald = {
      enable = true;
      # generated for the xps 15 9500, thermald has no default for it
      configFile = "${inputs.nixos-hardware}/dell/xps/15-9500/thermald-conf.xml";
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
