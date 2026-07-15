{
  bundleLib,
  inputs,
  inputs',
  ...
}:
let
  spicePkgs = inputs'.spicetify-nix.legacyPackages;
in
bundleLib.mkEnableModule [ "dyad" "applications" "spotify" ] {
  home-manager = {
    imports = [
      inputs.spicetify-nix.homeManagerModules.spicetify
    ];

    programs.spicetify = {
      enable = true;
      enabledExtensions = with spicePkgs.extensions; [
        adblock
        groupSession
      ];
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";
    };

    xdg.mimeApps.defaultApplications."x-scheme-handler/spotify" = "spotify.desktop";

    home.perpetual.default.dirs = [
      "$configHome/spotify"
      "$cacheHome/spotify"
    ];
  };
}
