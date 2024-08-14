{
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  home.persistence."/persist${config.home.homeDirectory}" = {
    directories = [
      "nix-files"
      ".ssh"
      ".cache"
      ".local/share/Trash"
      ".local/share/fish"
      ".config/qalculate"
      ".local/share/qalculate"
    ];
    files = [];
    allowOther = true;
  };
}
