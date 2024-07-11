{inputs, ...}: {
  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
    firewall.enable = false;
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };
}
