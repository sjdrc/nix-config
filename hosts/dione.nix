{
  inputs,
  pkgs,
  lib,
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

  # Intel AC 9560 wifi stability fix — downgrade from buggy firmware v46 to v43
  boot.extraModprobeConfig = "options iwlwifi uapsd_disable=1 power_save=0";
  hardware.firmware = let
    iwlwifi-fixed = pkgs.runCommand "iwlwifi-firmware-v43" {} ''
      mkdir -p $out/lib/firmware
      cp ${pkgs.linux-firmware}/lib/firmware/iwlwifi-9000-pu-b0-jf-b0-43.ucode $out/lib/firmware/
      ln -s iwlwifi-9000-pu-b0-jf-b0-43.ucode $out/lib/firmware/iwlwifi-9000-pu-b0-jf-b0-46.ucode
    '';
  in
    lib.mkBefore [iwlwifi-fixed];

  # Profiles
  custom.profiles.desktop.enable = true;
  custom.profiles.development.enable = true;
  custom.profiles.gaming.enable = true;
  custom.profiles.media-server.enable = true;
  custom.profiles."3d-printing".enable = true;
}
