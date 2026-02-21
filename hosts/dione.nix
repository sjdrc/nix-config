{inputs, ...}: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
  ];

  # Hardware
  custom.hardware.cpu.intel.enable = true;
  custom.hardware.gpu.nvidia.enable = true;

  # Data SSD
  # sudo e2label <disk> data
  fileSystems."/data" = {
    label = "data";
    fsType = "ext4";
    options = ["noatime" "nodiratime" "discard"];
  };

  # Intel AC 9560 wifi stability fix (firmware v46 is buggy)
  boot.extraModprobeConfig = "options iwlwifi uapsd_disable=1 power_save=0";

  # Profiles
  custom.profiles.desktop.enable = true;
  custom.profiles.development.enable = true;
  custom.profiles.gaming.enable = true;
  custom.profiles.media-server.enable = true;
  custom.profiles."3d-printing".enable = true;
}
