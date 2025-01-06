{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    hyprland.layout = lib.mkOption {
      type = with lib.types; nullOr (enum ["hy3"]);
    };
  };

  config = lib.mkIf (config.hyprland.layout == "hy3") {
    home-manager.users.sebastien = {
      wayland.windowManager.hyprland = {
        plugins = [pkgs.hyprlandPlugins.hy3];
        settings = {
          general = {
            layout = "hy3";
          };
          plugin.hy3 = {
            autotile = {
              enable = true;
              trigger_width = 900;
              trigger_height = -1;
            };
          };
          bind = [
            "$MOD+SHIFT,       Q,                hy3:killactive,"
            "$MOD,             backspace,        hy3:makegroup, opposite, ephemeral"
            "$MOD,             left,             hy3:movefocus, l"
            "$MOD,             right,            hy3:movefocus, r"
            "$MOD,             up,               hy3:movefocus, u"
            "$MOD,             down,             hy3:movefocus, d"
            "$MOD+SHIFT,       left,             hy3:movewindow, l"
            "$MOD+SHIFT,       right,            hy3:movewindow, r"
            "$MOD+SHIFT,       up,               hy3:movewindow, u"
            "$MOD+SHIFT,       down,             hy3:movewindow, d"
          ];
        };
      };
    };
  };
}
