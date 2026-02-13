#!/usr/bin/env bash

state=$(goxlr-client --status-json | jq -r '.mixers | to_entries[0].value.cough_button.state')

if [ "$state" = "Unmuted" ]; then
  goxlr-client cough-button mute-state muted-to-x
elif [ "$state" = "MutedToX" ]; then
  goxlr-client cough-button mute-state unmuted
fi
