#!/usr/bin/env bash

if [[ -z $NH_FLAKE ]]; then
  echo "Error: NH_FLAKE environment variable is not defined." >&2
  exit 1
fi

OUTPUT_FILE="${NH_FLAKE}/dyad/home/applications/discord/_moonlight-config.nix"
CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/moonlight-mod/stable.json"

if [[ -f $CONFIG_FILE ]]; then
  echo "Removing $CONFIG_FILE"
  rm "$CONFIG_FILE"
fi

echo "Waiting for Moonlight configuration to be saved"
while [[ ! -f $CONFIG_FILE ]]; do
  sleep 1
done

echo "Updating $OUTPUT_FILE"
nix eval --impure --raw --expr "
  let
    pkgs = import <nixpkgs> {};
    configuration = builtins.fromJSON (builtins.readFile \"${CONFIG_FILE}\");
  in
    pkgs.lib.generators.toPretty { multiline = true; } configuration
" >"$OUTPUT_FILE"

tail -c1 "$OUTPUT_FILE" | read -r _ || echo >>"$OUTPUT_FILE"
