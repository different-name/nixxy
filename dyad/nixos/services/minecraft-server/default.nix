{
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];

  options.dyad.services.minecraft-server = {
    enable = lib.mkEnableOption "minecraft-server config";
  };

  config = lib.mkIf config.dyad.services.minecraft-server.enable {
    nixpkgs.overlays = [
      inputs.nix-minecraft.overlay
    ];

    services.minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;
    };

    environment.perpetual.default.dirs = [
      "/srv/minecraft"
    ];
  };
}
