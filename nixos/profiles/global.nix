{
  lib,
  config,
  ...
}: {
  options.nix-files.profiles.global.enable = lib.mkEnableOption "Global profile";

  config = lib.mkIf config.nix-files.profiles.global.enable {
    programs.mosh.enable = true;

    services.fstrim.enable = true;

    nix-files.parts = {
      hardware = {
        fwupd.enable = true;
      };

      nix = {
        nix.enable = true;
        nixpkgs.enable = true;
        substituters.enable = true;
      };

      programs = {
        ephemeral-tools.enable = true;
        fish.enable = true;
        nh.enable = true;
      };

      services = {
        openssh.enable = true;
        tailscale.enable = true;
      };

      system = {
        agenix.enable = true;
        boot.enable = true;
        btrfs.enable = true;
        locale.enable = true;
        networking.enable = true;
        persistence.enable = true;
        security.enable = true;
      };

      theming = {
        catppuccin.enable = true;
      };
    };
  };
}
