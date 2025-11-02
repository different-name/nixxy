{
  lib,
  writeShellApplication,
  curl,
  jq,
}:
writeShellApplication {
  name = "mcuuid";

  runtimeInputs = [
    curl
    jq
  ];

  text = builtins.readFile ./mcuuid.sh;

  meta = {
    description = "A simple script for retrieving UUIDs of Minecraft users";
    maintainers = with lib.maintainers; [ different-name ];
    mainProgram = "mcuuid";
  };
}
