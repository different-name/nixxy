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

    files = [
      "/var/lib/NetworkManager/timestamps"
      "/var/lib/NetworkManager/secret_key"
    ];
  };
}
