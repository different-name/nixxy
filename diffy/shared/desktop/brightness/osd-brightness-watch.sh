#!/usr/bin/env bash
# refresh the backend cache on hyprland hotplug (drop on disconnect so a swapped monitor is re-probed)

runtime="${XDG_RUNTIME_DIR:-/tmp}"

# find hyprland's event socket: prefer the instance signature, else glob (normally one)
sock=""
sig="${HYPRLAND_INSTANCE_SIGNATURE:-}"
if [ -n "$sig" ] && [ -S "$runtime/hypr/$sig/.socket2.sock" ]; then
  sock="$runtime/hypr/$sig/.socket2.sock"
fi

tries=0
while [ -z "$sock" ] && [ "$tries" -lt 30 ]; do
  for s in "$runtime"/hypr/*/.socket2.sock; do
    [ -S "$s" ] && sock="$s" && break
  done
  [ -n "$sock" ] && break
  tries=$((tries + 1))
  sleep 1
done

if [ -z "$sock" ]; then
  echo "osd-brightness-watch: hyprland socket2 not found" >&2
  exit 1
fi

socat -u "UNIX-CONNECT:$sock" - | while IFS= read -r line; do
  case "$line" in
  "monitoradded>>"*)
    name="${line#monitoradded>>}"
    osd-brightness-probe "$name"
    ;;
  "monitorremoved>>"*)
    name="${line#monitorremoved>>}"
    rm -f "$runtime/osd-brightness-backend.$name"
    ;;
  esac
done
