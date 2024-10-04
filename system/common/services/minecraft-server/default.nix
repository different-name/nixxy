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
        # nix-shell -p tmux --run "sudo tmux -S /run/minecraft/the-pond.sock attach"
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
            karrotttt = "fe8b5988-e995-4f0e-8554-6ada52463b32";
          };

          symlinks = let
            modpack = pkgs.fetchPackwizModpack {
              url = "https://github.com/different-name/the-pond-server/raw/3e1ecde45c9106f054f275b831dcf5f295f74d9a/server/pack.toml";
              packHash = "sha256-dfz5lTrWuhhWS1eLjeEPAssdhPoyu6XcnKBHgyFYufs=";
            };
          in {
            mods = "${modpack}/mods";
            "server-icon.png" = ./server-icon.png;
          };
        };

        gngg = {
          enable = true;
          package = pkgs.papermcServers.papermc-1_21_1;

          serverProperties = {
            server-port = 25566;
            difficulty = "normal";
            spawn-protection = 0;
            view-distance = 16;
            white-list = true;
            motd = "gngg";
          };

          whitelist = {
            Different_Name02 = "be0f57d1-a79c-49d1-a126-4536c476ee51";
            fawntf = "6f198bd8-c414-4154-8d33-756c07da1853";
            towsertv = "479bfc70-ec91-4975-ad6d-cbd38c352774";
            sinayka = "67b13a9f-48f2-4a5d-b70e-b08593c523c2";
            undeadtv = "565f70bb-3080-430f-a808-b81112f6ce6a";
            Gailium_ = "b8b36037-0edb-422c-add3-d1e538db3ac1";
            Novius69 = "4060fc44-c2cb-4851-bfc6-51ab365b0d90";
            akrumbs = "d5615dfe-2c4b-4723-a943-e405696524ec";
            loolystarlight = "15a80ccd-e919-4bf1-a5f9-caf4520164eb";
            Bluevou = "be884360-3a6f-43bb-8a6d-043e1ce12681";
            bagofdoritos_ = "96502a0b-5beb-42bc-8c38-1b7487eada5b";
          };

          # symlinks = {
          #   plugins =
          #     pkgs.linkDarmFromDrvs "plugins" (builtins.attrValues {
          #
          #     });
          # };
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
