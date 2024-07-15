{
  xdg = {
    # WORKAROUND for flickering until explicit sync is implemented into hyprland
    # https://github.com/hyprwm/Hyprland/issues/4857#issuecomment-2197871403
    # --disable-gpu-compositing for electron apps

    desktopEntries = {
      brave-browser = {
        name = "Brave Web Browser";
        exec = "brave --disable-gpu-compositing %U";
        comment = "Access the Internet";
        startupNotify = true;
        terminal = false;
        icon = "brave-browser";
        type = "Application";
        categories = [
          "Network"
          "WebBrowser"
        ];
        mimeType = [
          "application/pdf"
          "application/rdf+xml"
          "application/rss+xml"
          "application/xhtml+xml"
          "application/xhtml_xml"
          "application/xml"
          "image/gif"
          "image/jpeg"
          "image/png"
          "image/webp"
          "text/html"
          "text/xml"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
          "x-scheme-handler/ipfs"
          "x-scheme-handler/ipns"
        ];
      };

      vesktop = {
        categories = [
          "Network"
          "InstantMessaging"
          "Chat"
        ];
        exec = "vesktop --disable-gpu-compositing %U";
        genericName = "Internet Messenger";
        icon = "vesktop";
        name = "Vesktop";
        type = "Application";
      };

      codium = {
        categories = [
          "Utility"
          "TextEditor"
          "Development"
          "IDE"
        ];
        comment = "Code Editing. Redefined.";
        exec = "codium --disable-gpu-compositing %F";
        genericName = "Text Editor";
        icon = "vscodium";
        mimeType = ["text/plain" "inode/directory"];
        name = "VSCodium";
        startupNotify = true;
        type = "Application";
      };
    };
  };
}
