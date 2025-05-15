{pkgs, ...}:
pkgs.writeShellApplication {
  name = "tascam";
  runtimeInputs = with pkgs; [
    jq
    goxlr-utility
  ];
  text = builtins.readFile ./tascam.sh;
}
