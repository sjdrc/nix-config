{
  inputs,
  ...
}: {
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

  # Intel AC 9560: v46 firmware crashes (NMI_INTERRUPT_UMAC_FATAL) under network
  # load, but older versions (v43/v38/v34) don't support this hardware revision.
  # Disable 802.11n TX aggregation to reduce firmware stress.
  boot.extraModprobeConfig = "options iwlwifi 11n_disable=8";

  # Profiles
  custom.profiles.desktop.enable = true;
  custom.profiles.development.enable = true;
  custom.profiles.gaming.enable = true;
  custom.profiles.media-server.enable = true;
  custom.profiles."3d-printing".enable = true;
}
