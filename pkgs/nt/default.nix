{
  writeShellApplication,
  runCommand,
  symlinkJoin,
  nh,
  nvfetcher,
  ...
}:
let
  nt = writeShellApplication {
    name = "nt";

    runtimeInputs = [
      nh
      nvfetcher
    ];

    text = builtins.readFile ./nt.sh;

    meta = {
      description = "Nix Tools - A wrapper for nh that runs nvfetcher when updating flake inputs";
      mainProgram = "nt";
    };
  };

  fishCompletions = runCommand "nt-fish-completions" { } ''
    # fish completions
    # zsh and bash completions are excluded because I don't use them to test
    if [ -f "${nh}/share/fish/vendor_completions.d/nh.fish" ]; then
      mkdir -p $out/share/fish/vendor_completions.d

      sed 's/complete -c nh/complete -c nt/g' \
        ${nh}/share/fish/vendor_completions.d/nh.fish \
        > $out/share/fish/vendor_completions.d/nt.fish
    fi
  '';
in
symlinkJoin {
  inherit (nt) name meta;
  paths = [
    nt
    fishCompletions
  ];
}
