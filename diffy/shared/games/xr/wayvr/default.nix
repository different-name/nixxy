{ lib, config, ... }: {
  config = lib.mkIf config.dyad.games.xr.enable {
    nixos = { pkgs, ... }: {
      systemd.user.services.wayvr = {
        description = "wayvr";
        after = [ "wivrn.service" ];
        requires = [ "wivrn.service" ];
        partOf = [ "wivrn.service" ];

        serviceConfig = {
          ExecStart = "${lib.getExe pkgs.wayvr} --openxr --replace";
          Restart = "on-failure";
        };
      };
    };

    home-manager = { config, pkgs, ... }: {
      home.packages = [ pkgs.wayvr ];

      keep.safe = {
        cacheDirs = [ "wayvr" ];
        configDirs = [ "wayvr" ];
      };

      # https://github.com/wlx-team/wayvr/wiki/Customization
      xdg.configFile = {
        "wayvr/openxr_actions.json5" = {
          source = ./openxr_actions.json5;
          force = true;
        };

        "wayvr/palettes/catppuccin.json".text =
          let
            inherit (config.dyad) palette;
            inherit (config.catppuccin) accent;
            hex = name: palette.${name}.hex;
          in
          lib.toJSON {
            primary = hex accent;
            on_primary = hex "crust";
            secondary = hex "peach";
            on_secondary = hex "crust";
            tertiary = hex "teal";
            on_tertiary = hex "crust";
            danger = hex "red";
            on_danger = hex "crust";
            background = hex "base";
            on_background = hex "text";
            background_variant = hex "surface0";
            on_background_variant = hex "subtext0";
            background_contrast = hex "mantle";
            on_background_contrast = hex "text";
            outline = hex "surface2";
            shadow = hex "crust";
            highlight = hex "text";
          };

        # sorts after the dashboard's zz-saved-config.json5, which would otherwise win
        "wayvr/conf.d/zzz-nix.json5".text = lib.toJSON {
          color_palette = "catppuccin.json";
          ui_gradient_intensity = 0.0;
        };
      };
    };
  };
}
