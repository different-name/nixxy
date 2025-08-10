#!/usr/bin/env bash

if [[ -z ${1+x} ]]; then
  echo "Usage: ${0##*/} <minecraft username>"
  exit 1
fi

USERNAME="$1"
RESPONSE=$(curl -s "https://api.mojang.com/users/profiles/minecraft/${USERNAME}")
UUID=$(echo "$RESPONSE" | jq -r '.id // empty')

if [[ -z $UUID ]]; then
  ERROR=$(echo "$RESPONSE" | jq -r '.errorMessage // empty')

  if [[ -z $ERROR ]]; then
    echo "Unknown API response"
    exit 1
  fi

  echo "$ERROR"
  exit 2
fi

echo "$UUID"
