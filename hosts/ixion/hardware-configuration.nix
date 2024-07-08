{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usbhid" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
    options = [ "noatime" "nodiratime" "discard" ];
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  boot.initrd.luks.devices."root".device = "/dev/disk/by-label/nixos-luks";
  boot.initrd.luks.devices."swap".device = "/dev/disk/by-label/swap-luks";

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
  swapDevices = [
    {
      device = "/dev/disk/by-label/swap";
    }
  ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
