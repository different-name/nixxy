{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];

  options.nix-files.services.minecraft-server.enable = lib.mkEnableOption "Minecraft-server config";

  config = lib.mkIf config.nix-files.services.minecraft-server.enable {
    nixpkgs.overlays = [
      inputs.nix-minecraft.overlay
    ];

    services.minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;

      servers = {
        # nix-shell -p tmux --run "sudo tmux -S /run/minecraft/maocraft.sock attach"
        maocraft = {
          enable = true;
          package = pkgs.paperServers.paper-1_21_4;

          serverProperties = {
            difficulty = "normal";
            spawn-protection = 0;
            view-distance = 16;
            white-list = true;
            max-players = 2;
            motd = "mao";
            pvp = false;
          };

          whitelist = {
            Different_Name02 = "be0f57d1-a79c-49d1-a126-4536c476ee51";
            Nerowy = "23b6e97d-d186-4bc2-8312-8a569013426a";
          };

          symlinks."server-icon.png" = ./maocraft-icon.png;
        };

        buhguh = {
          enable = true;
          package = pkgs.paperServers.paper-1_21_4;

          serverProperties = {
            server-port = 25566;
            difficulty = "normal";
            spawn-protection = 0;
            view-distance = 16;
            white-list = true;
            max-players = 20;
            motd = "buhguh";
            pvp = false;
          };

          whitelist = {
            Different_Name02 = "be0f57d1-a79c-49d1-a126-4536c476ee51";
            Nerowy = "23b6e97d-d186-4bc2-8312-8a569013426a";
            Di_Angelo1 = "a5268ead-ffbd-4863-9308-4de1e2766250";
          };

          symlinks."server-icon.png" = ./buhguh-icon.png;
        };
      };
    };

    environment.persistence."/persist/system" = lib.mkIf config.nix-files.core.persistence.enable {
      directories = [
        "/srv/minecraft"
      ];
    };
  };
}
