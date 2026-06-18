{
  config,
  lib,
  pkgs,
  ...
}:
let
  hwmonLink = "/run/fancontrol-nct6687";

  linkHwmon = pkgs.writeShellApplication {
    name = "fancontrol-link-nct6687";
    text = ''
      for d in /sys/class/hwmon/hwmon*; do
        name="$(cat "$d/name" 2>/dev/null || true)"
        if [[ "$name" == "nct6687" ]]; then
          ln -sfn "$d" "${hwmonLink}"
          echo "linked ${hwmonLink} -> $d"
          exit 0
        fi
      done
      echo "error: nct6687 hwmon device not found" >&2
      exit 1
    '';
  };
in
{
  boot = {
    extraModulePackages = [
      config.boot.kernelPackages.nct6687d
    ];
    kernelModules = [ "nct6687" ];
    blacklistedKernelModules = [ "nct6683" ];
  };

  systemd.services.fancontrol.serviceConfig.ExecStartPre = lib.getExe linkHwmon;

  hardware.fancontrol = {
    enable = true;
    config =
      let
        sensors = {
          cpu = "${hwmonLink}/temp1_input";
          gpu = "/run/nvidia-temp";
        };

        fans = {
          cpu = {
            pwm = "${hwmonLink}/pwm1";
            rpm = "${hwmonLink}/fan1_input";
          };
          pump = {
            pwm = "${hwmonLink}/pwm2";
            rpm = "${hwmonLink}/fan2_input";
          };
          rear = {
            pwm = "${hwmonLink}/pwm4";
            rpm = "${hwmonLink}/fan4_input";
          };
          gpu = {
            pwm = "${hwmonLink}/pwm5";
            rpm = "${hwmonLink}/fan5_input";
          };
        };

        minStart = "20";
        minStop = "0";

        curves = {
          cpu = {
            minTemp = "45";
            maxTemp = "80";
            maxPWM = "210";
          };

          gpu = {
            minTemp = "45";
            maxTemp = "70";
            maxPWM = "210";
          };

          rearFan = {
            minTemp = "45";
            maxTemp = "80";
            maxPWM = "210";
          };
        };
      in
      ''
        INTERVAL=5

        FCTEMPS=${fans.cpu.pwm}=${sensors.cpu} ${fans.pump.pwm}=${sensors.cpu} ${fans.rear.pwm}=${sensors.cpu} ${fans.gpu.pwm}=${sensors.gpu}
        FCFANS=${fans.cpu.pwm}=${fans.cpu.rpm} ${fans.pump.pwm}=${fans.pump.rpm} ${fans.rear.pwm}=${fans.rear.rpm} ${fans.gpu.pwm}=${fans.gpu.rpm}
        MINTEMP=${fans.cpu.pwm}=${curves.cpu.minTemp} ${fans.pump.pwm}=${curves.cpu.minTemp} ${fans.rear.pwm}=${curves.cpu.minTemp} ${fans.gpu.pwm}=${curves.gpu.minTemp}
        MAXTEMP=${fans.cpu.pwm}=${curves.cpu.maxTemp} ${fans.pump.pwm}=${curves.cpu.maxTemp} ${fans.rear.pwm}=${curves.cpu.maxTemp} ${fans.gpu.pwm}=${curves.gpu.maxTemp}
        MINSTART=${fans.cpu.pwm}=${minStart} ${fans.pump.pwm}=${minStart} ${fans.rear.pwm}=${minStart} ${fans.gpu.pwm}=${minStart}
        MINSTOP=${fans.cpu.pwm}=${minStop} ${fans.pump.pwm}=${minStop} ${fans.rear.pwm}=${minStop} ${fans.gpu.pwm}=${minStop}
        MAXPWM=${fans.cpu.pwm}=${curves.cpu.maxPWM} ${fans.pump.pwm}=${curves.cpu.maxPWM} ${fans.rear.pwm}=${curves.cpu.maxPWM} ${fans.gpu.pwm}=${curves.gpu.maxPWM}
      '';
  };

  # https://www.reddit.com/r/linuxquestions/comments/s8odfm/comment/htkp2td/
  systemd.services.nvidia-temp = {
    enable = true;
    description = "Nvidia GPU temperature reader";
    wantedBy = [ "fancontrol.service" ];
    serviceConfig = {
      Restart = "on-failure";
    };
    path = [
      config.hardware.nvidia.package
      pkgs.bash
    ];
    script = ''
      bash -c 'while :; do
        t="$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)";
        echo "$((t * 1000))" > /run/nvidia-temp;
        sleep 5;
      done'
    '';
  };
}
