{config, lib, ...}: let
  cfg = config.nix-files;
in {
  options.nix-files = {
    user = lib.mkOption {
      description = ''
        Username of the system user
      '';
      type = lib.types.str;
      example = lib.literalExample "nerowy";
      default = "different";
    };

    xDisplayScale = {
      enable = lib.mkOption {
        description = ''
          If enabled, fractional scaling will be passed to x applications
          through their respective environmental variables
        '';
        type = lib.types.bool;
        default = false;
      };

      value = lib.mkOption {
        description = ''
          Scaling value
        '';
        type = lib.types.str;
        example = lib.literalExample "1.5";
        default = "1";
      };
    };
  };

  config = {
    environment.sessionVariables = lib.mkIf cfg.xDisplayScale.enable {
      STEAM_FORCE_DESKTOPUI_SCALING = cfg.xDisplayScale.value;
      GDK_SCALE = cfg.xDisplayScale.value;
    };
  };
}
