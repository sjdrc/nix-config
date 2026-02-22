{...}: {
  flake.homeModules.waybar = {osConfig, lib, ...}: lib.mkIf osConfig.custom.waybar.enable {
    # System tray applets
    services.network-manager-applet.enable = true;
    services.pasystray.enable = true;

    programs.waybar = {
      enable = true;
      systemd.enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "bottom";
          height = 32;
          modules-right = [
            "clock"
            "tray"
          ];
          clock = {
            format = "{:%H:%M:%S %Y-%m-%d}";
            tooltip-format = "<big>{calendar}</big>";
            interval = 1;
          };
          tray = {
            icon-size = 16;
            spacing = 8;
          };
        };
      };
    };
  };

  flake.nixosModules.waybar = {config, lib, pkgs, ...}: {
    options.custom.waybar.enable = lib.mkEnableOption "Waybar status bar";
    config = lib.mkIf config.custom.waybar.enable {
      fonts.packages = [pkgs.font-awesome];
    };
  };
}
