{
  lib,
  config,
  ...
}:
{
  options.dyad.terminal.btop.enable = lib.mkEnableOption "btop config";

  config = lib.mkIf config.dyad.terminal.btop.enable {
    programs.btop = {
      enable = true;

      settings = {
        proc_gradient = false;
        proc_mem_bytes = false;
        show_swap = false;
      };
    };
  };
}
