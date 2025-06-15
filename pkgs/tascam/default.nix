{pkgs, ...}:
pkgs.writeShellApplication {
  name = "tascam";

  runtimeInputs = with pkgs; [
    jq
    goxlr-utility
  ];

  text = builtins.readFile ./tascam.sh;

  meta = {
    description = "A personal shell script that toggles routing audio through my Tascam from my GoXLR";
    mainProgram = "tascam";
  };
}
