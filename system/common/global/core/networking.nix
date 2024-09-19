{
  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;

    firewall = {
      allowedUDPPorts = [];
      allowedTCPPorts = [];
    };
  };

  environment.persistence."/persist/system" = {
    directories = [
      "/etc/NetworkManager/system-connections"
    ];
  };
}
