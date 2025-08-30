{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.dyad.applications.unity.enable = lib.mkEnableOption "unity config";

  config = lib.mkIf config.dyad.applications.unity.enable {
    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/unityhub" = "unityhub.desktop"; # unity login
    };

    home.perpetual.default.packages = {
      # keep-sorted start block=yes newline_separated=yes
      alcom = {
        # https://github.com/tauri-apps/tauri/issues/9394
        package = pkgs.symlinkJoin {
          name = "alcom";
          paths = [ pkgs.alcom ];
          buildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/ALCOM \
              --set WEBKIT_DISABLE_DMABUF_RENDERER 1
          '';
        };
        dirs = [
          # keep-sorted start
          "$cacheHome/ALCOM"
          "$dataHome/ALCOM"
          "$dataHome/VRChatCreatorCompanion"
          "$dataHome/com.anatawa12.vrc-get-gui"
          # keep-sorted end
        ];
      };

      # note: use -force-vulkan when launching unity editor
      unityhub.dirs = [
        # keep-sorted start
        "$cacheHome/unity3d"
        "$configHome/Unity"
        "$configHome/unity3d" # seems to also be for unity games
        "$configHome/unityhub"
        "$dataHome/unity3d"
        # keep-sorted end
      ];
      # keep-sorted end
    };
  };
}
