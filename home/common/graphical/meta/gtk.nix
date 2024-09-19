{
  lib,
  config,
  ...
}: {
  options.nix-files.graphical.meta.gtk.enable = lib.mkEnableOption "GTK config";

  config = lib.mkIf config.nix-files.graphical.meta.gtk.enable {
    gtk = {
      enable = true;

      # this theme is no longer in development
      catppuccin = {
        enable = true;
        flavor = "mocha";
        accent = "red";
        size = "standard";
        tweaks = ["normal"];
        icon.enable = true;
      };
    };
  };
}
