{inputs, ...}: {
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        # change the scheduler policy to SCHED_ISO on CPUs with more than 4 cores
        softrealtime = "auto";
        # adjust the priority of game processes
        renice = 15;
      };
    };
  };

  # nix-gaming pipewire low latency module
  services.pipewire.lowLatency.enable = true;
  imports = [
    inputs.nix-gaming.nixosModules.pipewireLowLatency
  ];
}
