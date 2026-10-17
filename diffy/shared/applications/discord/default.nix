{
  bundleLib,
  lib,
  config,
  inputs,
  ...
}:
{
  options.dyad.applications.discord.autoStart = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Start discord with the graphical session";
  };

  imports = lib.singleton (
    bundleLib.mkEnableModule [ "dyad" "applications" "discord" ] {
      home-manager =
        { pkgs, ... }:
        let
          discordPackage = pkgs.discord.override {
            # vaapi decode through nvidia-vaapi-driver drops frames on streams
            commandLineArgs = lib.optionalString config.dyad.hardware.nvidia.enable "--disable-accelerated-video-decode";
            withVencord = true;
            vencord = pkgs.vencord.overrideAttrs (old: {
              patches = (old.patches or [ ]) ++ lib.filesystem.listFilesRecursive ./vencord/patches;

              postPatch = (old.postPatch or "") + ''
                mkdir -p src/userplugins
                cp -r ${./vencord/plugins}/. src/userplugins/
                chmod -R u+w src/userplugins
                substituteInPlace src/userplugins/compress-video-uploads/native.ts \
                  --replace-fail '"ffmpeg"' '"${lib.getExe' pkgs.ffmpeg "ffmpeg"}"' \
                  --replace-fail '"ffprobe"' '"${lib.getExe' pkgs.ffmpeg "ffprobe"}"'
              '';
            });
          };
        in
        {
          home.packages = [ discordPackage ];

          systemd.user.services.discord = lib.mkIf config.dyad.applications.discord.autoStart {
            Unit = {
              Description = "Discord";
              PartOf = [ "graphical-session.target" ];
              After = [ "graphical-session.target" ];
              RefuseManualStart = true;
              RefuseManualStop = true;
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
            source = ./vencord/settings.json;
            force = true;
          };

          home.perpetual.default.dirs = [
            "$configHome/discord"
          ];
        };
    }
  );
}
