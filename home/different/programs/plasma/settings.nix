{
  programs.plasma = {
    workspace = {
      wallpaper = "${../../wallpaper.jpg}";
      lookAndFeel = "org.kde.breezedark.desktop";
      iconTheme = "Papirus";

      cursor = {
        theme = "Default";
        size = 32;
      };
    };

    kscreenlocker.wallpaper = "${../../wallpaper.jpg}";


    panels = [
      {
        location = "top";

        widgets = [
          # plasma app launcher
          {
            name = "org.kde.plasma.kickoff";
            config.General.icon = "nix-snowflake";
          }
          # app icons in tray
          {
            name = "org.kde.plasma.icontasks";
            config.General.launchers = [
              "applications:brave-browser.desktop"
              "applications:vesktop.desktop"
            ];
          }
          # tray icons
          {
            systemTray.items = {
              shown = [
              ];
              hidden = [
                "org.kde.plasma.volume" # using pavucontrol instead
              ];
            };
          }
          # divider between clock and tray icons
          "org.kde.plasma.marginsseparator"
          # clock
          {
            digitalClock = {
              time.format = "12h";
            };
          }
        ];
      }
    ];
  };
}