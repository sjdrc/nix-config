{config, ...}: {
  flake.nixosConfigurations.ariel = config.mkHost {
    hostModule = {
      networking.hostName = "ariel";
      custom.desktop.enable = true;
      custom.gaming.enable = true;
      custom.cpu-amd.enable = true;
      custom.gpu-nvidia.enable = true;
    };
  };
}
