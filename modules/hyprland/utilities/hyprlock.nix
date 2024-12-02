{config, ...}: {
  security.pam.services.hyprlock = {};

  home-manager.users.sebastien = {
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          hide_cursor = true;
        };
      };
    };
  };
}
