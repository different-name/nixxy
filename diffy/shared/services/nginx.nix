{ bundleLib, ... }:
bundleLib.mkEnableModule [ "dyad" "services" "nginx" ] {
  nixos.services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    # unknown names and the bare ip get no certificate and no response
    virtualHosts."_" = {
      default = true;
      rejectSSL = true;
      locations."/".return = "444";
    };
  };
}
