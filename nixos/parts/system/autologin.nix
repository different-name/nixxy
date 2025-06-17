{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.nix-files.parts.system.autologin;
in
{
  options.nix-files.parts.system.autologin = {
    enable = lib.mkEnableOption "autologin config";
    user = lib.mkOption {
      description = "User to autologin as";
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    # autologin for tty1 only
    # https://github.com/NixOS/nixpkgs/blob/53e81e790209e41f0c1efa9ff26ff2fd7ab35e27/nixos/modules/services/ttys/getty.nix#L107-L113
    systemd.services."getty@tty1" =
      let
        gettyCfg = config.services.getty;

        baseArgs =
          [
            "--login-program"
            "${gettyCfg.loginProgram}"
            "--autologin"
            cfg.user
          ]
          ++ lib.optionals (gettyCfg.loginOptions != null) [
            "--login-options"
            gettyCfg.loginOptions
          ]
          ++ gettyCfg.extraArgs;

        gettyCmd = args: "@${pkgs.util-linux}/sbin/agetty agetty ${lib.escapeShellArgs baseArgs} ${args}";
      in
      {
        overrideStrategy = "asDropin"; # https://discourse.nixos.org/t/autologin-for-single-tty/49427
        serviceConfig.ExecStart = [
          "" # override upstream default with an empty ExecStart
          (gettyCmd "--noclear --keep-baud %I 115200,38400,9600 $TERM")
        ];
      };
  };
}
