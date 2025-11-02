{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.dyad.services.minecraft-server = {
    maocraft.enable = lib.mkEnableOption "maocraft minecraft server";
  };

  config = lib.mkIf config.dyad.services.minecraft-server.maocraft.enable {
    # nix-shell -p tmux --run "sudo tmux -S /run/minecraft/maocraft.sock attach"
    services.minecraft-servers.servers.maocraft = {
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

      symlinks."server-icon.png" = ./server-icon.png;

      files = {
        # keep-sorted start block=yes newline_separated=yes
        "plugins/DiscordSRV-Build-1.29.0.jar" = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/UmLGoGij/versions/MK210KrY/DiscordSRV-Build-1.29.0.jar";
          hash = "sha256-rd2qPbaQNLF2fqyv90CVhdxzTGxffSE4gJnYxHUIxic=";
        };

        "plugins/DiscordSRV/messages.yml" = ./maocraft-messages.yml;
        # keep-sorted end
      };
    };

    services.cloudflare-dyndns.domains = [
      "maocraft.different-name.com"
    ];
  };
}
