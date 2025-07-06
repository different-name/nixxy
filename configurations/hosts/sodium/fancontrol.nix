{ config, pkgs, ... }:
{
  # kernel modules found with sensors-detect (from lm-sensors)
  boot.kernelModules = [
    "lm83"
    "nct6775"
  ];

  # hwmon1/pwm1 - GPU left
  # hwmon1/pwm2 - CPU
  # hwmon1/pwm3 - CPU pump
  # hwmon1/pwm4 - case fan, fresh intake for CPU AIO
  # hwmon1/pwm5 - GPU middle
  # hwmon1/pwm7 - GPU right

  hardware.fancontrol = {
    enable = true;
    config =
      let
        minStart = "20";
        minStop = "0";

        CPU = {
          minTemp = "45";
          maxTemp = "80";
          maxPWM = "210";
        };

        GPU = {
          minTemp = "45";
          maxTemp = "70";
          maxPWM = "210";
        };

        caseFan = {
          minTemp = "45";
          maxTemp = "80";
          maxPWM = "210";
        };
      in
      ''
        INTERVAL=5
        DEVPATH=hwmon1=devices/platform/nct6775.656 hwmon2=devices/pci0000:00/0000:00:18.3
        DEVNAME=hwmon1=nct6798 hwmon2=k10temp
        FCTEMPS=hwmon1/pwm1=/run/nvidia-temp hwmon1/pwm2=hwmon2/temp1_input hwmon1/pwm3=hwmon2/temp1_input hwmon1/pwm4=hwmon2/temp1_input hwmon1/pwm5=/run/nvidia-temp hwmon1/pwm7=/run/nvidia-temp
        FCFANS=hwmon1/pwm1=hwmon1/fan1_input hwmon1/pwm2=hwmon1/fan2_input hwmon1/pwm3=hwmon1/fan3_input hwmon1/pwm4=hwmon1/fan4_input hwmon1/pwm5=hwmon1/fan5_input hwmon1/pwm7=hwmon1/fan7_input
        MINTEMP=hwmon1/pwm1=${GPU.minTemp} hwmon1/pwm2=${CPU.minTemp} hwmon1/pwm3=${CPU.minTemp} hwmon1/pwm4=${caseFan.minTemp} hwmon1/pwm5=${GPU.minTemp} hwmon1/pwm7=${GPU.minTemp}
        MAXTEMP=hwmon1/pwm1=${GPU.maxTemp} hwmon1/pwm2=${CPU.maxTemp} hwmon1/pwm3=${CPU.maxTemp} hwmon1/pwm4=${caseFan.maxTemp} hwmon1/pwm5=${GPU.maxTemp} hwmon1/pwm7=${GPU.maxTemp}
        MINSTART=hwmon1/pwm1=${minStart} hwmon1/pwm2=${minStart} hwmon1/pwm3=${minStart} hwmon1/pwm4=${minStart} hwmon1/pwm5=${minStart} hwmon1/pwm7=${minStart}
        MINSTOP=hwmon1/pwm1=${minStop} hwmon1/pwm2=${minStop} hwmon1/pwm3=${minStop} hwmon1/pwm4=${minStop} hwmon1/pwm5=${minStop} hwmon1/pwm7=${minStop}
        MAXPWM=hwmon1/pwm1=${GPU.maxPWM} hwmon1/pwm2=${CPU.maxPWM} hwmon1/pwm3=${CPU.maxPWM} hwmon1/pwm4=${caseFan.maxPWM} hwmon1/pwm5=${GPU.maxPWM} hwmon1/pwm7=${GPU.maxPWM}
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
    path = with pkgs; [
      bash
      config.hardware.nvidia.package
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
