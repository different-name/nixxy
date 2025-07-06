{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.dyad.programs.fish.enable = lib.mkEnableOption "fish config";

  config = lib.mkIf config.dyad.programs.fish.enable {
    programs.fish = {
      enable = true;

      interactiveShellInit = ''
        set fish_greeting # disable greeting
      '';
    };

    # use fish as shell https://nixos.wiki/wiki/Fish
    programs.bash = {
      interactiveShellInit = ''
        if [[ $(${lib.getExe' pkgs.procps "ps"} --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${lib.getExe pkgs.fish} $LOGIN_OPTION
        fi
      '';
    };
  };
}
