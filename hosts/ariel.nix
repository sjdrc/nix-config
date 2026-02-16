{inputs, ...}: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
  ];

  # Hardware
  custom.hardware.cpu.amd.enable = true;
  custom.hardware.gpu.nvidia.enable = true;

  # Profiles
  custom.profiles.desktop.enable = true;
  custom.profiles.gaming.enable = true;
}
