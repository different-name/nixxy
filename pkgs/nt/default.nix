{pkgs, ...}:
pkgs.writeShellApplication {
  name = "nt";
  runtimeInputs = with pkgs; [
    nh
    nvfetcher
  ];
  text = builtins.readFile ./nt.sh;
}
