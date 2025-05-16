{pkgs, ...}:
pkgs.writeShellApplication {
  name = "mcuuid";
  runtimeInputs = with pkgs; [
    curl
    jq
  ];
  text = builtins.readFile ./mcuuid.sh;
}
