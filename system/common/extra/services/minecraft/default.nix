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
          modpack = pkgs.fetchzip {
            url = "https://cdn.discordapp.com/attachments/1281211073722318929/1281547092304597068/the-pond-server.tar.gz?ex=66dc1d3c&is=66dacbbc&hm=4f7e9f25ac4dc5ff165d6a7603d7341a39cc1bbd0c48cbe787832a7473080e79&";
            hash = "sha256-KB4Y4RWsWgFDsacy0+FyqACoDW+BJj0ZeZtI0fD5AOo=";
          };
        in {
          mods = "${modpack}/.minecraft/mods";
          "server-icon.png" = ./server-icon.png;
        };
      };
    };
  };

  environment.persistence."/persist/system".directories = [
    "/srv/minecraft"
  ];
}