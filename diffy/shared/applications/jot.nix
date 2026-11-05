{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "applications" "jot" ] {
  home-manager =
    { config, pkgs, ... }:
    let
      color = name: config.dyad.palette.${name}.hex;
      jot = pkgs.writeShellApplication {
        name = "jot";
        runtimeInputs = [ pkgs.yad ];
        # yad's layout adds 5px above the text box and 2px below
        text = ''
          exec yad --text-info --editable --wrap --no-buttons --no-escape --borders=0 \
            --css="scrolledwindow { margin: 3px 8px 6px; border: none; } textview { padding: 16px; }" \
            --title=jot --class=jot --name=jot \
            --fontname="${config.gtk.font.name} 13" --fore="${color "text"}" --back="${color "base"}" \
            >/dev/null
        '';
      };
    in
    {
      home.packages = [ jot ];
    };
}
