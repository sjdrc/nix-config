{ pkgs, ... }:
{
  powerManagement.enable = true;

  environment.systemPackages = with pkgs; [ python312Packages.pyasyncore ];

  services.auto-cpufreq.enable = false;
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
  services.upower.enable = true;
  services.upower.criticalPowerAction = "Hibernate";
}
