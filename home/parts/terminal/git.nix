{
  lib,
  config,
  ...
}: {
  options.nix-files.parts.terminal.git.enable = lib.mkEnableOption "Git config";

  config = lib.mkIf config.nix-files.parts.terminal.git.enable {
    programs.git = {
      enable = true;
      userName = "Different";
      userEmail = "hello@different-name.dev";
      lfs.enable = true;
    };
  };
}
