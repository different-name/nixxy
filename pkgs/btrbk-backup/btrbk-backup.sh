#!/usr/bin/env bash

DEVICE=$(readlink -f /dev/disk/by-uuid/"@uuid@")
if [[ -z $DEVICE ]]; then
  echo "ERROR: Backup device with UUID @uuid@ not found."
  exit 1
fi

echo "Found backup device at $DEVICE"

if ! mountpoint -q "@mount_point@"; then
  if ! cryptsetup status "@crypt_name@" &>/dev/null; then
    echo "Opening LUKS device..."
    sudo cryptsetup open "$DEVICE" "@crypt_name@"
  fi

  echo "Mounting backup drive..."
  sudo mkdir -p /mnt/backup
  sudo mount /dev/mapper/"@crypt_name@" "@mount_point@"
fi

sudo btrbk -c @config_path@ --progress --verbose run

echo "Unmounting backup drive..."
sudo umount "@mount_point@"

echo "Closing LUKS device..."
sudo cryptsetup close "@crypt_name@"

echo "Powering off the device..."
sudo udisksctl power-off -b "$DEVICE"

echo "Backup and shutdown complete."
