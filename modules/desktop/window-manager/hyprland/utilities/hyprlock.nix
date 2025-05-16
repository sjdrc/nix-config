{...}: {
  security.pam.services.hyprlock = {};

  home-manager.users.sebastien = {
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          hide_cursor = true;
        };
      };
    };
  };
}
