{
  lib,
  osConfig,
  ...
}:
lib.mkIf (osConfig.dyad.host == "iodine") {
  dyad.profiles.global.enable = true;
}
