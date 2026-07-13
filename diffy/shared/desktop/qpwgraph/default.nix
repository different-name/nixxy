{ bundleLib, lib, ... }:
bundleLib.mkEnableModule [ "dyad" "desktop" "qpwgraph" ] {
  home-manager = { pkgs, ... }: {
    home.packages = [
      pkgs.qpwgraph
    ];

    systemd.user.services.qpwgraph = {
      Unit = {
        Description = "qpwgraph";
        Requires = [ "pipewire.service" ];
        After = [
          "graphical-session.target"
          "pipewire.service"
        ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${lib.getExe pkgs.qpwgraph} --activated --minimized ${./patchbay.qpwgraph}";
        Restart = "on-failure";
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
