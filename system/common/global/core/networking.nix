{
  networking = {
    networkmanager.enable = true;
    enableIPv6 = false;

    firewall = {
      allowedUDPPorts = [
        # ALVR
        9943
        9944
      ];

      allowedTCPPorts = [
        # ALVR
        9943
        9944
      ];
    };
  };

  environment.persistence."/persist/system".directories = [
    "/etc/NetworkManager/system-connections"
  ];
}
