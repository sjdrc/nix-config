{...}: {
  flake.nixosModules.gpu-nvidia = {config, lib, ...}: {
    options.custom.gpu-nvidia.enable = lib.mkEnableOption "NVIDIA GPU support";

    config = lib.mkIf config.custom.gpu-nvidia.enable {
      services.xserver.videoDrivers = ["nvidia"];
      hardware.graphics.enable = true;
      hardware.nvidia.modesetting.enable = lib.mkDefault true;
      hardware.nvidia.open = true;
      hardware.nvidia.powerManagement.enable = true;

      environment.sessionVariables = {
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        GBM_BACKEND = "nvidia-drm";
        WLR_NO_HARDWARE_CURSORS = "1";
      };
    };
  };
}
