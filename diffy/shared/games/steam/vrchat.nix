{
  lib,
  config,
  inputs,
  inputs',
  self',
  ...
}:
let
  appId = toString 438100;
in
{
  config = lib.mkIf config.dyad.games.steam.enable {
    home-manager =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        imports = [ inputs.vrchat-video-resolver.homeModules.default ];

        programs.steam.config.apps.${appId} = {
          name = "VRChat";
          compatTool = inputs'.nixpkgs-xr.packages.proton-rtsp-bin;

          env.TZ = null;

          systemd.enable = true;

          files.prefix.patch."user.reg" = {
            format = "unityPrefs";
            content."Software/VRChat/VRChat" = {
              VRC_ADVANCED_GRAPHICS_ANTIALIASING = 0;
              PIXEL_LIGHT_COUNT = 1;
              SHADOW_QUALITY = 0;
              LOD_QUALITY = 0;
              VRC_LIMIT_PARTICLE_SYSTEMS = true;

              VRC_MIRROR_RESOLUTION = 3;

              AUDIO_MASTER_ENABLED = true;
              AUDIO_MASTER_STEAMAUDIO = 1.0;
              AUDIO_GAME_VOICE_ENABLED = true;
              AUDIO_GAME_VOICE_STEAMAUDIO = 1.0;

              VRC_INPUT_MIC_MODE = 1;
              VRC_INPUT_MIC_NOISE_GATE = 0.002;
              VRC_INPUT_MIC_NOISE_SUPPRESSION = false;
              VRC_INPUT_MIC_ON_JOIN = 2;

              VRC_COMFORT_MODE = false;
              VRC_INPUT_COMFORT_TURNING = false;
              VRC_INPUT_LOCOMOTION_METHOD = 0;

              VRC_AV_INTERACT_LEVEL = 2;
              VRC_ALLOW_AVATAR_COPYING = false;
              VRC_ALLOW_UNTRUSTED_URL = true;
              avatarProxyAlwaysShowFriends = true;

              "PersonalMirror.ShowBorder" = false;
              "PersonalMirror.ShowEnvironmentInMirror" = false;
              "PersonalMirror.ShowRemotePlayerInMirror" = true;
              "PersonalMirror.ShowUIInMirror" = true;
              "PersonalMirror.MirrorScaleX" = 1.0;
              "PersonalMirror.MirrorScaleY" = 1.0;
              "PersonalMirror.MirrorSnapping" = false;
              "PersonalMirror.Grabbable" = false;
              "PersonalMirror.ImmersiveMove" = false;
              "PersonalMirror.MovementMode" = 1;

              VRC_HUD_MODE = 0;
              VRC_HUD_ANCHOR = 1;

              VRC_SHOW_JOIN_NOTIFICATIONS = true;
              VRC_SHOW_LEAVE_NOTIFICATIONS = true;
              VRC_SHOW_PORTAL_NOTIFICATIONS = true;
              VRC_SHOW_INVITES_NOTIFICATION = true;
              VRC_SHOW_FRIEND_REQUESTS = true;
              VRC_ONLY_SHOW_FRIEND_JOIN_LEAVE_PORTAL_NOTIFICATIONS = false;
              VRC_ASK_TO_PORTAL = true;

              VRC_CHAT_BUBBLE_TIMEOUT = 60.0;
              VRC_CHAT_BUBBLE_PROFANITY_FILTER = false;

              VRC_IK_AVATAR_MEASUREMENT_TYPE = 1;
              VRC_IK_DISABLE_SHOULDER_TRACKING = true;
              VRC_IK_FBT_LOCOMOTION = false;
              VRC_IK_FBT_SPINE_MODE = 1;
              VRC_IK_TRACKER_MODEL = 3;

              VRC_DOWNLOAD_PRIORITIZE_DISTANCE_ENABLED = true;
              VRC_PRIORITIZE_FRIEND_DOWNLOADS = true;
              VRC_PRIORITIZE_MANUAL_DOWNLOADS = false;

              VRC_HOME_ACCESS_TYPE = 4;
            };
          };
        };

        # move vrchat photo location to ~/Pictures/VRChat, takes more advanced logic
        home.activation.vrchatPhotos =
          let
            photos = "${config.home.homeDirectory}/Pictures/VRChat";
            prefixHome = "${config.xdg.dataHome}/Steam/steamapps/compatdata/${appId}/pfx/drive_c/users/steamuser";
            prefixPhotos = "${prefixHome}/Pictures/VRChat";
          in
          lib.hm.dag.entryAfter [ "linkGeneration" ] ''
            run mkdir -p ${lib.escapeShellArg photos}

            # only touch the prefix once proton has created it
            if [ -d ${lib.escapeShellArg prefixHome} ]; then
              # photos taken while the link was missing are left in the prefix, move them out
              if [ -d ${lib.escapeShellArg prefixPhotos} ] && [ ! -L ${lib.escapeShellArg prefixPhotos} ]; then
                run ${lib.getExe pkgs.rsync} -a --remove-source-files ${lib.escapeShellArg prefixPhotos}/ ${lib.escapeShellArg photos}/
                run find ${lib.escapeShellArg prefixPhotos} -depth -type d -empty -delete
              fi

              run mkdir -p ${lib.escapeShellArg (lib.dirOf prefixPhotos)}
              run ln -sfnT ${lib.escapeShellArg photos} ${lib.escapeShellArg prefixPhotos}
            fi
          '';

        services.vrchat-video-resolver = {
          enable = true;
          cookies.fromBrowser = "firefox:$HOME/.config/mozilla/firefox/ytdlp";
          steamConfig.enable = true;
        };

        home.perpetual.default.dirs = [ "$cacheHome/vrchat-video-resolver" ];

        systemd.user.services.oscleash = {
          Unit = {
            Description = "OSCLeash";
            PartOf = [ "steam-app-vrchat.target" ];
            Before = [ "steam-app-vrchat.target" ];
          };

          Service = {
            ExecStart = lib.getExe self'.packages.oscleash;
            Restart = "on-failure";
            RestartSec = 5;
          };

          Install.WantedBy = [ "steam-app-vrchat.target" ];
        };

        home.perpetual.default.packages.oscleash = {
          package = self'.packages.oscleash;
          dirs = [
            "$configHome/OSCLeash"
          ];
        };
      };
  };
}
