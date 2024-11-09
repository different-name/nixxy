{
  pkgs,
  config,
  ...
}: {
  # kernel modules found with sensors-detect (from lm-sensors)
  boot.kernelModules = ["lm83" "nct6775"];

  # hwmon2/pwm1 - GPU left
  # hwmon2/pwm2 - CPU
  # hwmon2/pwm3 - CPU pump
  # hwmon2/pwm4 - case fan, fresh intake for CPU AIO
  # hwmon2/pwm5 - GPU middle
  # hwmon2/pwm7 - GPU right

  hardware.fancontrol = {
    enable = true;
    config = let
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
        minTemp = "55";
        maxTemp = "80";
        maxPWM = "210";
      };
    in ''
      INTERVAL=5
      DEVPATH=hwmon2=devices/platform/nct6775.656 hwmon3=devices/pci0000:00/0000:00:18.3
      DEVNAME=hwmon2=nct6798 hwmon3=k10temp
      FCTEMPS=hwmon2/pwm1=/run/nvidia-temp hwmon2/pwm2=hwmon3/temp1_input hwmon2/pwm3=hwmon3/temp1_input hwmon2/pwm4=hwmon3/temp1_input hwmon2/pwm5=/run/nvidia-temp
      FCFANS=hwmon2/pwm1=hwmon2/fan1_input hwmon2/pwm2=hwmon2/fan2_input hwmon2/pwm3=hwmon2/fan3_input hwmon2/pwm4=hwmon2/fan4_input hwmon2/pwm5=hwmon2/fan5_input
      MINTEMP=hwmon2/pwm1=${GPU.minTemp} hwmon2/pwm2=${CPU.minTemp} hwmon2/pwm3=${CPU.minTemp} hwmon2/pwm4=${caseFan.minTemp} hwmon2/pwm5=${GPU.minTemp}
      MAXTEMP=hwmon2/pwm1=${GPU.maxTemp} hwmon2/pwm2=${CPU.maxTemp} hwmon2/pwm3=${CPU.maxTemp} hwmon2/pwm4=${caseFan.maxTemp} hwmon2/pwm5=${GPU.maxTemp}
      MINSTART=hwmon2/pwm1=${minStart} hwmon2/pwm2=${minStart} hwmon2/pwm3=${minStart} hwmon2/pwm4=${minStart} hwmon2/pwm5=${minStart}
      MINSTOP=hwmon2/pwm1=${minStop} hwmon2/pwm2=${minStop} hwmon2/pwm3=${minStop} hwmon2/pwm4=${minStop} hwmon2/pwm5=${minStop}
      MAXPWM=hwmon2/pwm1=${GPU.maxPWM} hwmon2/pwm2=${CPU.maxPWM} hwmon2/pwm3=${CPU.maxPWM} hwmon2/pwm4=${caseFan.maxPWM} hwmon2/pwm5=${GPU.maxPWM}
    '';
  };

  # https://www.reddit.com/r/linuxquestions/comments/s8odfm/comment/htkp2td/
  systemd.services.nvidia-temp = {
    enable = true;
    description = "Nvidia GPU temperature reader";
    wantedBy = ["fancontrol.service"];
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
