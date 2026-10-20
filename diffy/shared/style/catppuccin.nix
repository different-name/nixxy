{
  bundleLib,
  config,
  lib,
  inputs,
  self,
  ...
}:
let
  accent = "mauve";
  flavor = "mocha";
in
{
  # palette is read by modules that do not theme with catppuccin
  home-manager = lib.mkIf config.dyad.users.diffy.enable (
    { config, lib, ... }: {
      imports = [ inputs.catppuccin.homeModules.catppuccin ];

      options.dyad.palette = lib.mkOption {
        type = lib.types.attrs;
        readOnly = true;
        description = "Parsed catppuccin palette (colours) for config.catppuccin.flavor";
      };

      config = {
        catppuccin = { inherit accent flavor; };

        dyad.palette =
          (lib.importJSON (config.catppuccin.sources.palette + /palette.json))
          .${config.catppuccin.flavor}.colors;
      };
    }
  );

  imports = lib.singleton (
    bundleLib.mkEnableModule [ "dyad" "style" "catppuccin" ] {
      nixos = {
        imports = [ inputs.catppuccin.nixosModules.catppuccin ];

        config.catppuccin = {
          enable = true;
          autoEnable = true;
          cache.enable = true;

          inherit accent flavor;

          fish.enable = false;
        };
      };

      home-manager =
        {
          config,
          osConfig,
          lib,
          pkgs,
          ...
        }:
        {
          imports = [ self.homeModules.catppuccinGtk ];

          config = {
            catppuccin = {
              inherit (osConfig.catppuccin) enable autoEnable;

              # keep-sorted start block=yes
              cursors = {
                inherit (config.catppuccin) enable;
                accent = "dark";
              };
              firefox.enable = false;
              fish.enable = false;
              kvantum.assertStyle = false;
              mpv.enable = false;
              qt5ct.enable = true;
              zellij.enable = false;
              # keep-sorted end
            };

            home.pointerCursor.enable = config.catppuccin.cursors.enable;

            # copied rather than linked, kde apps write to kdeglobals
            home.activation.catppuccinKdeglobals =
              let
                kde = pkgs.catppuccin-kde.override {
                  flavour = [ config.catppuccin.flavor ];
                  accents = [ config.catppuccin.accent ];
                };
              in
              lib.hm.dag.entryAfter [ "writeBoundary" ] ''
                run install -Dm644 ${kde}/share/color-schemes/*.colors "${config.xdg.configHome}/kdeglobals"
              '';
          };
        };
    }
  );
}
