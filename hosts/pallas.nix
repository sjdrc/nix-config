{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.gpd-pocket-3
  ];

  laptop.enable = true;

  boot.loader.systemd-boot.consoleMode = "5";

  # Power saving kernel parameters
  boot.kernelParams = [
    "i915.enable_psr=1"
    "i915.enable_fbc=1"
    "pcie_aspm=force"
    "intel_idle.max_cstate=9"
  ];

  # Device config
  time.timeZone = "Australia/Melbourne";

  # Device hardware
  #services.fprintd.enable = true;
  #environment.systemPackages = [
  #  pkgs.libfprint-focaltech-2808-a658
  #];

  programs.captive-browser.enable = true;
  programs.captive-browser.interface = "wlp174s0";

  # Enable iio-sensor-proxy for accelerometer support
  services.udev.packages = [pkgs.iio-sensor-proxy];
  hardware.sensor.iio.enable = true;

  home-manager.users.sebastien = {
    programs.niri.settings = {
      outputs = {
        DSI-1 = {
          transform.rotation = 270;
          scale = 1.5;
        };
      };
    };
  };
}
