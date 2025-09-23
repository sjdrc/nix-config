{inputs, ...}: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
    "${inputs.nixos-hardware}/common/gpu/nvidia/ampere"
  ];

  # Device config
  time.timeZone = "Australia/Melbourne";

  # Device programs
  steam.enable = true;
  #piracy.enable = true;
  orca-slicer.enable = true;
}
