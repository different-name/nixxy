{
  pname,
  version,
  buildFHSEnv,
}:
buildFHSEnv {
  pname = "${pname}-fhs-env";
  inherit version;
  runScript = "";

  targetPkgs =
    pkgs: with pkgs; [
      # Unity Hub binary dependencies
      xorg.libXrandr
      xdg-utils

      # GTK filepicker
      gsettings-desktop-schemas
      hicolor-icon-theme

      # Bug Reporter dependencies
      fontconfig
      freetype
      lsb-release
    ];

  multiPkgs =
    pkgs: with pkgs; [
      # Unity Hub ldd dependencies
      cups
      gtk3
      expat
      libxkbcommon
      lttng-ust_2_12
      krb5
      alsa-lib
      nss
      libdrm
      libgbm
      nspr
      atk
      dbus
      at-spi2-core
      pango
      xorg.libXcomposite
      xorg.libXext
      xorg.libXdamage
      xorg.libXfixes
      xorg.libxcb
      xorg.libxshmfence
      xorg.libXScrnSaver
      xorg.libXtst

      # Unity Hub additional dependencies
      libva
      openssl
      cairo
      libnotify
      libuuid
      libsecret
      udev
      libappindicator
      wayland
      cpio
      icu
      libpulseaudio

      # Unity Editor dependencies
      libglvnd # provides ligbl
      xorg.libX11
      xorg.libXcursor
      glib
      gdk-pixbuf
      (libxml2.overrideAttrs rec {
        version = "2.13.8";
        src = fetchurl {
          url = "mirror://gnome/sources/libxml2/${lib.versions.majorMinor version}/libxml2-${version}.tar.xz";
          hash = "sha256-J3KUyzMRmrcbK8gfL0Rem8lDW4k60VuyzSsOhZoO6Eo=";
        };
      })
      zlib
      clang
      git # for git-based packages in unity package manager

      # Unity Editor 2019 specific dependencies
      xorg.libXi
      xorg.libXrender
      gnome2.GConf
      libcap

      # Unity Editor 6000 specific dependencies
      harfbuzz
      vulkan-loader

      # # Unity Bug Reporter specific dependencies
      xorg.libICE
      xorg.libSM

      # seems to cause font rendering
      # Fonts used by built-in and third party editor tools
      # corefonts
      # dejavu_fonts
      # liberation_ttf
    ];
}
