{...}: {
  nixosModule = {
    config,
    lib,
    ...
  }: {
    options.custom.hardware.cpu.amd.enable = lib.mkEnableOption "AMD CPU optimizations";

    config = lib.mkIf config.custom.hardware.cpu.amd.enable {
      # AMD microcode updates
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
  };
}
