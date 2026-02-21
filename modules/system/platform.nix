{...}: {
  flake.nixosModules.platform = {config, lib, ...}: {
    options.custom.platform.enable =
      lib.mkEnableOption "platform configuration"
      // {
        default = true;
      };

    config = lib.mkIf config.custom.platform.enable {
      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.enableRedistributableFirmware = true;
      services.upower.enable = true;
      services.upower.criticalPowerAction = "Hibernate";
    };
  };
}
