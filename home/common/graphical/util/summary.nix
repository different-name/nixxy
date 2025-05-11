{
  lib,
  config,
  pkgs,
  ...
}: {
  options.nix-files.graphical.util.summary.enable = lib.mkEnableOption "Summary config";

  config = lib.mkIf config.nix-files.graphical.util.summary.enable {
    systemd.user = {
      services.nix-files-weather = {
        Unit = {
          Description = "Update nix-files weather cache";
          After = ["network-online.target"];
          Wants = ["network-online.target"];
        };

        Service = {
          Type = "oneshot";
          ExecStart = let
            updateWeather = pkgs.writeShellScriptBin "update-weather" ''
              CACHE_DIR="${config.home.homeDirectory}/.cache/nix-files"
              mkdir -p "$CACHE_DIR"
              ${pkgs.curl}/bin/curl --max-time 10 "wttr.in/?0QTn" > "$CACHE_DIR/weather"
            '';
          in "${updateWeather}/bin/update-weather";
        };
      };

      timers.nix-files-weather = {
        Unit = {
          Description = "Update nix-files weather cache every 15 minutes";
        };

        Timer = {
          OnBootSec = "1min";
          OnUnitActiveSec = "15min";
          Unit = "nix-files-weather.service";
        };

        Install = {
          WantedBy = ["timers.target"];
        };
      };
    };

    wayland.windowManager.hyprland.settings.bind = [
      # display summary as noficiation
      ''$mod, D, exec, notify-send -t 7500 "$(cat .cache/nix-files/weather)" && notify-send -t 7500 "$(date "+%a %-d %b %Y | %-I:%M%p")"''
    ];
  };
}
