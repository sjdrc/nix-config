{inputs, ...}: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  # Device hardware
  hardware.nvidia.open = true;
  hardware.nvidia.powerManagement.enable = true;
}
