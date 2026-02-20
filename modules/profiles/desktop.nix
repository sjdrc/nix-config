{...}: {
  flake.nixosModules.desktop = {
    config,
    lib,
    pkgs,
    ...
  }: {
    options.custom.profiles.desktop.enable = lib.mkEnableOption "desktop environment";

    config = lib.mkIf config.custom.profiles.desktop.enable {
      # Programs
      custom.programs.niri.enable = true;
      custom.programs.nirinit.enable = true;
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

      # Fonts for broad Unicode coverage (symbols, CJK, emoji)
      fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-color-emoji
      ];

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

  flake.homeModules.desktop = {
    lib,
    osConfig,
    ...
  }: {
    config = lib.mkIf (osConfig != null && osConfig.custom.profiles.desktop.enable) {
      # Programs
      custom.programs.kitty.enable = true;
      custom.programs.anyrun.enable = true;
      custom.programs.wlogout.enable = true;
      custom.programs.zen-browser.enable = true;

      # User configuration
      gtk.enable = true;
      qt.enable = true;

      programs.mpv.enable = true;
    };
  };
}
