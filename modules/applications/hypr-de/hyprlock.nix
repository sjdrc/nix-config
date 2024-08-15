{ config, ... }:
{
  security.pam.services.hyprlock = { };

  home-manager.users.${config.user} = {
    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          hide_cursor = true;
        };
        background = [
          {
            #color = "rgb(${config.lib.stylia.colors.base00})";
            blur_passes = 0;
          }
        ];
        input-field = [
          {
            size = "250, 50";
            position = "0, 0";
            dots_center = true;
            fade_on_empty = false;
            #inner_color = "rgb(${config.lib.stylix.colors.base06})";
            # Placeholder text config
            #font_color = "rgb(${config.lib.stylix.colors.base00})";
            placeholder_text = "<i>Password...</i>";
            fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
            # Outline config
            outline_thickness = 5;
            #outer_color = "rgb(${config.lib.stylix.colors.base02})";
            #check_color = "rgb(${config.lib.stylix.colors.base0A})";
            #fail_color = "rgb(${config.lib.stylix.colors.base08})";
          }
        ];
      };
    };
  };
}
