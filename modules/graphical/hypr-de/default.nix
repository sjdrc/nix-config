{ ... }:
{
  imports = [
    # Hyprland and plugins
    ./hyprland.nix
    #./hyprland-plugins/hy3.nix
    #./hyprland-plugins/hyprscroller.nix
    ./hyprland-plugins/hypr-dynamic-cursor.nix

    # Hypr suite tools
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./hyprshot.nix

    # Other window manager tools
    ./rofi.nix
    ./swaync.nix
    ./swayosd.nix
    ./waybar.nix
  ];
}
