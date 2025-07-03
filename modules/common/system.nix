{lib, ...}: {
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  boot.supportedFilesystems = ["xfs"];
  # Audio configuration
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Bluetooth management
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Localisation
  i18n.defaultLocale = "en_AU.UTF-8";

  # Networking
  networking.useDHCP = lib.mkDefault true;
  networking.networkmanager.enable = true;

  # Power actions
  services.logind.powerKey = "suspend";
  services.upower.enable = true;
  services.upower.criticalPowerAction = "Hibernate";

  # Common host
  hardware.enableRedistributableFirmware = true;

  # Root filesystem
  # lsblk -o name,mountpoint,label,size,uuid
  # sudo cryptsetup config <disk> --label nixos-luks
  boot.initrd.luks.devices."nixos".device = "/dev/disk/by-label/nixos-luks";
  fileSystems = {
    "/" = {
      # sudo e2label <disk> nixos
      label = "nixos";
      fsType = "ext4";
      options = ["noatime" "nodiratime" "discard"];
    };
    "/boot" = {
      # sudo fatlabel <disk> boot
      label = "boot";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };
  };

  # Swap
  # sudo cryptsetup config <disk> --label swap-luks
  boot.initrd.luks.devices."swap".device = "/dev/disk/by-label/swap-luks";
  swapDevices = [
    {
      label = "swap";
    }
  ];
}
