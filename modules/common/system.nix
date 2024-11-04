{lib, ...}: {
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

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Power actions
  services.logind.powerKey = "suspend";
  services.upower.enable = true;
  services.upower.criticalPowerAction = "Hibernate";

  # Common host
  hardware.enableRedistributableFirmware = true;

  fileSystems = {
    "/" = {
      #device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      options = ["noatime" "nodiratime" "discard"];
    };
    "/boot" = {
      #device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };
  };
}
