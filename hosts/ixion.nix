{ inputs, system, ... }:
inputs.nixpkgs.lib.nixosSystem rec {
  inherit system;
  specialArgs = {
    inherit inputs system;
  };
  modules = [
    ../modules
    ../modules/devices/gpd-win-4.nix
    ../modules/targets/gaming.nix
    ../modules/targets/blackai.nix
    ./monitors.nix
    {
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

      # Enable graphics drivers
      hardware.amdgpu.initrd.enable = true;
      hardware.amdgpu.amdvlk.enable = true;
      hardware.amdgpu.amdvlk.supportExperimental.enable = true;
      hardware.amdgpu.amdvlk.support32Bit.enable = true;

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

      networking.useDHCP = inputs.nixpkgs.lib.mkDefault true;

      #nixpkgs.hostPlatform = "x86_64-linux";

      hardware.cpu.amd.updateMicrocode = true;

      programs.captive-browser.enable = true;
      programs.captive-browser.interface = "wlp1s0";
    }
  ];
}
