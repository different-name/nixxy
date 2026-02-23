{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "services" "openssh" ] {
  nixos = {
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

    environment.perpetual.default.dirs = [
      "/etc/ssh"
      "/root/.ssh"
    ];
  };

  home-manager.home.perpetual.default.dirs = [
    ".ssh"
  ];
}
