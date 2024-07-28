{inputs, ...}: {
  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
    firewall.enable = false;
  };

  environment.persistence."/persist/system".directories = [
    "/etc/NetworkManager/system-connections"
  ];
}
