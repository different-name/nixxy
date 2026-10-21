{ bundleLib, inputs', ... }:
bundleLib.mkEnableModule [ "dyad" "desktop" "vicinae" ] {
  home-manager = { pkgs, ... }: {
    programs.vicinae = {
      enable = true;
      package = pkgs.vicinae;

      systemd.enable = true;

      extensions = with inputs'.vicinae-extensions.packages; [
        hyprland-monitors
        nix
      ];

      settings = {
        close_on_focus_loss = false;

        launcher_window.compact_mode.enabled = true;

        providers = {
          applications.preferences.launchPrefix = "uwsm app -- ";

          "@knoopx/nix-0".entrypoints = {
            flake-packages.enabled = false;
          };

          core.entrypoints = {
            keybind-settings.enabled = false;
            report-bug.enabled = false;
            sponsor.enabled = false;
          };

          manage-shortcuts.enabled = false;
          theme.enabled = false;
          developer.enabled = false;
        };
      };
    };

    keep.persist = {
      xdg.cache.dirs."vicinae" = { };
      xdg.data.dirs."vicinae" = { };
      xdg.state.dirs."vicinae" = { };
    };
  };
}
