{ inputs, lib, pkgs, config, ... }:
{
  imports = [
    # Include default configuration
    ../modules
  ];
  
  # System Name
  networking.hostName = "ariel";
  nixpkgs.hostPlatform = "x86_64-linux";
  time.timeZone = "Australia/Melbourne";
  
  #### Options #################################################################
  greeter = "regreet";
  desktop.hyprland.layout = "hy3";
  steam.enable = true;

  #### System Configuration ####################################################

  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };


  # Partition configuration
  boot.initrd.luks.devices."luks-6d720271-a312-4897-9b1b-d9339aaaf4d1".device = "/dev/disk/by-uuid/6d720271-a312-4897-9b1b-d9339aaaf4d1";
  boot.initrd.luks.devices."luks-8297c7f2-d86b-4a05-9897-10faea6bbb0a".device = "/dev/disk/by-uuid/8297c7f2-d86b-4a05-9897-10faea6bbb0a";

  fileSystems."/".device = "/dev/disk/by-uuid/ef436f29-3683-438f-9cd3-413854602208";
  fileSystems."/boot".device = "/dev/disk/by-uuid/BA80-D4E3";
  swapDevices = [ { device = "/dev/disk/by-uuid/41e61358-92cd-4d12-8a08-722984b1a710"; } ];
}