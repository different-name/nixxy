{inputs, ...}: {
  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;
    firewall.enable = false;
  };
}
