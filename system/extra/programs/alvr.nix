{
  programs.alvr.enable = true;

  # https://github.com/alvr-org/ALVR/wiki/Linux-Troubleshooting
  # Add ~/.local/share/Steam/steamapps/common/SteamVR/bin/vrmonitor.sh %command% to the commandline options of SteamVR (SteamVR -> Manage/Right Click -> Properties -> General -> Launch Options).
  # When using hyprland or Gnome Wayland you need to put WAYLAND_DISPLAY='' %command% into the SteamVR commandline options to force XWayland.
}
