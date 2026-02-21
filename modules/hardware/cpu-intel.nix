{...}: {
  flake.nixosModules.cpu-intel = {config, lib, ...}: {
    options.custom.cpu-intel.enable = lib.mkEnableOption "Intel CPU optimizations";

    config = lib.mkIf config.custom.cpu-intel.enable {
      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
  };
}
