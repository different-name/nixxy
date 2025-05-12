{
  lib,
  config,
  pkgs,
  ...
}: {
  options.nix-files.graphical.games.xr.enable = lib.mkEnableOption "XR config";

  config = lib.mkIf config.nix-files.graphical.games.xr.enable {
    # https://lvra.gitlab.io/docs/distros/nixos/#recommendations
    xdg.configFile."openvr/openvrpaths.vrpath".text = ''
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

    home.packages = with pkgs; [
      wlx-overlay-s # TODO autostart this somehow
      slimevr
      slimevr-server
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
