{
  security = {
    rtkit.enable = true;

    sudo = {
      # Don't ask for password for wheel group
      wheelNeedsPassword = false;

      extraConfig = ''
        Defaults lecture=never # don't give the sudo lecture
      '';
    };

    polkit = {
      enable = true;
      # Allow non root users to use reboot and poweroff commands
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
}
