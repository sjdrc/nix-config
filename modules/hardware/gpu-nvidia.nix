{...}: {
  nixosModule = {
    config,
    lib,
    ...
  }: {
    options.custom.hardware.gpu.nvidia.enable = lib.mkEnableOption "NVIDIA GPU support";

    config = lib.mkIf config.custom.hardware.gpu.nvidia.enable {
      # NVIDIA driver configuration
      services.xserver.videoDrivers = ["nvidia"];
      hardware.graphics.enable = true;
      hardware.nvidia.modesetting.enable = lib.mkDefault true;
      hardware.nvidia.open = true;
      hardware.nvidia.powerManagement.enable = true;

      # Early KMS for native resolution in Plymouth and TTYs
      boot.initrd.kernelModules = ["nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"];

      # NVIDIA-specific environment variables for Wayland compositors
      environment.sessionVariables = {
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        GBM_BACKEND = "nvidia-drm";
        WLR_NO_HARDWARE_CURSORS = "1";
      };
    };
  };
}
