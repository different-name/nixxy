{
  lib,
  config,
  inputs,
  ...
}:
{
  options.dyad.services.minecraft-server = {
    enable = lib.mkEnableOption "minecraft-server config";
  };

  config = lib.mkIf config.dyad.services.minecraft-server.enable {
    nixos = {
      imports = [
        inputs.nix-minecraft.nixosModules.minecraft-servers
      ];

      config = {
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
    };
  };
}
