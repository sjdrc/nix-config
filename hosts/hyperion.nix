{inputs, ...}: {
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-nano-gen1
  ];

  # Hardware
  custom.hardware.thinkpad-x1-nano.enable = true;

  # Profiles
  custom.profiles.laptop.enable = true;
}
