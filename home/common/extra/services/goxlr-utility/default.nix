{config, ...}: {
  home = {
    file.".local/share/goxlr-utility/mic-profiles/procaster.goxlrMicProfile" = {
      source = ./procaster.goxlrMicProfile;
    };

    persistence."/persist${config.home.homeDirectory}".directories = [
      ".config/goxlr-utility"
      ".local/share/goxlr-utility"
    ];
  };
}
