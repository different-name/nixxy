{
  bundleLib,
  lib,
  inputs,
  inputs',
  self,
  ...
}:
bundleLib.mkEnableModule [ "dyad" "applications" "discord" ] {
  home-manager =
    { pkgs, ... }:
    let
      discordPackage = pkgs.discord.override {
        withMoonlight = true;
        inherit (inputs'.moonlight.packages) moonlight;
      };
    in
    {
      imports = [
        inputs.moonlight.homeModules.default
        self.homeModules.disblockOrigin
      ];

      config = {
        programs.moonlight = {
          enable = true;
          configs.stable = import ./_moonlight-config.nix;
        };

        xdg.configFile."moonlight-mod/stable.json".force = true;

        programs.disblockOrigin = {
          enable = true;
          settings = {
            gif-button = true;
            active-now = false;
            clan-tags = false;
            settings-billing-header = false;
            settings-gift-inventory-tab = false;
          };
        };

        home.packages = [
          discordPackage
          (pkgs.writeShellScriptBin "moonlight-config-updater" (lib.readFile ./moonlight-config-updater.sh))
        ];

        systemd.user.services.discord = {
          Unit = {
            Description = "Discord";
            PartOf = [ "graphical-session.target" ];
            After = [ "graphical-session.target" ];
          };

          Service = {
            # workaround for starting before network is available
            ExecStartPre = "${lib.getExe' pkgs.coreutils "sleep"} 2";
            ExecStart = lib.getExe discordPackage;
            Restart = "no";
          };

          Install.WantedBy = [ "graphical-session.target" ];
        };

        home.perpetual.default.dirs = [
          "$configHome/discord"
          "$configHome/moonlight-mod"
        ];
      };
    };
}
