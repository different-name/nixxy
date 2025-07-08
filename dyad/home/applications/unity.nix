{
  lib,
  config,
  pkgs,
  osConfig,
  ...
}:
{
  options.dyad.applications.unity.enable = lib.mkEnableOption "unity config";

  config = lib.mkIf config.dyad.applications.unity.enable {
    # generate scripts to launch unity editors directly, skipping the unity hub
    # can be used as unity editor in alcom
    home.file =
      let
        unityEditors = [
          "2022.3.22f1"
        ];
        editorDir = "Documents/Unity/.hub/Editor";

        uwsmCmd = lib.optionalString osConfig.programs.uwsm.enable "${lib.getExe pkgs.uwsm} app -- ";
      in
      unityEditors
      |> map (version: "${editorDir}/${version}/Editor")
      |> map (path: {
        name = "${path}/unity-run";
        value = {
          executable = true;
          text = ''
            #! /bin/sh
            exec ${lib.getExe pkgs.unityhub.fhsEnv} ${uwsmCmd} ${path}/Unity "$@"
          '';
        };
      })
      |> lib.listToAttrs;

    home.persistence.installPkgsWithPersistence = {
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
          ".local/share/ALCOM"
          ".local/share/VRChatCreatorCompanion"
          ".local/share/com.anatawa12.vrc-get-gui"
          ".cache/ALCOM"
        ];
      };

      # note: use -force-vulkan when launching unity editor
      unityhub.dirs = [
        ".config/unityhub"
        ".config/Unity"
        ".config/unity3d" # seems to also be for unity games
        ".local/share/unity3d"
        ".cache/unity3d"
      ];
    };
  };
}
