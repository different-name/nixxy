{ lib, config, ... }:
{
  options.nix-files.parts.system.security.enable = lib.mkEnableOption "security config";

  config = lib.mkIf config.nix-files.parts.system.security.enable {
    security = {
      rtkit.enable = true;

      sudo.extraConfig = ''
        Defaults lecture=never # don't give the sudo lecture
        Defaults timestamp_timeout=190 # increase timeout to 3 hours
      '';

      polkit = {
        enable = true;
        # allow non root users to use reboot and poweroff commands
        extraConfig = ''
          polkit.addRule(function(action, subject) {
            if (
              subject.isInGroup("users")
                && (
                  action.id == "org.freedesktop.login1.reboot" ||
                  action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
                  action.id == "org.freedesktop.login1.power-off" ||
                  action.id == "org.freedesktop.login1.power-off-multiple-sessions"
                )
              )
            {
              return polkit.Result.YES;
            }
          })
        '';
      };
    };
  };
}
