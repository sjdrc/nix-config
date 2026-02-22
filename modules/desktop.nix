{...}: {
  imports = [
    ./programs/niri.nix
    ./programs/nirinit.nix
    ./programs/tuigreet.nix
    ./programs/waybar.nix
    ./programs/kitty.nix
    ./programs/anyrun.nix
    ./programs/wlogout.nix
    ./programs/zen-browser.nix
  ];

  flake.homeModules.desktop = {osConfig, lib, ...}: lib.mkIf osConfig.custom.desktop.enable {
    gtk.enable = true;
    qt.enable = true;
    programs.mpv.enable = true;
    # blueman-applet moved here from bluetooth system module
    services.blueman-applet.enable = true;
  };

  flake.nixosModules.desktop = {config, lib, pkgs, ...}: {
    options.custom.desktop.enable = lib.mkEnableOption "desktop environment";

    config = lib.mkIf config.custom.desktop.enable {
      custom.niri.enable = true;
      custom.nirinit.enable = true;
      custom.tuigreet.enable = true;
      custom.waybar.enable = true;
      custom.kitty.enable = true;
      custom.anyrun.enable = true;
      custom.wlogout.enable = true;
      custom.zen-browser.enable = true;

      programs.appimage = {
        enable = true;
        binfmt = true;
      };

      programs.dconf.enable = true;
      services.gnome.gnome-keyring.enable = true;

      fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-color-emoji
      ];

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
}
