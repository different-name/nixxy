usage() {
  echo "Usage: ${0##*/} [start|stop]"
  exit 1
}

if [[ -z "${1+x}" ]]; then
  usage
fi

ACTION="$1"
SERVICE="vr-session.service"
NOTIFY_TIME="5000"

if [ "$ACTION" = "start" ]; then
  if systemctl --user start "$SERVICE"; then
    notify-send -t "$NOTIFY_TIME" "VR Session" "VR session started successfully"
  else
    notify-send -t "$NOTIFY_TIME" "VR Session" "Failed to start VR session" -u critical
    exit 2
  fi
elif [ "$ACTION" = "stop" ]; then
  if systemctl --user stop "$SERVICE"; then
    notify-send -t "$NOTIFY_TIME" "VR Session" "VR session stopped successfully"
  else
    notify-send -t "$NOTIFY_TIME" "VR Session" "Failed to stop VR session" -u critical
    exit 2
  fi
fi

usage