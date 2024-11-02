{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.gpd-win-4-2024
    inputs.gpd-fan-driver.nixosModules.default
    ../modules
  ];

  #### Options #################################################################
  greeter = "sddm";
  desktop.hyprland.layout = "hy3";
  steam.enable = true;

  #### System Configuration ####################################################

  # Hardware config
  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.enableRedistributableFirmware = true;
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

  # Device config
  networking.hostName = "ixion";
  networking.useDHCP = lib.mkDefault true;
  time.timeZone = "Australia/Melbourne";

  # Bootloader configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "thunderbolt"
    "usbhid"
  ];

  # Partition configuration
  boot.initrd.luks.devices."root".device = "/dev/disk/by-label/nixos-luks";
  boot.initrd.luks.devices."swap".device = "/dev/disk/by-label/swap-luks";
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      options = [
        "noatime"
        "nodiratime"
        "discard"
      ];
    };
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
  };
  swapDevices = [{device = "/dev/disk/by-label/swap";}];
}
