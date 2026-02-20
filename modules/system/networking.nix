{...}: {
  flake.nixosModules.networking = {
    lib,
    config,
    ...
  }: {
    options.custom.system.networking.enable =
      lib.mkEnableOption "networking configuration"
      // {
        default = true;
      };

    config = lib.mkIf config.custom.system.networking.enable {
      # Networking
      networking.useDHCP = lib.mkDefault true;
      networking.networkmanager.enable = true;
    };
  };
}
