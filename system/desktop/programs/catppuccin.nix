{inputs, ...}: {
  imports = [
    inputs.catppuccin.nixosModules.catppuccin
  ];

  catppuccin = {
    enable = true;
    accent = "red";
    flavor = "mocha";
  };
}
