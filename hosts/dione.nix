{inputs, ...}: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
  ];

  # Partition config
  fileSystems."/".device = "/dev/disk/by-uuid/d4f136b6-6c38-4bb6-abc4-bc12b25c8ec4";
  fileSystems."/boot".device = "/dev/disk/by-uuid/C5FE-DA8C";
  boot.initrd.luks.devices."luks-93ae1eee-7fb5-4e5d-9001-20f0f737984e".device = "/dev/disk/by-uuid/93ae1eee-7fb5-4e5d-9001-20f0f737984e";
  boot.initrd.luks.devices."luks-fca3190e-a8a3-48d7-a50e-98bd1d062b40".device = "/dev/disk/by-uuid/fca3190e-a8a3-48d7-a50e-98bd1d062b40";
  swapDevices = [ { device = "/dev/disk/by-uuid/0d428da7-82de-488c-bdd4-19efb78e8db9"; } ];

  # Device config
  networking.hostName = "dione";
  nixpkgs.hostPlatform = "x86_64-linux";
  time.timeZone = "Australia/Melbourne";

  # Device options
  hardware.nvidia.open = true;
}
