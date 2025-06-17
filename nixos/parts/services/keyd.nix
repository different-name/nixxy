{
  lib,
  config,
  ...
}: {
  options.nix-files.parts.services.keyd.enable = lib.mkEnableOption "keyd config";

  config = lib.mkIf config.nix-files.parts.services.keyd.enable {
    # use keyd -m to find devices & key codes
    services.keyd = {
      enable = true;
      keyboards = {
        ikki68aurora = {
          ids = ["1ea7:7777"];
          settings.main = {
            insert = "print";
          };
        };
      };
    };
  };
}
