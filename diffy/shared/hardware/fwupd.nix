{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "hardware" "fwupd" ] {
  nixos = {
    services.fwupd.enable = true;

    programs.keep.exclude = [ "/etc/fwupd" ];

    keep.safe =
      let
        fwuptDir = "/var/lib/fwupd";
      in
      {
        dirs = [
          # keep-sorted start
          "${fwuptDir}/gnupg"
          "${fwuptDir}/metadata"
          "${fwuptDir}/pki"
          # keep-sorted end
        ];

        files = [ "${fwuptDir}/pending.db" ];
      };
  };
}
