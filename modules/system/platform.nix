{...}: {
  flake.nixosModules.platform = {
    lib,
    config,
    ...
  }: {
    options.custom.system.platform.enable =
      lib.mkEnableOption "platform configuration"
      // {
        default = true;
      };

    config = lib.mkIf config.custom.system.platform.enable {
      # Host platform architecture
      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

      # Enable proprietary firmware
      hardware.enableRedistributableFirmware = true;

      # Power management
      services.upower.enable = true;
      services.upower.criticalPowerAction = "Hibernate";
    };
  };
}
