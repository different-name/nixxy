{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "games" "avatar-tools" ] {
  home-manager =
    { pkgs, ... }:
    let
      # the editor's font default sans is variable (inter)
      # use only the static fonts in the fhs env (dejavu, liberation, corefonts)
      unityFontconfig = pkgs.writeText "unity-fontconfig.conf" ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
        <fontconfig>
          <dir>/usr/share/fonts</dir>
          <cachedir prefix="xdg">fontconfig-unity</cachedir>
          <alias binding="strong"><family>sans-serif</family><prefer><family>DejaVu Sans</family><family>Liberation Sans</family></prefer></alias>
          <alias binding="strong"><family>serif</family><prefer><family>DejaVu Serif</family><family>Liberation Serif</family></prefer></alias>
          <alias binding="strong"><family>monospace</family><prefer><family>DejaVu Sans Mono</family><family>Liberation Mono</family></prefer></alias>
          <alias binding="strong"><family>Arial</family><prefer><family>Liberation Sans</family></prefer></alias>
          <alias binding="strong"><family>Helvetica</family><prefer><family>Liberation Sans</family></prefer></alias>
        </fontconfig>
      '';

      # wrapper that runs the editor inside unityhub's own fhs env
      # for alcom to use instead of launching the editor directly
      # also includes launch args:
      #  -force-vulkan: stable rendering on nvidia
      #  -job-worker-count 1: works around crunch texture compressor crashing
      unity-editor = pkgs.writeShellScriptBin "unity-editor" ''
        export FONTCONFIG_FILE=${unityFontconfig}
        exec ${pkgs.unityhub.fhsEnv}/bin/unityhub-fhs-env \
          "$HOME/Documents/Unity/Hub/Editor/2022.3.22f1/Editor/Unity" \
          -force-vulkan -job-worker-count 1 "$@"
      '';
    in
    {
      home.packages = [
        # keep-sorted start
        pkgs.alcom
        pkgs.blender
        pkgs.unityhub
        unity-editor
        # keep-sorted end
      ];

      home.perpetual.default.dirs = [
        # keep-sorted start
        "$cacheHome/blender"
        "$configHome/UnityHub"
        "$configHome/blender"
        "$configHome/unity3d"
        "$configHome/unityhub"
        "$dataHome/ALCOM"
        "$dataHome/VRChatCreatorCompanion"
        "$dataHome/com.anatawa12.vrc-get-gui"
        "$dataHome/unityhub"
        # keep-sorted end
      ];
    };
}
