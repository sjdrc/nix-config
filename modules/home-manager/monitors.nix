{ ... }:
{
  services.kanshi = {
    systemdTarget = "graphical-session.target";
    enable = true;
    profiles = {
      docked = {
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
}