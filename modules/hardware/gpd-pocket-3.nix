{...}: let
  homeModule = {
    config,
    lib,
    ...
  }: {
    options.custom.hardware.gpd-pocket-3.enable = lib.mkEnableOption "GPD Pocket 3 hardware tweaks";

    config = lib.mkIf config.custom.hardware.gpd-pocket-3.enable {
      # Niri display settings for portrait mode
      programs.niri.settings = {
        outputs = {
          DSI-1 = {
            transform.rotation = 270;
            scale = 1.5;
          };
        };
      };
    };
  };
in {
  nixosModule = {
    config,
    lib,
    pkgs,
    ...
  }: {
    options.custom.hardware.gpd-pocket-3.enable = lib.mkEnableOption "GPD Pocket 3 hardware tweaks";

    config = lib.mkIf config.custom.hardware.gpd-pocket-3.enable {
      # Small screen console mode
      boot.loader.systemd-boot.consoleMode = "5";

      # Power saving kernel parameters
      boot.kernelParams = [
        "i915.enable_psr=1"
        "i915.enable_fbc=1"
        "pcie_aspm=force"
        "intel_idle.max_cstate=9"
      ];

      # Enable iio-sensor-proxy for accelerometer support
      services.udev.packages = [pkgs.iio-sensor-proxy];
      hardware.sensor.iio.enable = true;

      # Captive portal browser interface
      programs.captive-browser.interface = "wlp174s0";
    };
  };

  inherit homeModule;
}
