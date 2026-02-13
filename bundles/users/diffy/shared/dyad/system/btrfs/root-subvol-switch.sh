#!/usr/bin/env bash

mkdir -p /btrfs
mount -t btrfs -o subvol=/ "$ROOT_DEVICE" /btrfs

if [[ -e /btrfs/root/current ]]; then
  timestamp=$(date --date="@$(stat -c %Y /btrfs/root)" "+%Y-%m-%d_%H:%M:%S")
  mv /btrfs/root/current "/btrfs/root/$timestamp"
fi

btrfs subvolume create /btrfs/root/current

umount /btrfs
