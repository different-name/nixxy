{ lib, bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "applications" "signal-desktop" ] {
  home-manager =
    { config, pkgs, ... }:
    let
      inherit (config.dyad) palette;
      inherit (config.catppuccin) accent;

      hex = name: palette.${name}.hex;
      rgba =
        name: alpha:
        let
          inherit (palette.${name}) rgb;
        in
        "rgb(${toString rgb.r} ${toString rgb.g} ${toString rgb.b} / ${alpha})";

      tokens = {
        # keep-sorted start
        border-focused-outer = hex accent;
        border-primary = rgba "overlay2" ".24";
        border-secondary = rgba "overlay2" ".32";
        border-selected = hex accent;
        fill-accent = hex accent;
        fill-accent-pressed = "color-mix(in srgb, ${hex accent} 85%, ${hex "crust"})";
        fill-affirmative = hex "green";
        fill-destructive = hex "red";
        fill-destructive-pressed = "color-mix(in srgb, ${hex "red"} 85%, ${hex "crust"})";
        fill-inverted = hex "text";
        fill-primary = rgba "overlay2" ".12";
        fill-primary-pressed = rgba "overlay2" ".16";
        fill-secondary = rgba "overlay2" ".2";
        fill-secondary-pressed = rgba "overlay2" ".24";
        label-accent = hex accent;
        label-affirmative = hex "green";
        label-destructive = hex "red";
        label-disabled = hex "overlay0";
        label-placeholder = hex "overlay1";
        label-primary = hex "text";
        label-primary-oncolor = hex "crust";
        label-secondary = hex "subtext0";
        label-secondary-oncolor = rgba "crust" ".8";
        label-warning = hex "yellow";
        legacy-conversation-header-bg = hex "base";
        material-dialog = rgba "surface0" ".95";
        material-primary = rgba "mantle" ".95";
        material-quaternary = rgba "surface1" ".95";
        material-secondary = rgba "base" ".95";
        material-tertiary = rgba "surface0" ".95";
        surface-message-incoming = hex "surface0";
        surface-message-outgoing = hex accent;
        surface-primary = hex "base";
        surface-quaternary = hex "surface1";
        surface-secondary = hex "mantle";
        surface-tertiary = hex "surface0";
        # keep-sorted end
      };

      # light mode reuses these greys for other roles, so only .dark-theme rules get them
      darkColors = {
        "000000" = "crust";
        "121212" = "base";
        "1b1b1b" = "mantle";
        "262626" = "surface0";
        "2e2e2e" = "surface0";
        "343434" = "surface1";
        "3b3b3b" = "surface1";
        "4a4a4a" = "surface2";
        "545454" = "overlay0";
        "5e5e5e" = "overlay0";
        "848484" = "overlay1";
        "b9b9b9" = "subtext0";
        "c6c6c6" = "subtext0";
        "dedede" = "subtext1";
        "e9e9e9" = "text";
        "f6f6f6" = "text";
        "ffffff" = "text";
      };

      allColors = {
        "0552f0" = accent;
        "2c6bed" = accent;
        "6191f3" = accent;
        "f44336" = "red";
      };

      perlHash = colors: lib.concatMapAttrsStringSep ", " (k: v: ''"${k}" => "${hex v}"'') colors;

      remap = pkgs.writeText "signal-catppuccin.pl" ''
        my %dark = (${perlHash darkColors});
        my %all = (${perlHash allColors});

        sub remap {
          my ($body, $colors) = @_;
          $body =~ s!#([0-9a-fA-F]{6}|[0-9a-fA-F]{3})\b!
            my $orig = $1;
            my $h = lc $orig;
            $h =~ s/(.)/$1$1/g if length $h == 3;
            exists $colors->{$h} ? $colors->{$h} : "#$orig"
          !ge;
          $body
        }

        s!([^{}]*)\{([^{}]*)\}!
          my ($sel, $body) = ($1, $2);
          $body = remap($body, \%all);
          $body = remap($body, \%dark) if $sel =~ /\.dark-theme/;
          $body =~ s{hsla\(0,\s*0%,\s*100%,\s*([\d.]+)\)}{rgb(from var(--axo-color-label-primary-oncolor) r g b / $1)}g
            if $sel =~ /outgoing/ && index($sel, "gift-badge__button") < 0;
          $sel . "{" . $body . "}"
        !ge;
      '';

      tokenCss = ".dark-theme{${
        lib.concatMapAttrsStringSep "" (name: value: "--axo-color-${name}:${value};") tokens
      }}";

      # hardcoded as hsla and rgb, which the hex remap can't reach
      overrideCss = ''
        .dark-theme .module-message__text--outgoing,
        .dark-theme .module-message__text--outgoing a {
          color: var(--axo-color-label-primary-oncolor);
        }
        .dark-theme .module-quote--compose-ultramarine,
        .dark-theme .module-quote--incoming-ultramarine {
          background-image: none;
          background-color: ${rgba accent ".2"};
        }
        .dark-theme .module-quote--outgoing-ultramarine {
          background-image: none;
          background-color: color-mix(in srgb, ${hex accent} 75%, ${hex "crust"});
        }
        .dark-theme .module-quote--outgoing-ultramarine .module-quote__primary {
          border-inline-start-color: ${hex "crust"};
        }
      '';

      package = pkgs.signal-desktop.overrideAttrs (old: {
        postBuild = ''
          ${lib.getExe pkgs.perl} -0777 -pi ${remap} stylesheets/manifest.css stylesheets/manifest_bridge.css
          echo ${lib.escapeShellArg tokenCss} >> stylesheets/tailwind.css
          cat ${pkgs.writeText "signal-catppuccin.css" overrideCss} >> stylesheets/tailwind.css
        ''
        + old.postBuild;
      });
    in
    {
      home.packages = [ package ];
      keep.safe.configDirs = [ "Signal" ];
    };
}
