{
  lib,
  config,
  self',
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
      # keep-sorted start block=yes newline-separated=yes
      # note: use -force-vulkan when launching unity editor
      unity-2022-3-22 = {
        package = self'.packages.unity-2022-3-22;
        dirs = [
          # keep-sorted start
          "$cacheHome/unity3d"
          "$configHome/Unity"
          "$configHome/unity3d" # seems to also be for unity games
          "$dataHome/unity3d"
          # keep-sorted end
        ];
      };

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

      # required to activate license, but not used to install anything
      # TODO: removed temporarily due to https://github.com/NixOS/nixpkgs/blob/c2ae88e026f9525daf89587f3cbee584b92b6134/pkgs/by-name/un/unityhub/package.nix#L106-L108
      # waiting for https://github.com/NixOS/nixpkgs/pull/421740
      # unityhub.dirs = [
      #   "$configHome/unityhub"
      # ];
      # keep-sorted end
    };
  };
}
