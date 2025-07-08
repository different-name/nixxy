{ lib, config, ... }:
{
  config = lib.mkIf config.dyad.desktop.hyprland.enable {
    wayland.windowManager.hyprland.settings.windowrule =
      let
        gameClasses = [
          # keep-sorted start
          "Paradox Launcher"
          "hl2_linux"
          "osu!"
          "steam_app_default"
          ''AcrossTheObelisk\.x86_64''
          ''TerraTechLinux64\.x86_64''
          ''diablo iv\.exe''
          # keep-sorted end
        ];
        gameClassesStr = lib.concatStringsSep "|" gameClasses;
        gameRule = rule: (rule + ", class:steam_app_[0-9]+|${gameClassesStr}, title:.+");
      in
      [
        # global
        "suppressevent maximize, class:.*"

        # qalculate
        "float, class:qalculate-gtk"
        "size 850 575, class:qalculate-gtk"

        # firefox PiP
        "float, title:Picture-in-Picture"
        "pin, title:Picture-in-Picture"
        "size 480 270, title:Picture-in-Picture"
        "keepaspectratio, title:Picture-in-Picture"

        # gtk popups
        "float, class:xdg-desktop-portal-gtk"

        # pavucontrol
        ''float, class:org\.pulseaudio\.pavucontrol''
        ''size 1000 750, class:org\.pulseaudio\.pavucontrol''

        # file prompts
        "float, title:File Operation Progress"
        "float, class:file-roller"
        "float, class:org.gnome.FileRoller"
        "float, class:codium, title:Open Folder"

        # hyprland share picker
        "float, title:Select what to share"

        # obsidian
        "float, class: obsidian"
        "size 1000 900, class: obsidian"

        # games
        (gameRule "suppressevent fullscreen")
        (gameRule "fullscreen")
        (gameRule "workspace 2")
        # fix for various mouse issues
        # possibly related to https://github.com/hyprwm/Hyprland/issues/6543
        # "stayfocused, class:steam_app_[0-9]+, title:.+"
        "stayfocused, class:osu!, title:.+"

        ''renderunfocused, initialTitle:Minecraft(\*)? [0-9\.]+''
        ''suppressevent fullscreen, initialTitle:Minecraft(\*)? [0-9\.]+''
        ''fullscreen, initialTitle:Minecraft(\*)? [0-9\.]+''
        ''workspace 2, initialTitle:Minecraft(\*)? [0-9\.]+''

        # wine system tray
        "unset, title:Wine System Tray"
        "workspace special:hidden silent, title:Wine System Tray"
        "noinitialfocus, title:Wine System Tray"

        # battle.net
        ''tile, class:battle\.net\.exe''

        # steam friends
        "float, class:steam, title:Friends List"
        "size 452 800, class:steam, title:Friends List"
        # steam settings
        "float, class:steam, title:Steam Settings"
        "size 1275 1083, class:steam, title:Steam Settings"

        # render discord in background, potential crash workaround while screencasting
        ''renderunfocused, class:discord, initialTitle:Discord''
      ];
  };
}
