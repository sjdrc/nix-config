{...}: {
  flake.nixosModules.thinkpad-x1-nano = {config, lib, ...}: {
    options.custom.thinkpad-x1-nano.enable = lib.mkEnableOption "ThinkPad X1 Nano hardware tweaks";

    config = lib.mkIf config.custom.thinkpad-x1-nano.enable {
      services.fprintd.enable = true;
      programs.captive-browser.interface = "wlp1s0";
    };
  };
}
