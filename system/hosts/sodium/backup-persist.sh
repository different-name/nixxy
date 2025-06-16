UUID="a5091625-835c-492f-8d99-0fc8d27012a0"
CRYPT_NAME="backup_drive"
MOUNT_POINT="/mnt/backup"
SNAPSHOT_DIR="/btrfs"
SOURCE_SUBVOL="${SNAPSHOT_DIR}/persist"

DATETIME=$(date '+%Y-%m-%d_%H:%M:%S')
SNAPSHOT_NAME="persist_${DATETIME}"
SNAPSHOT_PATH="${SNAPSHOT_DIR}/${SNAPSHOT_NAME}"

DEVICE=$(readlink -f /dev/disk/by-uuid/$UUID)
if [[ -z "$DEVICE" ]]; then
  echo "ERROR: Backup device with UUID $UUID not found."
  exit 1
fi

echo "Found backup device at $DEVICE"

if ! mountpoint -q "$MOUNT_POINT"; then
  if ! cryptsetup status "$CRYPT_NAME" &>/dev/null; then
    echo "Opening LUKS device..."
    sudo cryptsetup open "$DEVICE" "$CRYPT_NAME"
  fi

  echo "Mounting backup drive..."
  sudo mount /dev/mapper/"$CRYPT_NAME" "$MOUNT_POINT"
fi

LAST_BACKUP_SNAPSHOT=$(sudo btrfs subvolume list "$SNAPSHOT_DIR" | grep '^ID' | awk '{print $NF}' | grep '^persist_' | sort | tail -n1)

echo "Creating read-only snapshot $SNAPSHOT_NAME..."
sudo btrfs subvolume snapshot -r "$SOURCE_SUBVOL" "$SNAPSHOT_PATH"

if [[ -n "$SNAPSHOT_DIR/$LAST_BACKUP_SNAPSHOT" && -d "$MOUNT_POINT/$LAST_BACKUP_SNAPSHOT" ]]; then
  echo "Incremental send from $LAST_BACKUP_SNAPSHOT to $SNAPSHOT_NAME"
  sudo btrfs send -p "$SNAPSHOT_DIR/$LAST_BACKUP_SNAPSHOT" "$SNAPSHOT_PATH" | pv | sudo btrfs receive "$MOUNT_POINT"
  
  echo "Backup complete."

  echo "Deleting old local snapshot $SNAPSHOT_NAME..."
  sudo btrfs subvolume delete "$SNAPSHOT_DIR/$LAST_BACKUP_SNAPSHOT"
else
  echo "No previous snapshot found, doing full send."
  sudo btrfs send "$SNAPSHOT_PATH" | pv | sudo btrfs receive "$MOUNT_POINT"
  
  echo "Backup complete."
fi

echo "Unmounting backup drive..."
sudo umount "$MOUNT_POINT"

echo "Closing LUKS device..."
sudo cryptsetup close "$CRYPT_NAME"

echo "Powering off the device..."
sudo udisksctl power-off -b "$DEVICE"

echo "Backup and shutdown complete."

