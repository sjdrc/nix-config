{...}: {
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_MAX_PERF_ON_BAT = 25;

      WIFI_POWER_ON_BAT = "on";
      USB_AUTOSUSPEND = 1;

      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };
  services.thermald.enable = true;
  boot.kernelParams = [
    "i915.enable_psr=1"
    "i915.enable_fbc=1"
    "pcie_aspm=force"
    "intel_idle.max_cstate=9"
  ];
}
