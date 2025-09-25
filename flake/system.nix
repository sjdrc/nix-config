{lib, ...}: {
  flake = {
    nixosModules.default = {...}: {
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
      #hardware.bluetooth.enable = true;
      #services.blueman.enable = true;

      # Localisation
      i18n.defaultLocale = "en_AU.UTF-8";

      # Networking
      networking.useDHCP = lib.mkDefault true;
      networking.networkmanager.enable = true;

      # Power actions
      services.upower.enable = true;
      services.upower.criticalPowerAction = "Hibernate";

      # Common host
      hardware.enableRedistributableFirmware = true;
    };
  };
}
