{
  bundleLib,
  lib,
  config,
  ...
}:
let
  inherit (config.dyad.applications.bitwarden) autoStart;
in
bundleLib.mkEnableModule [ "dyad" "applications" "bitwarden" ] {
  options.autoStart = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Start Bitwarden with the graphical session, hidden in the tray";
  };

  home-manager = { pkgs, ... }: {
    home.packages = [ pkgs.bitwarden-desktop ];

    # --autostart only hides to the tray when "keep running in the background" is on
    systemd.user.services.bitwarden = lib.mkIf autoStart {
      Unit = {
        Description = "Bitwarden";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
        RefuseManualStart = true;
        RefuseManualStop = true;
      };

      Service = {
        ExecStart = "${lib.getExe pkgs.bitwarden-desktop} --autostart";
        Restart = "no";
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };

    keep.safe.configDirs = [ "Bitwarden" ];
  };
}
