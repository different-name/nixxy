{
  lib,
  config,
  inputs,
  pkgs,
  self,
  ...
}: {
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];

  options.nix-files.services.minecraft-server = {
    enable = lib.mkEnableOption "Minecraft-server config";
    maocraft.enable = lib.mkEnableOption "Maocraft Minecraft server";
    buhguh.enable = lib.mkEnableOption "Buhguh Minecraft server";
    maodded.enable = lib.mkEnableOption "Maodded Minecraft server";
  };

  config = lib.mkIf config.nix-files.services.minecraft-server.enable {
    nixpkgs.overlays = [
      inputs.nix-minecraft.overlay
    ];

    age.secrets."minecraft/maocraft-discordsrv" = lib.mkIf config.nix-files.services.minecraft-server.maocraft.enable {
      file = "${self}/secrets/minecraft/maocraft-discordsrv.age";
      path = "/srv/minecraft/maocraft/plugins/DiscordSRV/config.yml";
      symlink = false;
      mode = "660";
      owner = "minecraft";
      group = "minecraft";
    };

    services.minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;

      servers = {
        # nix-shell -p tmux --run "sudo tmux -S /run/minecraft/maocraft.sock attach"
        maocraft = lib.mkIf config.nix-files.services.minecraft-server.maocraft.enable {
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
            Lazy_Diffy = "be0f57d1-a79c-49d1-a126-4536c476ee51";
            Nerowy = "23b6e97d-d186-4bc2-8312-8a569013426a";
          };

          symlinks."server-icon.png" = ./maocraft-icon.png;

          files = {
            "plugins/DiscordSRV-Build-1.29.0.jar" = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/UmLGoGij/versions/MK210KrY/DiscordSRV-Build-1.29.0.jar";
              hash = "sha256-rd2qPbaQNLF2fqyv90CVhdxzTGxffSE4gJnYxHUIxic=";
            };
            "plugins/DiscordSRV/messages.yml" = ./maocraft-messages.yml;
          };
        };

        # nix-shell -p tmux --run "sudo tmux -S /run/minecraft/buhguh.sock attach"
        buhguh = lib.mkIf config.nix-files.services.minecraft-server.buhguh.enable {
          enable = false;
          package = pkgs.paperServers.paper-1_21_4;

          serverProperties = {
            server-port = 25566;
            difficulty = "normal";
            spawn-protection = 0;
            view-distance = 10;
            white-list = true;
            max-players = 20;
            motd = "buhguh";
            pvp = false;
          };

          whitelist = {
            Lazy_Diffy = "be0f57d1-a79c-49d1-a126-4536c476ee51";
            Nerowy = "23b6e97d-d186-4bc2-8312-8a569013426a";
            Di_Angelo1 = "a5268ead-ffbd-4863-9308-4de1e2766250";
          };

          symlinks."server-icon.png" = ./buhguh-icon.png;
        };

        # nix-shell -p tmux --run "sudo tmux -S /run/minecraft/maodded.sock attach"
        maodded = let
          inherit (inputs.nix-minecraft.lib) collectFilesAt;

          modpack = pkgs.fetchPackwizModpack {
            url = "https://github.com/different-name/maodded/raw/6d1f28e7e829aee8dd61b0ae5c35693a75c191c5/pack.toml";
            packHash = "sha256-WMcqXUJ7b8MfRIFRUO+k6AYJl0x7EuZYgif6RxSXq6g=";
          };

          mcVersion = modpack.manifest.versions.minecraft;
          serverVersion = lib.replaceStrings ["."] ["_"] "fabric-${mcVersion}";
        in
          lib.mkIf config.nix-files.services.minecraft-server.maodded.enable {
            enable = true;
            package = pkgs.fabricServers.${serverVersion};

            serverProperties = {
              server-port = 25567;
              difficulty = "normal";
              spawn-protection = 0;
              view-distance = 10;
              white-list = true;
              max-players = 20;
              motd = "only the best maoing";
            };

            whitelist = {
              Lazy_Diffy = "be0f57d1-a79c-49d1-a126-4536c476ee51";
              Nerowy = "23b6e97d-d186-4bc2-8312-8a569013426a";
            };

            symlinks = {
              mods = "${modpack}/mods";
              "server-icon.png" = ./maodded-icon.png;
            };

            files = collectFilesAt modpack "config";

            jvmOpts = "-Xms8G -Xmx16G -XX:+UseG1GC -XX:MaxGCPauseMillis=50 -XX:+ParallelRefProcEnabled -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -Dfabric.api.env=server -Dfile.encoding=UTF-8";
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
