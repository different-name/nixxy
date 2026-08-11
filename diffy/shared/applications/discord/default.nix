{
  bundleLib,
  lib,
  inputs,
  ...
}:
bundleLib.mkEnableModule [ "dyad" "applications" "discord" ] {
  home-manager =
    { pkgs, ... }:
    let
      discordPackage = pkgs.discord.override {
        withVencord = true;
        vencord = pkgs.vencord.overrideAttrs (old: {
          patches = (old.patches or [ ]) ++ [ ./vcnarrator-mute-deafen.patch ];
        });
      };
    in
    {
      home.packages = [ discordPackage ];

      systemd.user.services.discord = {
        Unit = {
          Description = "Discord";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };

        Service = {
          # workaround for starting before network is available
          ExecStartPre = "${lib.getExe' pkgs.coreutils "sleep"} 2";
          ExecStart = lib.getExe discordPackage;
          Restart = "no";
        };

        Install.WantedBy = [ "graphical-session.target" ];
      };

      xdg.configFile."Vencord/themes/DisblockOrigin.theme.css".text =
        lib.concatMapStringsSep "\n" lib.readFile
          [
            "${inputs.disblock-origin}/DisblockOrigin.theme.css"
            ./disblock-origin-settings.css
          ];

      xdg.configFile."Vencord/settings/settings.json" = {
        source = ./vencord.json;
        force = true;
      };

      home.perpetual.default.dirs = [
        "$configHome/discord"
      ];
    };
}
