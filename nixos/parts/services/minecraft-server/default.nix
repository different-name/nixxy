{
  lib,
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];

  options.nix-files.parts.services.minecraft-server = {
    enable = lib.mkEnableOption "Minecraft-server config";
  };

  config = lib.mkIf config.nix-files.parts.services.minecraft-server.enable {
    nixpkgs.overlays = [
      inputs.nix-minecraft.overlay
    ];

    services.minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;
    };

    environment.persistence."/persist/system" =
      lib.mkIf config.nix-files.parts.system.persistence.enable
      {
        directories = [
          "/srv/minecraft"
        ];
      };
  };
}
