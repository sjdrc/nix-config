{...}: {
  flake.nixosModules.thinkpad-x1-nano = {config, lib, pkgs, ...}: {
    options.custom.thinkpad-x1-nano.enable = lib.mkEnableOption "ThinkPad X1 Nano hardware tweaks";

    config = lib.mkIf config.custom.thinkpad-x1-nano.enable {
      services.fprintd.enable = true;
      programs.captive-browser.interface = "wlp1s0";

      # TrackPoint (from lenovo/thinkpad)
      hardware.trackpoint.enable = lib.mkDefault true;
      hardware.trackpoint.emulateWheel = lib.mkDefault config.hardware.trackpoint.enable;

      # Blacklist ath3k when redistributable firmware is disabled (from common/pc)
      boot.blacklistedKernelModules = lib.optionals (!config.hardware.enableRedistributableFirmware) [
        "ath3k"
      ];

      # SSD TRIM (from common/pc/ssd)
      services.fstrim.enable = lib.mkDefault true;

      # Audio fix for X1 Nano Gen1 (from lenovo/thinkpad/x1-nano/gen1)
      environment.systemPackages = [pkgs.alsa-utils];
      systemd.services.x1-fix = {
        description = "Use alsa-utils to fix sound interference on Thinkpad x1 Nano";
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.alsa-tools}/bin/hda-verb /dev/snd/hwC0D0 0x1d SET_PIN_WIDGET_CONTROL 0x0";
          Restart = "on-failure";
        };
        wantedBy = ["default.target"];
      };
    };
  };
}
