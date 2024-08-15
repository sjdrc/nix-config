{ lib, ... }:
{
  imports = [
    # Include default configuration
    ../modules

    # Configuration for this device
    ../modules/devices/gpd-win-4.nix

    # Steam + Gamescope
    ../modules/targets/gaming.nix

    # Work setup
    ../modules/targets/blackai.nix
  ];

  networking.hostName = "ixion";
  time.timeZone = "Europe/Berlin";

  hardware.enableRedistributableFirmware = true;

  # Bootloader configuration
  boot.loader.systemd-boot.enable = true;
  boot.plymouth.enable = true;
  boot.initrd.verbose = false;
  boot.consoleLogLevel = 0;
  boot.initrd.systemd.enable = true;
  boot.kernelParams = [
    "quiet"
    "splash"
    "systemd.show_status=auto"
    "rd.udev.log_level=3"
  ];
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "thunderbolt"
    "usbhid"
  ];

  # Partition configuration
  boot.initrd.luks.devices."root".device = "/dev/disk/by-label/nixos-luks";
  boot.initrd.luks.devices."swap".device = "/dev/disk/by-label/swap-luks";
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      options = [
        "noatime"
        "nodiratime"
        "discard"
      ];
    };
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
  };
  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  networking.useDHCP = lib.mkDefault true;

  programs.captive-browser.enable = true;
  programs.captive-browser.interface = "wlp1s0";

}
