{inputs, ...}: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
  ];

  # Hardware
  custom.hardware.cpu.intel.enable = true;
  custom.hardware.gpu.nvidia.enable = true;

  # Profiles
  custom.profiles.desktop.enable = true;
  custom.profiles.gaming.enable = true;
  custom.profiles.media-server.enable = true;
  custom.profiles."3d-printing".enable = true;
}
