{pkgs, ...}: {
  fonts.packages = [pkgs.font-awesome];

  home-manager.users.sebastien = {
    services.blueman-applet.enable = true;
    services.network-manager-applet.enable = true;
    services.pasystray.enable = true;
    services.cbatticon.enable = true;

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
}
