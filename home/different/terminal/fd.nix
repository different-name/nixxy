{
  config,
  osConfig,
  ...
}: {
  programs.fd = {
    enable = true;
    # extraOptions = ["-H"];
    # ignores =
    #   [
    #     "/nix"
    #     "/proc"
    #     "/sys"
    #     "/persist"
    #     "/run"
    #     "/dev"
    #     "/tmp"
    #     "/boot"
    #     "/var/tmp"
    #     "/home/different/.steam"
    #     "/home/different/.local/share/Steam"
    #   ]
    #   ++ (map (dir: "/home/different/" + dir) config.home.persistence."/persist/home/different".directories)
    #   ++ (map (dir: dir.directory) osConfig.environment.persistence."/persist/system".directories);
  };
}
