{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.gpd-win-4-2024
    inputs.gpd-fan-driver.nixosModules.default
  ];

  # Device config
  time.timeZone = "Australia/Melbourne";

  # Device hardware
  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.gpd-fan.enable = true;
  hardware.fancontrol = {
    enable = true;
    config = ''
      INTERVAL=10
      FCTEMPS=/sys/class/hwmon/hwmon6/pwm1=/sys/class/hwmon/hwmon4/temp1_input
      FCFANS=/sys/class/hwmon/hwmon6/pwm1=/sys/class/hwmon/hwmon6/fan1_input
      MINTEMP=/sys/class/hwmon/hwmon6/pwm1=50
      MAXTEMP=/sys/class/hwmon/hwmon6/pwm1=85
      MINSTART=/sys/class/hwmon/hwmon6/pwm1=23
      MINSTOP=/sys/class/hwmon/hwmon6/pwm1=13
      MAXPWM=/sys/class/hwmon/hwmon6/pwm=128
    '';
  };

  # Device programs
  steam.enable = true;
}
