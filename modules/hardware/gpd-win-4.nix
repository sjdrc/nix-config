{...}: {
  flake.nixosModules.gpd-win-4 = {config, lib, pkgs, ...}: {
    options.custom.gpd-win-4.enable = lib.mkEnableOption "GPD Win 4 hardware tweaks";

    config = lib.mkIf config.custom.gpd-win-4.enable {
      # Initrd modules
      boot.initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "usbhid"
        "thunderbolt"
      ];
      boot.initrd.kernelModules = ["amdgpu"];

      boot.kernelParams = [
        "amd_pstate=active"
      ];

      # Disable fingerprint reader (broken on Linux, causes suspend failures)
      services.udev.extraRules = ''
        SUBSYSTEM=="usb", ATTR{idVendor}=="2808", ATTR{idProduct}=="9338", ATTR{remove}="1"
      '';

      # AMD GPU 32-bit support (for Steam/gaming)
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      # IMU/gyroscope (BMI260)
      hardware.sensor.iio.enable = lib.mkDefault true;

      # Gyro suspend/resume fix: unload BMI260 before sleep, reload after wake
      # (from aarron-lee/gpd-win-tricks, originally by ChimeraOS)
      systemd.services.gpd-win4-suspend-gyro = {
        description = "Unload BMI260 gyro driver before suspend";
        before = ["sleep.target"];
        wantedBy = ["sleep.target"];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.kmod}/bin/modprobe -r bmi260_i2c bmi260_core";
        };
      };
      systemd.services.gpd-win4-resume-gyro = {
        description = "Reload BMI260 gyro driver after resume";
        after = ["suspend.target" "hibernate.target"];
        wantedBy = ["suspend.target" "hibernate.target"];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.kmod}/bin/modprobe bmi260_i2c";
        };
      };

      # Blacklist ath3k when redistributable firmware is disabled
      boot.blacklistedKernelModules = lib.optionals (!config.hardware.enableRedistributableFirmware) [
        "ath3k"
      ];

      # Handheld daemon for controller/gyro/TDP management
      services.handheld-daemon = {
        enable = true;
        user = config.custom.user.name;
      };

      # SSD TRIM
      services.fstrim.enable = lib.mkDefault true;
    };
  };
}
