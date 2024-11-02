{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-nano-gen1
    ../modules
  ];

  #### Options #################################################################
  greeter = "regreet";
  desktop.hyprland.layout = "hy3";

  #### System Configuration ####################################################

  # Hardware config
  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.enableRedistributableFirmware = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Device config
  networking.hostName = "hyperion";
  networking.useDHCP = lib.mkDefault true;
  time.timeZone = "Australia/Melbourne";

  # Bootloader configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "thunderbolt"
    "usbhid"
  ];

  # Partition configuration
  boot.initrd.luks.devices."luks-32fa3d15-fa5f-4bc3-9df1-6bee41646301".device = "/dev/disk/by-uuid/32fa3d15-fa5f-4bc3-9df1-6bee41646301";
  boot.initrd.luks.devices."luks-bfc4c7e2-2c99-41ee-8a4c-1953158bd882".device = "/dev/disk/by-uuid/bfc4c7e2-2c99-41ee-8a4c-1953158bd882";

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/cc75d3cf-2cd6-46fe-b690-1a1ae454f0b4";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/F363-ADEA";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };
  };
  swapDevices = [{device = "/dev/disk/by-uuid/ce05be93-2bfb-4e1d-8fd6-f7721458fb7a";}];
}
