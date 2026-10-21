{
  bundleLib,
  lib,
  config,
  inputs,
  ...
}:
bundleLib.mkEnableModule [ "dyad" "applications" "discord" ] {
  options.autoStart = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Start discord with the graphical session";
  };

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
        let
          overrides = {
            bool-settings-payment-section = false;
            bool-show-name-gradients = false;
            bool-show-server-banners = false;
            display-active-now = "none";
            display-clan-tags = "none";
            display-gif-button = "unset";
            display-settings-gift-inventory-tab = "none";
            display-sticker-button = "unset";
          };
          toCss = value: if lib.isBool value then lib.boolToString value else value;
        in
        lib.readFile "${inputs.disblock-origin}/DisblockOrigin.theme.css"
        + ''
          :root {
          ${lib.concatLines (lib.mapAttrsToList (name: value: "  --${name}: ${toCss value};") overrides)}}
        '';

      xdg.configFile."Vencord/settings/settings.json" = {
        source = ./vencord/settings.json;
        force = true;
      };

      keep.safe.configDirs = [ "discord" ];
    };
}
