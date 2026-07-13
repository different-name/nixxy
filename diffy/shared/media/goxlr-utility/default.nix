{ bundleLib, lib, ... }:
bundleLib.mkEnableModule [ "dyad" "media" "goxlr-utility" ] {
  home-manager =
    {
      config,
      osConfig,
      pkgs,
      ...
    }:
    {
      xdg.dataFile."goxlr-utility/mic-profiles/procaster.goxlrMicProfile" = {
        source = ./procaster.goxlrMicProfile;
      };

      systemd.user.services.goxlr-daemon = {
        Unit = {
          Description = "GoXLR Daemon";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };

        Service = {
          ExecStart = lib.getExe' osConfig.services.goxlr-utility.package "goxlr-daemon";
          Restart = "on-failure";
        };

        Install.WantedBy = [ "graphical-session.target" ];
      };

      wayland.windowManager.hyprland.settings.bind =
        let
          toggleMute = pkgs.writeShellApplication {
            name = "goxlr-utility-tg-mute";
            runtimeInputs = with pkgs; [
              jq
              goxlr-utility
            ];
            text = lib.readFile ./toggle-mute.sh;
          };
        in
        [
          "$mod, Z, exec, ${lib.getExe toggleMute}"
        ];

      home.file."Audio/Samples" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.local/share/goxlr-utility/samples/Recorded";
        force = true;
      };

      home.perpetual.default.dirs = [
        "$configHome/goxlr-utility"
        "$dataHome/goxlr-utility"
      ];
    };
}
