{inputs, ...}: {
  imports = [
    inputs.nixos-hardware.nixosModules.gpd-pocket-3
  ];

  # Hardware
  custom.hardware.gpd-pocket-3.enable = true;

  # Profiles
  custom.profiles.laptop.enable = true;
}
