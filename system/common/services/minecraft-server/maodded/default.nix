{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: {
  options.nix-files.services.minecraft-server = {
    maodded.enable = lib.mkEnableOption "Maodded Minecraft server";
  };

  config = lib.mkIf config.nix-files.services.minecraft-server.maodded.enable {
    # simple voice chat port
    networking.firewall.allowedUDPPorts = [24454];

    # nix-shell -p tmux --run "sudo tmux -S /run/minecraft/maodded.sock attach"
    services.minecraft-servers.servers.maodded = let
      inherit (inputs.nix-minecraft.lib) collectFilesAt;

      modpack = pkgs.fetchPackwizModpack {
        url = "https://github.com/different-name/maodded/raw/719e4a21f6be0b7cd53614ecc792857082fc4a3b/pack.toml";
        packHash = "sha256-0NU/pTaSSe0Li5DAJxloVXsAnyd8iKU0cPvFFcg177w=";
      };

      mcVersion = modpack.manifest.versions.minecraft;
      serverVersion = lib.replaceStrings ["."] ["_"] "fabric-${mcVersion}";
    in {
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
        jacobkingsman = "255c3ff3-bb6e-43fd-b224-6e0ad913fa91";
        BeakedBubble8 = "37cb2b80-a717-45c3-b982-816f3f5fff25";
        Shmezzy7 = "a03f2619-e480-4671-950c-fb97e9e60c46";
      };

      symlinks = {
        mods = "${modpack}/mods";
        "server-icon.png" = ./server-icon.png;
      };

      files = collectFilesAt modpack "config";

      jvmOpts = "-Xms8G -Xmx16G -XX:+UseG1GC -XX:MaxGCPauseMillis=50 -XX:+ParallelRefProcEnabled -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -Dfabric.api.env=server -Dfile.encoding=UTF-8";
    };
  };
}
