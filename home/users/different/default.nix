{
  lib,
  config,
  ...
}: {
  config = lib.mkIf (config.nix-files.user == "different") {
    home = {
      username = "different";
      homeDirectory = "/home/${config.home.username}";
    };
  };
}
