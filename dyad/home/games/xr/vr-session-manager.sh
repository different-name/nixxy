#!/usr/bin/env bash

usage() {
  echo "Usage: ${0##*/} [start|stop]"
  exit 1
}

if [[ -z ${1+x} ]]; then
  usage
fi

ACTION="$1"
SERVICE="vr-session.service"
NOTIFY_TIME="5000"

if [ "$ACTION" = "start" ]; then
  # __ENTER_VR_HOOK__
  if systemctl --user restart "$SERVICE"; then
    notify-send -t "$NOTIFY_TIME" "VR Session" "VR session started successfully"
  else
    # __EXIT_VR_HOOK__
    notify-send -t "$NOTIFY_TIME" "VR Session" "Failed to start VR session" -u critical
    exit 2
  fi
elif [ "$ACTION" = "stop" ]; then
  # __EXIT_VR_HOOK__
  if systemctl --user stop "$SERVICE"; then
    notify-send -t "$NOTIFY_TIME" "VR Session" "VR session stopped successfully"
  else
    notify-send -t "$NOTIFY_TIME" "VR Session" "Failed to stop VR session" -u critical
    exit 2
  fi
fi

usage
