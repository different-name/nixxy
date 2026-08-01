{ bundleLib, lib, ... }:
bundleLib.mkEnableModule [ "dyad" "desktop" "swayosd" ] {
  # swayosd is only a display surface here, osd-brightness writes the backlight itself,
  # so swayosd's own backlight backend / udev rules are never exercised
  home-manager =
    { config, pkgs, ... }:
    let
      getColor = name: config.dyad.palette.${name}.hex;

      accent = getColor "green";

      # inject the palette as gtk named colors before the stylesheet (style.css uses @accent/@base/@text/@surface)
      styleFile = pkgs.writeText "swayosd-style.css" (
        ''
          @define-color accent  ${accent};
          @define-color base    ${getColor "base"};
          @define-color text    ${getColor "text"};
          @define-color surface ${getColor "surface1"};
        ''
        + builtins.readFile ./style.css
      );
    in
    {
      home.packages = [ pkgs.swayosd ];

      systemd.user.services.swayosd = {
        Unit = {
          Description = "SwayOSD server (on-screen display for volume/brightness)";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };

        Service = {
          ExecStart = "${lib.getExe' pkgs.swayosd "swayosd-server"} --style ${styleFile}";
          Restart = "on-failure";
        };

        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
}
