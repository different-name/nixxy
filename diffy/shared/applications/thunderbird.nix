{
  bundleLib,
  lib,
  config,
  ...
}:
let
  inherit (config.dyad.applications.thunderbird) autoStart;
  inherit (config.dyad.desktop) hyprland;

  radicale = "https://cal.diffy.wtf/diffy";

  calendars = {
    Birthdays = "birthdays";
    Default = "default";
  };
in
bundleLib.mkEnableModule [ "dyad" "applications" "thunderbird" ] {
  options.autoStart = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Start Thunderbird with the graphical session, hidden in a special workspace toggled with super + m";
  };

  home-manager =
    {
      config,
      osConfig,
      pkgs,
      ...
    }:
    let
      inherit (config.lib.hyprland) mod bind lua;
      uwsm = lib.optionalString osConfig.programs.uwsm.enable "uwsm app -- ";
      thunderbird = lib.getExe config.programs.thunderbird.package;

      # brings a hidden thunderbird to the current workspace instead of starting another
      raise = pkgs.writeShellApplication {
        name = "thunderbird-raise";
        runtimeInputs = [ pkgs.jq ];
        text = ''
          if hyprctl clients -j | jq -e 'any(.[]; .class == "thunderbird")' > /dev/null; then
            hyprctl eval 'local ws = hl.get_active_workspace()
              hl.dispatch(hl.dsp.window.move({ window = "class:^(thunderbird)$", workspace = tostring(ws.id), follow = false }))
              hl.dispatch(hl.dsp.focus({ window = "class:^(thunderbird)$" }))' > /dev/null
            if [ $# -eq 0 ]; then
              exit 0
            fi
          fi
          exec ${thunderbird} "$@"
        '';
      };
    in
    {
      xdg.desktopEntries.thunderbird = lib.mkIf (autoStart && hyprland.enable) {
        name = "Thunderbird";
        genericName = "Email Client";
        icon = "thunderbird";
        exec = "${lib.getExe raise} %u";
        categories = [
          "Network"
          "Email"
        ];
        mimeType = [
          "message/rfc822"
          "x-scheme-handler/mailto"
        ];
      };

      wayland.windowManager.hyprland.settings = lib.mkIf (autoStart && hyprland.enable) {
        # thunderbird has no tray, so it waits in a special workspace instead
        on = lib.singleton {
          _args = [
            "hyprland.start"
            (lua ''
              function()
                hl.exec_cmd("${uwsm}thunderbird", { workspace = "special:mail silent" })
              end'')
          ];
        };
        bind = [ (bind "${mod} + M" ''hl.dsp.workspace.toggle_special("mail")'') ];
      };

      programs.thunderbird = {
        enable = true;
        profiles.default = {
          isDefault = true;
          settings = {
            # auto enable extensions
            "extensions.autoDisableScopes" = 0;
            # the titlebar it draws ignores the theme
            "mail.tabs.drawInTitlebar" = false;
            # migadu puts the catch-all mailbox in delivered-to, the original recipient is in x-envelope-to
            "mail.compose.catchAllHeaders" = "x-envelope-to, envelope-to, x-original-to, to, cc";
          };
        };
      };

      catppuccin.thunderbird.profile = "default";

      accounts.calendar.accounts = lib.mapAttrs (_: path: {
        remote = {
          type = "caldav";
          url = "${radicale}/${path}/";
          userName = "diffy";
        };
        thunderbird.enable = true;
      }) calendars;

      accounts.contact.accounts.Contacts = {
        remote = {
          type = "carddav";
          url = "${radicale}/contacts/";
          userName = "diffy";
        };
        thunderbird.enable = true;
      };

      xdg.mimeApps.defaultApplications."x-scheme-handler/mailto" = "thunderbird.desktop";

      keep.safe.dirs = [ ".thunderbird" ];
    };
}
