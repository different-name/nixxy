{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "services" "gnome-keyring" ] {
  nixos.services.gnome.gnome-keyring.enable = true;

  # keyrings are created with an empty password, tty autologin leaves nothing to unlock them with
  home-manager.keep.safe.dataDirs = [ "keyrings" ];
}
