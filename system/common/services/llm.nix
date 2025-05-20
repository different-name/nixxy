{
  lib,
  config,
  ...
}: {
  options.nix-files.services.llm.enable = lib.mkEnableOption "Open WebUI config";

  config = lib.mkIf config.nix-files.services.llm.enable {
    services.open-webui = {
      enable = true;
      port = 8888;
    };

    services.ollama = {
      enable = true;
      acceleration = "cuda";
      loadModels = [
        "gemma3:4b"
        "deepseek-r1:7b"
      ];
    };

    environment.persistence."/persist/system" = lib.mkIf config.nix-files.core.persistence.enable {
      directories = [
        "/var/lib/private/open-webui"
        "/var/lib/private/ollama"
      ];
    };

    systemd.tmpfiles.rules = lib.mkIf config.nix-files.core.persistence.enable [
      # correcting permissions
      "d /var/lib/private 0700 root root -"
      "d /var/lib/private/open-webui 0755 root root -"
      "d /var/lib/private/ollama 0755 root root -"
    ];
  };
}
