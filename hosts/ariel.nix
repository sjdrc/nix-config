{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
  ];

  # Device config
  time.timeZone = "Australia/Melbourne";

  # Device hardware
  hardware.nvidia.open = true;
  hardware.nvidia.powerManagement.enable = true;

  # Device programs
  steam.enable = true;
  #piracy.enable = true;
  orca-slicer.enable = true;

  #services.ollama.enable = true;
  #services.ollama.acceleration = "cuda";
  #services.nextjs-ollama-llm-ui.enable = true;
}
