# My setup is ephermeral, including my home directory. As such, I often need to find where new
# applications are storing their configuration. fd works well for this, as we can get a full list
# of files & directories on the system. This can easily become overwhelming due to the quantity
# of results. I have an alias `mao` that ignores directories that are currently persisted by the
# impermanence module, as well as directories listed below that I know I don't want to persist.
# TLDR; I made an alias to list dirs/files that I haven't decided to persist or not persist yet.
{
  lib,
  pkgs,
  config,
  ...
}: let
  exclude = {
    home = [
      ".steam" # using a full mount to persist this, rather than the impermanence module
      ".local/share/Steam" # ^
      ".config/VSCodium" # TODO check if i need this
      ".vscode-oss" # TODO check if i need this
    ];

    root = [
      "/nix"
      "/proc"
      "/sys"
      "/persist"
      "/run"
      "/dev"
      "/tmp"
      "/boot"
      "/var/tmp"
    ];
  };

  exclude-all = {
    home =
      exclude.home
      ++ config.home-manager.users.different.home.persistence."/persist/home/different".directories
      ++ config.home-manager.users.different.home.persistence."/persist/home/different".files;

    root =
      exclude.root
      ++ (
        map
        (dir: dir.directory)
        (config.environment.persistence."/persist/system".directories)
      )
      ++ (
        map
        (file: file.file)
        (config.environment.persistence."/persist/system".files)
      );
  };
in {
  environment.shellAliases = {
    mao =
      # inside joke
      "fd --hidden --type file . /"
      + lib.concatStrings (
        map
        (path: " --exclude \"" + path + "\"")
        (
          exclude-all.root
          ++ (
            map
            (dir: "/home/different/" + dir)
            (exclude-all.home)
          )
        )
      );

    maolite =
      # maolite :tm: only includes home directories
      "fd --hidden --type file . /home/different"
      + lib.concatStrings (
        map
        (path: " --exclude \"" + path + "\"")
        (exclude-all.home)
      );
  };

  environment.systemPackages = [pkgs.fd];
}
