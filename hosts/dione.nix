{inputs, ...}: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
  ];

  # Device config
  time.timeZone = "Australia/Melbourne";

  # Device hardware
  hardware.nvidia.open = true;
  hardware.nvidia.powerManagement.enable = true;

  services.code-server = {
    enable = true;
    disableTelemetry = true;
    auth = "none";
    host = "0.0.0.0";
    user = "sebastien";
    group = "users";
  };
}
