{
  lib,
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers

    ./buhguh
    ./maocraft
    ./maodded
  ];

  options.nix-files.services.minecraft-server = {
    enable = lib.mkEnableOption "Minecraft-server config";
  };

  config = lib.mkIf config.nix-files.services.minecraft-server.enable {
    nixpkgs.overlays = [
      inputs.nix-minecraft.overlay
    ];

    networking.firewall.allowedUDPPorts = [24454];

    services.minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;
    };

    environment.persistence."/persist/system" = lib.mkIf config.nix-files.core.persistence.enable {
      directories = [
        "/srv/minecraft"
      ];
    };
  };
}
