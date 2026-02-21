{...}: {
  flake.nixosModules.thinkpad-x1-nano = {
    config,
    lib,
    ...
  }: {
    options.custom.hardware.thinkpad-x1-nano.enable = lib.mkEnableOption "ThinkPad X1 Nano hardware tweaks";

    config = lib.mkIf config.custom.hardware.thinkpad-x1-nano.enable {
      # Enable fingerprint reader support
      services.fprintd.enable = true;

      # Captive portal browser interface
      programs.captive-browser.interface = "wlp1s0";
    };
  };
}
