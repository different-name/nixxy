{ config, pkgs, ... }:
{
  boot.extraModulePackages = [
    config.boot.kernelPackages.nct6687d
  ];
  boot.kernelModules = [ "nct6687" ];
  boot.blacklistedKernelModules = [ "nct6683" ];

  hardware.fancontrol = {
    enable = true;
    config =
      let
        sensors = {
          cpu = "hwmon4/temp1_input";
          gpu = "/run/nvidia-temp";
        };

        fans = {
          cpu = {
            pwm = "hwmon4/pwm1";
            rpm = "hwmon4/fan1_input";
          };
          pump = {
            pwm = "hwmon4/pwm2";
            rpm = "hwmon4/fan2_input";
          };
          rear = {
            pwm = "hwmon4/pwm4";
            rpm = "hwmon4/fan4_input";
          };
          gpu = {
            pwm = "hwmon4/pwm5";
            rpm = "hwmon4/fan5_input";
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
        DEVPATH=hwmon4=devices/platform/nct6687.2592
        DEVNAME=hwmon4=nct6687

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
