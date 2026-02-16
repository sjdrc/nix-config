{...}: let
  homeModule = {
    lib,
    osConfig,
    ...
  }: {
    config = lib.mkIf osConfig.custom.profiles.desktop.enable {
      # Programs
      custom.programs.kitty.enable = true;
      custom.programs.zen-browser.enable = true;

      # User configuration
      gtk.enable = true;
      qt.enable = true;

      programs.mpv.enable = true;
    };
  };
in {
  nixosModule = {
    config,
    lib,
    pkgs,
    ...
  }: {
    options.custom.profiles.desktop.enable = lib.mkEnableOption "desktop environment";

    config = lib.mkIf config.custom.profiles.desktop.enable {
      # Programs
      custom.programs.niri.enable = true;
      custom.programs.tuigreet.enable = true;
      custom.programs.waybar.enable = true;

      # System configuration
      programs.appimage = {
        enable = true;
        binfmt = true;
      };

      # Desktop services
      programs.dconf.enable = true;
      services.gnome.gnome-keyring.enable = true;

      # Packages
      environment.systemPackages = with pkgs; [
        wdisplays
        wl-clipboard
        signal-desktop-bin
        sushi
        nautilus
        gnome-keyring
      ];
    };
  };

  inherit homeModule;
}
