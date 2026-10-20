{
  config,
  options,
  lib,
  inputs,
  ...
}:
let
  # raw definition, the merged option would recurse through the probe platform
  nixosPlatform =
    (lib.findFirst (def: def ? nixos) { } options.bundle.systemPlatforms.definitions).nixos;

  stub = {
    nixos = {
      system.stateVersion = "26.05";
      nixpkgs.hostPlatform = "x86_64-linux";
      networking.hostId = "00000000";
      fileSystems."/" = {
        device = "/dev/disk/by-label/root";
        fsType = "btrfs";
      };
      boot.loader.grub.enable = lib.mkDefault false;
    };
  };

  user.dyad.users.diffy.enable = true;

  # toggle sets that have broken on their own before
  probes = {
    none = { };
    inherit user;
    minimal = lib.recursiveUpdate user { dyad.profiles.minimal.enable = true; };
    workstation = lib.recursiveUpdate user { dyad.profiles.workstation.enable = true; };
    graphical = lib.recursiveUpdate user { dyad.profiles.graphical.enable = true; };
    graphical-extras = lib.recursiveUpdate user { dyad.profiles.graphical-extras.enable = true; };
    mako = lib.recursiveUpdate user { dyad.desktop.mako.enable = true; };
    vscodium = lib.recursiveUpdate user { dyad.applications.vscodium.enable = true; };
    nushell = lib.recursiveUpdate user { dyad.terminal.nushell.enable = true; };
    discord = lib.recursiveUpdate user { dyad.applications.discord.enable = true; };
    goxlr = lib.recursiveUpdate user { dyad.media.goxlr-utility.enable = true; };
  };

  hosts = lib.mapAttrs' (name: _: lib.nameValuePair "probe-${name}" name) probes;
in
{
  bundle = {
    systemPlatforms.probe = nixosPlatform // {
      namespace = "nixos";
      flakeAttribute = "probeConfigurations";
    };

    homePlatforms.home-manager.system.platforms.probe.module = inputs.home-manager.nixosModules.default;

    hosts = lib.mapAttrs (_: _: {
      system = "x86_64-linux";
      systemPlatform = "probe";
    }) hosts;

    users.diffy.hosts = lib.mapAttrs (_: probe: {
      imports = [
        stub
        probes.${probe}
      ];
    }) hosts;
  };

  perSystem = { pkgs, system, ... }: {
    checks = lib.optionalAttrs (system == "x86_64-linux") (
      lib.mapAttrs (
        name: nixos:
        # forces evaluation without building the closure
        pkgs.writeText name (builtins.unsafeDiscardStringContext nixos.config.system.build.toplevel.drvPath)
      ) config.flake.probeConfigurations
    );
  };
}
