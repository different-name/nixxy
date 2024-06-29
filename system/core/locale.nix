{inputs, ...}: {
  time.timeZone = "Australia/Brisbane";
  i18n.defaultLocale = "en_AU.UTF-8";

  console.useXkbConfig = true; # Use xkb layout for console
  services.xserver.xkb.layout = "us"; # Wayland uses xserver.xkb.layout too
}
