{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "desktop" "hyprlock" ] {
  # hyprlock polls fprintd itself, pam_fprintd would block the password prompt
  nixos.security.pam.services.hyprlock.fprintAuth = false;

  home-manager = { osConfig, ... }: {
    programs.hyprlock = {
      enable = true;

      settings = {
        animations.enabled = false;
        auth.fingerprint.enabled = osConfig.services.fprintd.enable;
      };
    };
  };
}
