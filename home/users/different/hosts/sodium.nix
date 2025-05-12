{pkgs, ...}: {
  imports = [
    ../.
  ];

  ### modules

  nix-files = {
    profiles = {
      global.enable = true;
      graphical.enable = true;
    };

    graphical.games.xr.enable = true;
    graphical.meta.nvidia.enable = true;

    services.goxlr-utility.enable = true;
  };

  ### host specific

  programs.btop.settings.cpu_sensor = "k10temp/Tctl";

  # goxlr / tascam

  home.packages = [
    (pkgs.writeShellApplication {
      name = "tascam";
      runtimeInputs = with pkgs; [
        bash
        jq
        goxlr-utility
      ];
      text = builtins.readFile ../scripts/tascam.sh;
    })
  ];

  wayland.windowManager.hyprland.settings.bind = [
    "$mod, P, exec, pgrep tascam || tascam"
  ];

  ### required config

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
