{...}: {
  flake.nixosModules.cpu-amd = {config, lib, ...}: {
    options.custom.cpu-amd.enable = lib.mkEnableOption "AMD CPU optimizations";

    config = lib.mkIf config.custom.cpu-amd.enable {
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
  };
}
