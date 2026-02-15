{ bundleLib, inputs, ... }:
bundleLib.mkEnableModule [ "dyad" "services" "minecraft-server" ] {
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
}
