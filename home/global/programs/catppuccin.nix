{inputs, osConfig, ...}: {
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  catppuccin = {
    inherit (osConfig.catppuccin) enable accent flavor;
    pointerCursor = {
      inherit (osConfig.catppuccin) flavor;
      enable = true;
      accent = "dark";
    };
  };
}
