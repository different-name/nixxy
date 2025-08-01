{
  lib,
  config,
  inputs,
  inputs',
  ...
}:
{
  imports = [
    inputs.catppuccin.nixosModules.catppuccin
  ];

  options.dyad.style.catppuccin.enable = lib.mkEnableOption "catppuccin config";

  config = lib.mkIf config.dyad.style.catppuccin.enable {
    catppuccin = {
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
}
