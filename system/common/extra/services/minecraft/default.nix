{inputs, pkgs, ...}: {
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];

  nixpkgs.overlays = [
    inputs.nix-minecraft.overlay
  ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;

    servers = {
      the-pond = {
        enable = true;
        package = pkgs.fabricServers.fabric-1_20_1;

        serverProperties = {
          difficulty = "normal";
          spawn-protection = 0;
          view-distance = 16;
          white-list = true;
          motd = "the pond";
        };

        whitelist = {
          Different_Name02 = "be0f57d1-a79c-49d1-a126-4536c476ee51";
          Nerowy = "23b6e97d-d186-4bc2-8312-8a569013426a";
          BazzleBee = "893d60df-0610-4476-ab55-8a6187722121";
        };

        symlinks = let
          modpack = pkgs.fetchPackwizModpack {
            url = "https://github.com/different-name/the-pond-server/raw/2bc55cbdc1fcd92e9c42ac07644ea91c690228ea/pack.toml";
            packHash = "";
          };
        in {
          mods = "${modpack}/mods";
          "server-icon.png" = ./server-icon.png;
        };
      };
    };
  };

  environment.persistence."/persist/system".directories = [
    "/srv/minecraft"
  ];
}