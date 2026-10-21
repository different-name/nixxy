#!/usr/bin/env bash

# get list of archived subvolumes excluding 'current'
mapfile -t subvols < <(find "/btrfs/root" -mindepth 1 -maxdepth 1 -type d ! -name current)

# extract timestamps and sort by date (oldest first)
mapfile -t sorted_subvols < <(printf "%s\n" "${subvols[@]}" | sort)
total=${#sorted_subvols[@]}

# number of candidates for deletion
candidates=$((total - KEEP_MIN_NUM))
if ((candidates <= 0)); then
  exit 0
fi

now=$(date +%s)

for ((i = 0; i < candidates; i++)); do
  subvol="${sorted_subvols[i]}"
  basename=$(basename "$subvol")

  # replace '_' with ' ' for date parsing
  timestamp="${basename/_/ }"

  # convert to epoch seconds
  if ! subvol_epoch=$(date -d "$timestamp" +%s 2>/dev/null); then
    echo "Error: Failed to parse timestamp from subvolume name '$basename'" >&2
    exit 1
  fi

  # calculate age in days
  age_days=$(((now - subvol_epoch) / 86400))

  if ((age_days > KEEP_AGE_DAYS)); then
    echo "Deleting subvolume: $subvol"
    btrfs subvolume delete --recursive "$subvol"
  fi
done
