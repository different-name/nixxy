#!/usr/bin/env bash

# if wayvr is running, wait a short time and check if it is requesting the screen
if systemctl --user is-active --quiet wayvr.service; then
  sleep 0.5 # adjust as needed

  # get the second last log line, as wayvr adds traces after each log entry
  WLX_OVERLAY_S_LOG=$(journalctl --user -u wayvr.service --no-pager -n 2 | head -n 1)

  # use regex to extract the desired output name e.g. HDMI-A-1
  if [[ $WLX_OVERLAY_S_LOG =~ Now\ select:\ ([^[:space:]]+) ]]; then
    DISPLAY_SELECTION="${BASH_REMATCH[1]}"
    exec echo "[SELECTION]/screen:$DISPLAY_SELECTION"
  fi
fi

# fallback to original picker if wayvr isn't waiting for picker
exec hyprland-share-picker "$@"
