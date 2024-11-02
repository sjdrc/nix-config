{lib, ...}: {
  options = {
    greeter = lib.mkOption {
      description = "Display manager to use";
      type = with lib.types; nullOr (enum []);
    };
  };

  config = {
    services.fprintd = {
      enable = true;
    };

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
    networking.networkmanager.enable = true;

    # Enable the OpenSSH daemon.
    services.openssh.enable = true;

    # Power actions
    services.logind.powerKey = "suspend";
    services.upower.enable = true;
    services.upower.criticalPowerAction = "Hibernate";
  };
}
