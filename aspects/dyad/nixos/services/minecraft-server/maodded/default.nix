{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  options.dyad.services.minecraft-server = {
    maodded.enable = lib.mkEnableOption "maodded minecraft server";
  };

  config = lib.mkIf config.dyad.services.minecraft-server.maodded.enable {
    # simple voice chat port
    networking.firewall.allowedUDPPorts = [ 24454 ];

    # nix-shell -p tmux --run "sudo tmux -S /run/minecraft/maodded.sock attach"
    services.minecraft-servers.servers.maodded =
      let
        inherit (inputs.nix-minecraft.lib) collectFilesAt;

        modpack = pkgs.fetchPackwizModpack {
          url = "https://github.com/different-name/maodded/raw/719e4a21f6be0b7cd53614ecc792857082fc4a3b/pack.toml";
          packHash = "sha256-0NU/pTaSSe0Li5DAJxloVXsAnyd8iKU0cPvFFcg177w=";
        };

        mcVersion = modpack.manifest.versions.minecraft;
        serverVersion = lib.replaceStrings [ "." ] [ "_" ] "fabric-${mcVersion}";
      in
      {
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
          # keep-sorted start
          BeakedBubble8 = "37cb2b80-a717-45c3-b982-816f3f5fff25";
          Lazy_Diffy = "be0f57d1-a79c-49d1-a126-4536c476ee51";
          Nerowy = "23b6e97d-d186-4bc2-8312-8a569013426a";
          Saltybutcooler = "d7bc605a-4ffd-458a-999b-e6a5f5f47eeb";
          Shmezzy7 = "a03f2619-e480-4671-950c-fb97e9e60c46";
          TheOldFool154 = "a362b48d-0abf-4734-898c-53b2ea53945b";
          Zeypriannah = "1d37fc18-a7a9-42b8-a40d-0b93603d02c0";
          jacobkingsman = "255c3ff3-bb6e-43fd-b224-6e0ad913fa91";
          # keep-sorted end
        };

        symlinks = {
          # keep-sorted start
          "server-icon.png" = ./server-icon.png;
          mods = modpack + /mods;
          # keep-sorted end
        };

        files = collectFilesAt modpack "config";

        jvmOpts = "-Xms8G -Xmx16G -XX:+UseG1GC -XX:MaxGCPauseMillis=50 -XX:+ParallelRefProcEnabled -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -Dfabric.api.env=server -Dfile.encoding=UTF-8";
      };

    services.cloudflare-dyndns.domains = [
      "maodded.different-name.com"
    ];
  };
}
