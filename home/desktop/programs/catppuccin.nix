{inputs, ...}: {
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  catppuccin = {
    enable = true;
    accent = "red";
    flavor = "mocha";
    pointerCursor = {
      enable = true;
      flavor = "mocha";
      accent = "dark";
    };
  };

  programs.btop.catppuccin.enable = true;
  programs.fish.catppuccin.enable = false;
}
