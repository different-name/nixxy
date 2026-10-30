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
    tmp=$(mktemp -d)
    trap 'rm -rf "$tmp"' EXIT

    curl -fsSL https://github.com/catppuccin/userstyles/releases/download/all-userstyles-export/import.json \
      > "$tmp/import.json"

    jq --from-file ${./patch.jq} \
      "$tmp/import.json" > "$out"

    echo "wrote $out"
  '';
}
