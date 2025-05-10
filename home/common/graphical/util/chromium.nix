{
  lib,
  config,
  ...
}: {
  options.nix-files.graphical.util.chromium.enable = lib.mkEnableOption "Chromium config";

  config = lib.mkIf config.nix-files.graphical.util.chromium.enable {
    programs.chromium = {
      enable = true;
      extensions = [
        {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # ublock origin
        {id = "cbghhgpcnddeihccjmnadmkaejncjndb";} # vencord
      ];
    };

    home.persistence."/persist${config.home.homeDirectory}" = lib.mkIf config.nix-files.persistence.enable {
      directories = [
        ".cache/chromium"
        ".config/chromium"
      ];
    };
  };
}
