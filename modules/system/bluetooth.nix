{...}: let
  homeModule = {
    config,
    lib,
    osConfig,
    ...
  }: {
    config = lib.mkIf osConfig.custom.system.bluetooth.enable {
      # Bluetooth system tray applet (only if waybar is enabled)
      services.blueman-applet.enable = lib.mkIf osConfig.custom.programs.waybar.enable true;
    };
  };
in {
  nixosModule = {
    lib,
    config,
    pkgs,
    ...
  }: {
    options.custom.system.bluetooth.enable =
      lib.mkEnableOption "bluetooth configuration"
      // {
        default = true;
      };

    config = lib.mkIf config.custom.system.bluetooth.enable {
      # Bluetooth hardware support
      hardware.bluetooth.enable = true;

      # Bluetooth GUI management
      services.blueman.enable = true;

      # Bluetooth TUI (bluetuith) in system packages
      environment.systemPackages = with pkgs; [
        bluetuith
      ];
    };
  };

  inherit homeModule;
}
