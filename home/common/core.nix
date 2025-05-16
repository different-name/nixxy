{
  lib,
  config,
  ...
}: {
  options.nix-files.core.enable = lib.mkEnableOption "Core home config";

  config = lib.mkIf config.nix-files.core.enable {
    # let home-manager manage itself when in standalone mode
    programs.home-manager.enable = true;

    # reload system units when changing configs
    systemd.user.startServices = "sd-switch";
  };
}
