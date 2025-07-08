{ lib, config, ... }:
let
  inherit (lib) types;
  cfg = config.dyad.services.syncthing;
in
{
  options.dyad.services.syncthing = {
    enable = lib.mkEnableOption "syncthing config";

    user = lib.mkOption {
      type = types.str;
      description = "User to run syncthing as";
      example = "different";
    };

    key = lib.mkOption {
      type = types.path;
      description = "Path to key file";
    };

    cert = lib.mkOption {
      type = types.path;
      description = "Path to cert file";
    };
  };

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      inherit (cfg)
        user
        key
        cert
        ;

      enable = true;

      openDefaultPorts = true;
      overrideFolders = false;
      group = "users";
      dataDir = "/home/${cfg.user}";

      settings.devices = {
        # keep-sorted start
        pico.id = "4EZ7P3H-3G2YWUM-BZDVVN2-7M3OTFZ-IL4KQP5-Z733T66-7CP6J3H-724OCAG";
        potassium.id = "YT3HOI4-76PPKE4-YOQVY7C-ZU7OXSD-JRLQ5TO-G7FDDLN-AUBAVMQ-3YN77AS";
        s23u.id = "E5WSI32-5GJCWWV-RAPUJIP-JSRKN3J-YAGYRAA-SMZ46KZ-4AQMQG6-S3UOIA3";
        sodium.id = "WJRUC4Y-EOM26L3-VRV2UDH-4VDHGOI-UVK2TJZ-BQL5GU7-VLZJOLN-H6HRSAJ";
        # keep-sorted end
      };
    };

    # don't create default ~/Sync folder
    systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";
  };
}
