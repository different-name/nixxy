{config, ...}: let
  user = config.nix-files.user;
in {
  age.secrets.restic-password.file = ../../../secrets/restic/password.age;
  age.secrets.restic-protondrive-rclone-conf.file = ../../../secrets/restic/protondrive/rclone.conf.age;

  services.restic.backups = {
    protonDrive = {
      initialize = true;
      repository = "rclone:protondrive:restic/${config.networking.hostName}";
      passwordFile = config.age.secrets.restic-password.path;
      paths = [
        "/home/${user}/Documents"
      ];
      exclude = [
        ".Trash-1000" # TODO fix trash, don't like having trash folders everywhere
        "/home/${user}/Documents/Avatars"
      ];
      rcloneConfigFile = config.age.secrets.restic-protondrive-rclone-conf.path;
    };
  };

  environment.sessionVariables.RESTIC_PROGRESS_FPS = "15";
}
