if [[ $# -lt 1 ]]; then
  notify-send -u critical "Steam wrapper" "No command provided to wrapper"
  exit 1
fi

# steam launch commands are actually quite complex:
# /home/different/.local/share/Steam/ubuntu12_32/steam-launch-wrapper -- /home/different/.local/share/Steam/ubuntu12_32/reaper SteamLaunch AppId=438100 -- /home/different/.local/share/Steam/steamapps/common/SteamLinuxRuntime_sniper/_v2-entry-point --verb=waitforexitandrun -- /nix/store/zrgagbs6vcxhr4n8ayj94b4akh18r7k7-proton-ge-rtsp-bin-GE-Proton9-22-rtsp17-1-steamcompattool/proton waitforexitandrun /home/different/.local/share/Steam/steamapps/common/VRChat/launch.exe --no-vr
# since I want to use the game folder name, and not the AppID,
# we search through the whole command for the last instance of /steamapps/common/<game>/
# to avoid matching something like SteamLinuxRuntime_sniper

matches=$(echo "$*" | grep -oE 'steamapps/common/[^/]+')

if [[ -n "$matches" ]]; then
  GAME_NAME=$(echo "$matches" | tail -n 1 | sed 's|steamapps/common/||')
else
  notify-send -u critical "Steam wrapper" "Could not determine game name from command: $*"
  exit 1
fi

# __GLOBAL_ENV__

case "$GAME_NAME" in
# __GAME_ENVS__
esac

exec "$@"

