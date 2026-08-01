#!/usr/bin/env bash
# probe external monitors for ddc/ci, caching the backend per monitor as "ddc:<bus>" or "gamma"
# (reads sysfs, not hyprland, so it's safe to run before the compositor is up)

target="${1:-}"
runtime="${XDG_RUNTIME_DIR:-/tmp}"

probe_one() {
  name="$1"
  card="$2"

  bus=""
  for d in "$card"/ddc/i2c-dev/i2c-*; do
    [ -e "$d" ] || continue
    bus="$(basename "$d")"
    bus="${bus#i2c-}"
    break
  done

  # write atomically (temp + mv same dir) so a concurrent read never sees a half-written cache
  cache="$runtime/osd-brightness-backend.$name"
  tmp="$(mktemp "$cache.XXXXXX")"
  if [ -n "$bus" ] && timeout 5 ddcutil --bus "$bus" getvcp 10 >/dev/null 2>&1; then
    printf '%s' "ddc:$bus" >"$tmp"
  else
    printf '%s' "gamma" >"$tmp"
  fi
  mv -f "$tmp" "$cache"
}

for card in /sys/class/drm/card*-*; do
  [ -e "$card/status" ] || continue

  base="$(basename "$card")"
  name="${base#card*-}"

  case "$name" in
  eDP-* | LVDS-* | DSI-*) continue ;; # internal panels use the backlight
  esac

  [ -n "$target" ] && [ "$name" != "$target" ] && continue
  [ "$(cat "$card/status")" = "connected" ] || continue

  probe_one "$name" "$card"
done
