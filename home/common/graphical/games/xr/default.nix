{
  lib,
  config,
  pkgs,
  ...
}: {
  options.nix-files.graphical.games.xr.enable = lib.mkEnableOption "XR config";

  config = lib.mkIf config.nix-files.graphical.games.xr.enable {
    # https://lvra.gitlab.io/docs/distros/nixos/#recommendations
    xdg.configFile."openvr/openvrpaths.vrpath" = {
      text = ''
        {
          "config" :
          [
            "~/.local/share/Steam/config"
          ],
          "external_drivers" : null,
          "jsonid" : "vrpathreg",
          "log" :
          [
            "~/.local/share/Steam/logs"
          ],
          "runtime" :
          [
            "${pkgs.opencomposite}/lib/opencomposite"
          ],
          "version" : 1
        }
      '';
      force = true;
    };

    home.file = let
      steamDir = ".local/share/Steam/steamapps/common";
    in {
      # https://github.com/galister/wlx-overlay-s/wiki/OpenXR-Bindings
      ".config/wlxoverlay/openxr_actions.json5".source =
        ./bindings/wlx-overlay-s/openxr_actions.json5;

      # https://lvra.gitlab.io/docs/fossvr/opencomposite/#rebinding-controls

      "${steamDir}/VRChat/OpenComposite/oculus_touch.json".source =
        ./bindings/vrchat/oculus_touch.json;
    };

    home.packages = with pkgs; [
      wlx-overlay-s # TODO autostart this somehow

      # https://github.com/tauri-apps/tauri/issues/9394
      (symlinkJoin {
        name = "slimevr";
        paths = [slimevr];
        buildInputs = [makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/slimevr \
            --set WEBKIT_DISABLE_DMABUF_RENDERER 1
        '';
      })
    ];

    home.persistence."/persist${config.home.homeDirectory}" = lib.mkIf config.nix-files.persistence.enable {
      directories = [
        ".config/wivrn"
        ".cache/wivrn"

        ".config/openvr"

        ".local/state/OpenComposite"

        ".config/wlxoverlay"

        ".config/dev.slimevr.SlimeVR"
        ".local/share/dev.slimevr.SlimeVR"
        ".local/share/.slimevr-wrapped_"
        ".cache/.slimevr-wrapped_"
      ];
    };
  };
}
