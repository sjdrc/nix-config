{inputs, ...}: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
  ];

  # Device config
  time.timeZone = "Australia/Melbourne";
  networking.hostId = "0e977c20";

  # Device hardware
  hardware.nvidia.open = true;
  hardware.nvidia.powerManagement.enable = true;
}
