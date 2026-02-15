{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "terminal" "distrobox" ] {
  nixos =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.distrobox
      ];

      virtualisation.podman.enable = true;
    };

  home-manager.home.perpetual.default.dirs = [
    "$dataHome/containers"
  ];
}
