{...}: let
  homeModule = {
    config,
    lib,
    ...
  }: {
    options.custom.profiles.laptop.enable = lib.mkEnableOption "laptop profile" // {default = false;};

    config = lib.mkIf config.custom.profiles.laptop.enable {
      # Battery indicator applet (only if waybar is enabled)
      services.cbatticon.enable = lib.mkIf config.custom.programs.waybar.enable true;
    };
  };
in {
  nixosModule = {
    config,
    lib,
    ...
  }: {
    options.custom.profiles.laptop.enable = lib.mkEnableOption "laptop profile" // {default = false;};

    config = lib.mkIf config.custom.profiles.laptop.enable {
      # Captive portal browser for WiFi login pages
      programs.captive-browser.enable = true;

      # Laptop power management
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

  inherit homeModule;
}
