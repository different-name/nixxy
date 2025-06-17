{
  lib,
  config,
  ...
}: {
  config = lib.mkIf (config.nix-files.user == "iodine") {
    home = {
      username = "iodine";
      homeDirectory = "/home/${config.home.username}";
    };
  };
}
