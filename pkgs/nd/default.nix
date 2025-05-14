{pkgs, ...}:
pkgs.writeShellApplication {
  name = "nd";
  runtimeInputs = with pkgs; [
    nh
    nvfetcher
  ];
  text = builtins.readFile ./nd.sh;
}
