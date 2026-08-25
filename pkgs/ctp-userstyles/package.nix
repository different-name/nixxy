{
  writeShellApplication,
  curl,
  jq,
}:
writeShellApplication {
  name = "ctp-userstyles";

  runtimeInputs = [
    curl
    jq
  ];

  text = ''
    out="''${1:-import.json}"

    curl -fsSL https://github.com/catppuccin/userstyles/releases/download/all-userstyles-export/import.json \
      | jq --rawfile gmail ${./gmail.css} --from-file ${./patch.jq} \
      > "$out"

    echo "wrote $out"
  '';
}
