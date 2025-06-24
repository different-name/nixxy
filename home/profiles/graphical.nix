{
  lib,
  config,
  ...
}:
{
  options.nix-files.profiles.graphical.enable = lib.mkEnableOption "graphical profile";

  config = lib.mkIf config.nix-files.profiles.graphical.enable {
    programs.mpv.enable = true;
    programs.zathura.enable = true;

    services.playerctld.enable = true;

    gtk.enable = true;

    nix-files.parts = {
      applications = {
        extra-packages.enable = true;

        blender.enable = true;
        discord.enable = true;
        firefox.enable = true;
        kitty.enable = true;
        obsidian.enable = true;
        # TODO disabled until https://github.com/NixOS/nixpkgs/issues/418451 is closed
        # unity.enable = true;
        vscodium.enable = true;
      };

      desktop = {
        extra-packages.enable = true;

        anyrun.enable = true;
        hyprland.enable = true;
        hyprlock.enable = true;
        hyprpaper.enable = true;
        mako.enable = true;
        qt.enable = true;
        xdg.enable = true;
      };

      games = {
        extra-packages.enable = true;

        steam.enable = true;
      };

      media = {
        extra-packages.enable = true;

        goxlr-utility.enable = true;
        imv.enable = true;
        mpv.enable = true;
        obs.enable = true;
      };

      system = {
        persistence.directories = [
          "Code"
          "Documents"
          "Downloads"
          "Pictures"
          "Videos"
          "Media"
        ];
      };
    };
  };
}
