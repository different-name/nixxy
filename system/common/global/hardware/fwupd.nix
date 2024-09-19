{
  services.fwupd.enable = true;

  environment.persistence."/persist/system" = {
    directories = map (path: "/var/lib/fwupd/${path}") [
      "metadata"
      "gnupg"
      "pki"
    ];

    files = map (path: "/var/lib/fwupd/${path}") [
      "pending.db"
    ];
  };
}
