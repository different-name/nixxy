{
  lib,
  config,
  pkgs,
  ...
}:
let
  unityhub-fixed-fonts = pkgs.unityhub.override {
    buildFHSEnv =
      args:
      let
        excludedPackages = [
          "corefonts"
          "dejavu-fonts"
          "liberation-fonts"
        ];
        filterPackages = lib.filter (package: !(lib.elem package.pname excludedPackages));
        filteredMultiPkgs = pkgs: filterPackages (args.multiPkgs pkgs);
      in
      pkgs.buildFHSEnv (args // { multiPkgs = filteredMultiPkgs; });
  };
in
{
  options.dyad.applications.unity.enable = lib.mkEnableOption "unity config";

  config = lib.mkIf config.dyad.applications.unity.enable {
    xdg.mimeApps.defaultApplications = {
      "x-scheme-handler/unityhub" = "unityhub.desktop"; # unity login
    };

    home.perpetual.default.packages = {
      # keep-sorted start block=yes newline_separated=yes
      alcom = {
        # wrapping with unityhub fhs env so alcom can launch unity properly
        # env var is workaround for https://github.com/tauri-apps/tauri/issues/9394
        package = pkgs.symlinkJoin {
          name = "alcom";
          paths = [ pkgs.alcom ];
          nativeBuildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            mv $out/bin/ALCOM $out/bin/.ALCOM-real
            makeWrapper ${lib.getExe unityhub-fixed-fonts.fhsEnv} $out/bin/ALCOM \
              --add-flags "$out/bin/.ALCOM-real" \
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
      unityhub = {
        package = unityhub-fixed-fonts;
        dirs = [
          # keep-sorted start
          "$cacheHome/unity3d"
          "$configHome/Unity"
          "$configHome/unity3d" # seems to also be for unity games
          "$configHome/unityhub"
          "$dataHome/unity3d"
          # keep-sorted end
        ];
      };
      # keep-sorted end
    };
  };
}
