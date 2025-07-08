{
  writeShellApplication,
  curl,
  jq,
  ...
}:
writeShellApplication {
  name = "mcuuid";

  runtimeInputs = [
    # keep-sorted start
    curl
    jq
    # keep-sorted end
  ];

  text = builtins.readFile ./mcuuid.sh;

  meta = {
    description = "A simple script for retrieving UUIDs of Minecraft users";
    mainProgram = "mcuuid";
  };
}
