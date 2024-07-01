{ inputs, outputs, lib, config, pkgs, ... }:
{
  services.power-profiles-daemon.enable = true;

  powerManagement.enable = true;
  powerManagement.powertop.enable = true;

  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };

  services.logind.powerKey = "suspend";

  services.upower.criticalPowerAction = "Hibernate";
}
