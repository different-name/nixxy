{
  services.tailscale.enable = true;

  environment.persistence."/persist/system".directories = [
    "/var/lib/tailscale"
  ];
}
