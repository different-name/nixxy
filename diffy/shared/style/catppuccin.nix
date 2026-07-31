{
  bundleLib,
  inputs,
  self,
  ...
}:
bundleLib.mkEnableModule [ "dyad" "style" "catppuccin" ] {
  nixos = {
    imports = [
      inputs.catppuccin.nixosModules.catppuccin
    ];

    config.catppuccin = {
      enable = true;
      autoEnable = true;
      cache.enable = true;

      accent = "mauve";
      flavor = "mocha";

      fish.enable = false;
    };
  };

  home-manager =
    {
      config,
      osConfig,
      lib,
      ...
    }:
    {
      imports = [
        inputs.catppuccin.homeModules.catppuccin
        self.homeModules.catppuccinGtk
      ];

      options.dyad.palette = lib.mkOption {
        type = lib.types.attrs;
        readOnly = true;
        description = "Parsed catppuccin palette (colours) for config.catppuccin.flavor";
      };

      config = {
        dyad.palette =
          (lib.importJSON (config.catppuccin.sources.palette + /palette.json))
          .${config.catppuccin.flavor}.colors;

        catppuccin = {
          inherit (osConfig.catppuccin)
            enable
            autoEnable
            accent
            flavor
            ;

          # keep-sorted start block=yes
          cursors = {
            inherit (config.catppuccin) enable;
            accent = "dark";
          };
          firefox.enable = false;
          fish.enable = false;
          hyprland.enable = false; # TODO enable when moving to lua hyprland config
          mpv.enable = false;
          zellij.enable = false;
          # keep-sorted end
        };

        home.pointerCursor.enable = config.catppuccin.cursors.enable;
      };
    };
}
