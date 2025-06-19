{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
{
  options.nix-files.parts.programs.nh.enable = lib.mkEnableOption "nh config";

  config = lib.mkIf config.nix-files.parts.programs.nh.enable {
    # nh is a nix cli helper, useful for rebuilding & cleaning
    programs.nh = {
      enable = true;
      package = inputs.self.packages.${pkgs.system}.nt.override {
        nh = inputs.nh.packages.${pkgs.system}.nh;
      };

      # weekly garbage collection
      clean = {
        enable = true;
        # keep configs from last 30 days
        extraArgs = "--keep-since 30d";
      };
    };
  };
}
