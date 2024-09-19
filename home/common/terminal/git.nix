{
  lib,
  config,
  ...
}: {
  options.nix-files.terminal.git.enable = lib.mkEnableOption "Git config";

  config = lib.mkIf config.nix-files.terminal.git.enable {
    programs.git = {
      enable = true;
      userName = "Different";
      userEmail = "hello@different-name.dev";
    };
  };
}
