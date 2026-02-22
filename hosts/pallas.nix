{config, ...}: {
  flake.nixosConfigurations.pallas = config.mkHost {
    hostModule = {
      networking.hostName = "pallas";
      custom.laptop.enable = true;
      custom.gpd-pocket-3.enable = true;
    };
  };
}
