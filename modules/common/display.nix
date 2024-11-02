{pkgs, ...}: {
  home-manager.users.sebastien.services.kanshi = let
    internalDisplay = "eDP-1";
  in {
    enable = true;
    settings = [
      {
        output.criteria = internalDisplay;
        output.scale = 1.25;
      }
      {
        profile.name = "docked";
        profile.outputs = [
          {
            criteria = internalDisplay;
            status = "disable";
          }
          {
            criteria = "*";
            status = "enable";
          }
        ];
      }
      {
        profile.name = "undocked";
        profile.outputs = [
          {
            criteria = internalDisplay;
            status = "enable";
          }
        ];
      }
    ];
  };
}
