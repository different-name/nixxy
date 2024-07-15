{
  pkgs,
  config,
  ...
}: {
  nix-files.user = "different";

  users.users.${config.nix-files.user} = {
    password = "nixos"; # TODO agenix
    isNormalUser = true;
    shell = pkgs.fish; # TODO check if I need this

    openssh.authorizedKeys.keys = [
      # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
    ];

    extraGroups = [
      "wheel"
      "audio"
      "video"
      "input"
      "networkmanager"
      "libvirtd"
    ];
  };

  services.getty.autologinUser = config.nix-files.user;
}
