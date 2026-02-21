{...}: {
  flake.nixosModules.networking = {config, lib, ...}: {
    options.custom.networking.enable =
      lib.mkEnableOption "networking configuration"
      // {
        default = true;
      };

    config = lib.mkIf config.custom.networking.enable {
      networking.useDHCP = lib.mkDefault true;
      networking.networkmanager.enable = true;
    };
  };
}
