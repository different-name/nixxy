{
  lib,
  config,
  osConfig,
  self,
  ...
}:
let
  secretsPath = "syncthing/${osConfig.networking.hostName}";
  keyPath = "${secretsPath}/key";
  certPath = "${secretsPath}/cert";
in
{
  options.dyad.services.syncthing.enable = lib.mkEnableOption "syncthing config";

  config = lib.mkIf config.dyad.services.syncthing.enable {
    services.syncthing = {
      enable = true;
      overrideFolders = false;

      key = config.age.secrets.${keyPath}.path;
      cert = config.age.secrets.${certPath}.path;

      settings.devices = {
        # keep-sorted start
        pico.id = "4EZ7P3H-3G2YWUM-BZDVVN2-7M3OTFZ-IL4KQP5-Z733T66-7CP6J3H-724OCAG";
        potassium.id = "YT3HOI4-76PPKE4-YOQVY7C-ZU7OXSD-JRLQ5TO-G7FDDLN-AUBAVMQ-3YN77AS";
        s23u.id = "E5WSI32-5GJCWWV-RAPUJIP-JSRKN3J-YAGYRAA-SMZ46KZ-4AQMQG6-S3UOIA3";
        sodium.id = "WJRUC4Y-EOM26L3-VRV2UDH-4VDHGOI-UVK2TJZ-BQL5GU7-VLZJOLN-H6HRSAJ";
        # keep-sorted end
      };
    };

    age.secrets = {
      ${keyPath}.file = self + /secrets/${keyPath}.age;
      ${certPath}.file = self + /secrets/${certPath}.age;
    };

    home.perpetual.default.dirs = [
      "$stateHome/syncthing"
    ];
  };
}
