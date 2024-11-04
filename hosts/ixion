{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.gpd-win-4-2024
    inputs.gpd-fan-driver.nixosModules.default
  ];

  # Partition configuration
  boot.initrd.luks.devices."root".device = "/dev/disk/by-label/nixos-luks";
  fileSystems ."/".device = "/dev/disk/by-label/nixos";
  fileSystems."/boot".device = "/dev/disk/by-label/boot";
  boot.initrd.luks.devices."swap".device = "/dev/disk/by-label/swap-luks";
  swapDevices = [{device = "/dev/disk/by-label/swap";}];

  # Device config
  networking.hostName = "ixion";
  nixpkgs.hostPlatform = "x86_64-linux";
  time.timeZone = "Australia/Melbourne";

  # Device options
  steam.enable = true;
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
}
