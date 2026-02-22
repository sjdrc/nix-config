{config, ...}: {
  flake.nixosConfigurations.hyperion = config.mkHost {
    hostModule = {
      networking.hostName = "hyperion";
      custom.laptop.enable = true;
      custom.thinkpad-x1-nano.enable = true;
      custom.gpu-intel.enable = true;
    };
  };
}
