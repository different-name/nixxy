{
  lib,
  config,
  inputs,
  ...
}:
{
  config = lib.mkIf config.dyad.games.steam.enable {
    home-manager =
      { pkgs, ... }:
      let
        redscript = pkgs.fetchzip {
          url = "https://github.com/jac3km4/redscript/releases/download/v0.5.32/redscript-v0.5.32-windows.zip";
          stripRoot = false;
          hash = "sha256-LEdXmkMsRcC2UQrzMXzXXIVoeTXHctfwgc1PKOLJ6GU=";
        };
        mod = name: { "r6/scripts/${name}".source = "${inputs.diffys-attic}/cyberpunk/mods/${name}"; };
      in
      {
        programs.steam-config.apps."1091500" = {
          name = "Cyberpunk 2077";
          args = [
            "--launcher-skip"
            "--skipStartScreen"
          ];
          files.game.overlay = {
            "engine/config/base/scripts.ini".source = "${redscript}/engine/config/base/scripts.ini";
            "engine/tools".source = "${redscript}/engine/tools";
            "r6/config/cybercmd/scc.toml".source = "${redscript}/r6/config/cybercmd/scc.toml";
          }
          // mod "skip-intros"
          // mod "auto-loot"
          // mod "vehicle-summon";
        };
      };
  };
}
