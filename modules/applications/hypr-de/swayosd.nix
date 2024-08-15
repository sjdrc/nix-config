{ config, ... }:
{
  home-manager.users.${config.user} = {
    services.swayosd = {
      enable = true;
      topMargin = 0.1;
    };
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        bind = [
          # Brightness and volume controls
          ", XF86AudioLowerVolume,  exec, swayosd-client --output-volume lower"
          ", XF86AudioRaiseVolume,  exec, swayosd-client --output-volume raise"
          ", XF86AudioMute,         exec, swayosd-client --output-volume mute-toggle"
          ", XF86AudioMicMute,      exec, swayosd-client --input-volume mute-toggle"
          ", XF86MonBrightnessDown, exec, swayosd-client --brightness lower"
          ", XF86MonBrightnessUp,   exec, swayosd-client --brightness raise"
        ];
      };
    };
  };
}
