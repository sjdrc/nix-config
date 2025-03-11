{inputs, ...}: {
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-nano-gen1
  ];

  # Device config
  time.timeZone = "Australia/Melbourne";

  # Device hardware
  services.fprintd.enable = true;

  programs.captive-browser.enable = true;
  programs.captive-browser.interface = "wlp1s0";
}
