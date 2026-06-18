{
  bundleLib,
  inputs,
  inputs',
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
      cache.enable = true;

      accent = "mauve";
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

  home-manager =
    { config, osConfig, ... }:
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
        firefox.enable = false;
        fish.enable = false;
        mpv.enable = false;
        zellij.enable = false;
        # keep-sorted end
      };
    };
}
