{
  lib,
  config,
  ...
}:
{
  options.nix-files.parts.system.home-manager.enable = lib.mkEnableOption "home-manager config";

  config = lib.mkIf config.nix-files.parts.system.home-manager.enable {
    # let home-manager manage itself when in standalone mode
    programs.home-manager.enable = true;

    # reload system units when changing configs
    systemd.user.startServices = "sd-switch";
  };
}
