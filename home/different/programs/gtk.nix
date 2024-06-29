{ config, pkgs, lib, ... }: {
  gtk = {
    enable = true;

    # this theme is no longer in development
    catppuccin = {
      enable = true;
      flavor = "mocha";
      accent = "red";
      size = "standard";
      tweaks = [ "normal" ];
    };
  };
}