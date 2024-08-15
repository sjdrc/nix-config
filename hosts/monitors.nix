{ config, ... }:
{
  home-manager.users.${config.user} = {
    services.kanshi = {
      systemdTarget = "graphical-session.target";
      enable = true;
      profiles = {
        desk = {
          outputs = [
            {
              criteria = "eDP-1";
              status = "disable";
            }
            {
              criteria = "DP-1";
              status = "enable";
            }
          ];
        };
        couch = {
          outputs = [
            {
              criteria = "eDP-1";
              status = "disable";
            }
            {
              criteria = "DP-8";
              status = "enable";
            }
          ];
        };
        undocked = {
          outputs = [
            {
              criteria = "eDP-1";
              status = "enable";
              scale = 1.5;
            }
          ];
        };
      };
    };
  };
}
