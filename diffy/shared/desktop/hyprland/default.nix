{
  bundleLib,
  lib,
  self,
  ...
}:
bundleLib.mkEnableModule [ "dyad" "desktop" "hyprland" ] {
  options.rounding = lib.mkOption {
    type = lib.types.ints.unsigned;
    default = 5;
    description = "Corner radius in pixels for hyprland windows";
  };

  nixos = {
    imports = [ self.nixosModules.tty1Autologin ];

    programs.hyprland.enable = true;

    programs.uwsm.enable = true;

    # the session is started from the tty1 login shell below
    services.tty1Autologin = {
      enable = true;
      user = "diffy";
    };

    environment = {
      # auto launch hyprland on tty1
      loginShellInit = ''
        if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ] && uwsm check may-start; then
          exec uwsm start -e -D Hyprland hyprland.desktop
        fi
      '';

      # hint electron apps to use wayland
      sessionVariables.NIXOS_OZONE_WL = 1;
    };
  };

  home-manager =
    { osConfig, pkgs, ... }:
    let
      toLua = lib.generators.toLua { };
    in
    {
      imports = [ self.homeModules.xdgDesktopPortalHyprland ];

      lib.hyprland = rec {
        mod = "SUPER";
        lua = lib.generators.mkLuaInline;
        bind = bindWith { };
        bindWith = opts: keys: dispatcher: {
          _args = [
            keys
            (lua dispatcher)
          ]
          ++ lib.optional (opts != { }) opts;
        };
        exec = cmd: "hl.dsp.exec_cmd(${toLua cmd})";
        env = name: value: {
          _args = [
            name
            value
          ];
        };
      };

      wayland.windowManager.hyprland = {
        enable = true;
        package = null;
        portalPackage = null;

        configType = "lua";

        systemd = {
          enable = !osConfig.programs.uwsm.enable; # conflicts with uwsm
          variables = [ "--all" ]; # https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/#programs-dont-work-in-systemd-services-but-do-on-the-terminal
        };

        xwayland.enable = true;

        settings.on = lib.singleton {
          _args = [
            "hyprland.start"
            (lib.generators.mkLuaInline ''
              function()
                hl.exec_cmd(${toLua "${lib.getExe pkgs.uwsm} finalize && ${lib.getExe' pkgs.systemd "systemctl"} --user restart xdg-desktop-portal.service"})
                hl.exec_cmd(${toLua "${lib.getExe pkgs.wl-clip-persist} --clipboard regular"})
              end'')
          ];
        };
      };

      services.hyprpolkitagent.enable = true;

      home.packages = [
        pkgs.hyprpicker
        pkgs.grimblast
      ];

      home.perpetual.default.dirs = [
        "$cacheHome/hyprland"
        "$dataHome/hyprland"
      ];
    };
}
