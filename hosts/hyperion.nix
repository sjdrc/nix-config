{inputs, ...}: {
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-nano-gen1
  ];

  # Device config
  time.timeZone = "Australia/Melbourne";

  # Device hardware
  services.fprintd.enable = true;
}
