{
  lib,
  config,
  inputs,
  inputs',
  self,
  ...
}:
{
  options.dyad.style.catppuccin.enable = lib.mkEnableOption "catppuccin config";

  config = lib.mkIf config.dyad.style.catppuccin.enable {
    nixos = {
      imports = [
        inputs.catppuccin.nixosModules.catppuccin
      ];

      config.catppuccin = {
        enable = true;
        cache.enable = true;

        accent = "red";
        flavor = "mocha";

        sources.limine = inputs'.catppuccin.packages.limine.overrideAttrs (oldAttrs: {
          postPatch = (oldAttrs.postPach or "") + ''
            substituteInPlace "themes/catppuccin-mocha.conf" \
              --replace-fail "a6e3a1" "cba6f7" \
              --replace-fail "94e2d5" "cba6f7"
          '';
        });
      };
    };

    hm =
      { osConfig, ... }:
      {
        imports = [
          inputs.catppuccin.homeModules.catppuccin
          self.homeModules.catppuccinGtk
        ];

        config.catppuccin = {
          inherit (osConfig.catppuccin) enable accent flavor;

          # keep-sorted start block=yes
          cursors = {
            inherit (config.catppuccin) enable;
            accent = "dark";
          };
          fish.enable = false;
          librewolf.enable = false;
          mpv.enable = false;
          yazi.accent = "mauve";
          zellij.enable = false;
          # keep-sorted end
        };
      };
  };
}
