{ pkgs, ... }:
let
  nt = pkgs.writeShellApplication {
    name = "nt";

    runtimeInputs = with pkgs; [
      nh
      nvfetcher
    ];

    text = builtins.readFile ./nt.sh;

    meta = {
      description = "Nix Tools - A wrapper for nh that runs nvfetcher when updating flake inputs";
      mainProgram = "nt";
    };
  };

  fishCompletions = pkgs.runCommand "nt-fish-completions" { } ''
    # fish completions
    # zsh and bash completions are excluded because I don't use them to test
    if [ -f "${pkgs.nh}/share/fish/vendor_completions.d/nh.fish" ]; then
      mkdir -p $out/share/fish/vendor_completions.d

      sed 's/complete -c nh/complete -c nt/g' \
        ${pkgs.nh}/share/fish/vendor_completions.d/nh.fish \
        > $out/share/fish/vendor_completions.d/nt.fish
    fi
  '';
in
pkgs.symlinkJoin {
  inherit (nt) name meta;
  paths = [
    nt
    fishCompletions
  ];
}
