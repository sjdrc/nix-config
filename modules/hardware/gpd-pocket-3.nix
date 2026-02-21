flakeArgs @ {...}: {
  flake.homeModules.gpd-pocket-3 = {...}: {
    programs.niri.settings = {
      outputs = {
        DSI-1 = {
          transform.rotation = 270;
          scale = 1.5;
        };
      };
    };
  };

  flake.nixosModules.gpd-pocket-3 = {config, lib, pkgs, ...}: {
    options.custom.gpd-pocket-3.enable = lib.mkEnableOption "GPD Pocket 3 hardware tweaks";

    config = lib.mkIf config.custom.gpd-pocket-3.enable (lib.mkMerge [
      {
        boot.loader.systemd-boot.consoleMode = "5";

        boot.kernelParams = [
          "i915.enable_psr=1"
          "i915.enable_fbc=1"
          "pcie_aspm=force"
          "intel_idle.max_cstate=9"
        ];

        services.udev.packages = [pkgs.iio-sensor-proxy];
        hardware.sensor.iio.enable = true;
        programs.captive-browser.interface = "wlp174s0";
      }
      # Only inject niri display settings when desktop/niri is enabled
      (lib.mkIf (config.custom.niri.enable or false) {
        home-manager.sharedModules = [flakeArgs.config.flake.homeModules.gpd-pocket-3];
      })
    ]);
  };
}
