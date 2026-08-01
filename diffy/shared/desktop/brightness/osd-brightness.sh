#!/usr/bin/env bash
# adjusts the monitor under the cursor: internal=backlight, external=ddc/ci else software gamma

dir="${1:-show}"

STEP_BL=5     # internal backlight, percent
STEP_DDC=10   # external DDC/CI, percent
STEP_GAMMA=5  # external software gamma, percent of the *display* scale
MIN_GAMMA=0.1 # gamma floor (below this is unusably dark), [MIN_GAMMA,1.0] maps onto 1-100%

# drop overlapping invocations (don't queue) so a held key can't pile up on a slow backend
exec 9>"${XDG_RUNTIME_DIR:-/tmp}/osd-brightness.lock"
flock -n 9 || exit 0

pos="$(hyprctl cursorpos)" # "x, y"
cx="${pos%%,*}"
cx="${cx// /}"
cy="${pos##*,}"
cy="${cy// /}"
mons="$(hyprctl monitors -j)"

# logical rect is (x,y)..(x+w/scale, y+h/scale), w/h swapped for 90/270 rotations (odd .transform)
name="$(
  jq -r --argjson x "${cx:-0}" --argjson y "${cy:-0}" '
    map(select(
      ((((.transform // 0) % 2) == 1)) as $rot |
      (if $rot then .height else .width end) as $w |
      (if $rot then .width else .height end) as $h |
      $x >= .x and $x < (.x + ($w / .scale)) and
      $y >= .y and $y < (.y + ($h / .scale))
    )) | (.[0].name // "")
  ' <<<"$mons"
)"
# cursor hit nothing -> focused monitor
if [ -z "$name" ]; then
  name="$(jq -r 'map(select(.focused))[0].name // ""' <<<"$mons")"
fi
[ -z "$name" ] && exit 0

osd() { # $1: progress 0..1   $2: label text
  swayosd-client --custom-icon display-brightness-symbolic \
    --custom-progress "$1" --custom-progress-text "$2" --monitor "$name"
}

case "$name" in
eDP-* | LVDS-* | DSI-*)
  # clamp the target before setting (floor 1%, ceil 100%) so it never dips to 0 / black
  cur="$(brightnessctl -m info | awk -F, '{ gsub(/%/, "", $4); print $4 }')"
  cur="${cur:-0}"
  case "$dir" in
  # snap to the STEP grid so leaving the 1% floor realigns to 5,10,15,...
  up)
    pct=$(((cur / STEP_BL + 1) * STEP_BL))
    [ "$pct" -gt 100 ] && pct=100
    ;;
  down)
    pct=$(((cur - 1) / STEP_BL * STEP_BL))
    [ "$pct" -lt 1 ] && pct=1
    ;;
  *) pct="$cur" ;;
  esac
  [ "$dir" = show ] || brightnessctl -m set "$pct%" >/dev/null
  osd "$(awk -v p="$pct" 'BEGIN { print p / 100 }')" "$pct%"
  ;;

*)
  # read the prober's cached backend, probing now if it hasn't run for this monitor yet (fresh hotplug)
  cache="${XDG_RUNTIME_DIR:-/tmp}/osd-brightness-backend.$name"
  # -s not -r: an empty cache (mid-write, or probe wrote nothing) must re-probe, not read as empty backend
  [ -s "$cache" ] || osd-brightness-probe "$name"
  backend="$(cat "$cache" 2>/dev/null || true)"
  [ -n "$backend" ] || backend="gamma"

  case "$backend" in
  ddc:*)
    bus="${backend#ddc:}"
    # ddc/ci writes are flaky (transient i2c nak), so tolerate a failed setvcp under set -e
    case "$dir" in
    up) ddcutil --bus "$bus" setvcp 10 + "$STEP_DDC" || true ;;
    down) ddcutil --bus "$bus" setvcp 10 - "$STEP_DDC" || true ;;
    esac
    # ddc/ci reads are flaky, so only show the osd on a parsed value (a failed read as 0 flashes a bogus 0%)
    if read -r cur max < <(
      ddcutil --bus "$bus" getvcp 10 |
        awk -F'[=,]' '/current value/ { gsub(/[^0-9]/, "", $2); gsub(/[^0-9]/, "", $4); print $2, $4 }'
    ) && [ -n "$cur" ]; then
      osd "$(awk -v c="$cur" -v m="${max:-100}" 'BEGIN { print c / m }')" "$cur%"
    fi
    ;;

  gamma)
    path="/outputs/${name//-/_}"
    iface="rs.wl.gammarelay"
    # tolerate the gamma service/output not being up yet, ${cur:-1} treats a missing read as full brightness
    cur="$(busctl --user get-property rs.wl-gammarelay "$path" "$iface" Brightness 2>/dev/null | awk '{ print $2 }' || true)"
    # work in display-percent [1,100] so steps match the other backends, then map onto [MIN_GAMMA,1.0]
    disp="$(awk -v b="${cur:-1}" -v lo="$MIN_GAMMA" 'BEGIN { printf "%.0f", 1 + (b - lo) / (1 - lo) * 99 }')"
    case "$dir" in
    # snap to the STEP grid so leaving the 1% floor realigns to 5,10,15,...
    up)
      disp=$(((disp / STEP_GAMMA + 1) * STEP_GAMMA))
      [ "$disp" -gt 100 ] && disp=100
      ;;
    down)
      disp=$(((disp - 1) / STEP_GAMMA * STEP_GAMMA))
      [ "$disp" -lt 1 ] && disp=1
      ;;
    esac
    nb="$(awk -v d="$disp" -v lo="$MIN_GAMMA" 'BEGIN { printf "%.3f", lo + (d - 1) / 99 * (1 - lo) }')"
    # same not-ready tolerance as the guarded read above
    [ "$dir" = show ] || busctl --user set-property rs.wl-gammarelay "$path" "$iface" Brightness d "$nb" || true
    osd "$(awk -v d="$disp" 'BEGIN { print d / 100 }')" "$disp%"
    ;;
  esac
  ;;
esac
