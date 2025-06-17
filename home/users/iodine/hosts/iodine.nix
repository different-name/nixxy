{
  lib,
  config,
  osConfig,
  ...
}: {
  config =
    lib.mkIf (config.nix-files.user == "iodine" && osConfig.nix-files.host == "iodine")
    {
      ### modules

      nix-files = {
        profiles.global.enable = true;
      };

      ### required config

      # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
      home.stateVersion = "24.05";
    };
}
