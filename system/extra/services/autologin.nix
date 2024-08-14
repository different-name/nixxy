user: {
  config,
  pkgs,
  lib,
  ...
}: {
  # Autologin for tty1 only
  # https://github.com/NixOS/nixpkgs/blob/53e81e790209e41f0c1efa9ff26ff2fd7ab35e27/nixos/modules/services/ttys/getty.nix#L107-L113
  systemd.services."getty@tty1" = let
    cfg = config.services.getty;

    baseArgs =
      [
        "--login-program"
        "${cfg.loginProgram}"
        "--autologin"
        user
      ]
      ++ lib.optionals (cfg.loginOptions != null) [
        "--login-options"
        cfg.loginOptions
      ]
      ++ cfg.extraArgs;

    gettyCmd = args: "@${pkgs.util-linux}/sbin/agetty agetty ${lib.escapeShellArgs baseArgs} ${args}";
  in {
    overrideStrategy = "asDropin"; # https://discourse.nixos.org/t/autologin-for-single-tty/49427
    serviceConfig.ExecStart = [
      "" # override upstream default with an empty ExecStart
      (gettyCmd "--noclear --keep-baud %I 115200,38400,9600 $TERM")
    ];
  };
}
