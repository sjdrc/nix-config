{lib, ...}: {
  flake = {
    nixosModules.default = {config, lib, ...}: {
      options = {
        laptop.enable = lib.mkEnableOption "laptop";
      };

      config = lib.mkIf config.laptop.enable {
        services.tlp = {
          enable = true;
          settings = {
            # AC settings
            CPU_SCALING_GOVERNOR_ON_AC = "performance";
            CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

            # Battery Settings
            CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
            CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
            CPU_MAX_PERF_ON_BAT = 25;
            WIFI_POWER_ON_BAT = "on";

            USB_AUTOSUSPEND = 1;

            # Optimise battery health
            START_CHARGE_THRESH_BAT0 = 40;
            STOP_CHARGE_THRESH_BAT0 = 80;
          };
        };
        services.thermald.enable = true;
      };
    };
  };
}
