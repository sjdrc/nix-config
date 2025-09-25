{...}: {
  flake = {
    nixosModules.default = {pkgs, ...}: {
      programs.appimage = {
        enable = true;
        binfmt = true;
      };
      environment.systemPackages = with pkgs; [
        wdisplays
        wl-clipboard
        signal-desktop-bin
        sushi
        nautilus
        mpv
      ];
    };
    homeModules.default = {pkgs, ...}: {
      gtk.enable = true;
      qt.enable = true;
      programs.kitty = {
        enable = true;
        settings = {
          open_url_with = "xdg-open";
          enable_audio_bell = false;
        };
      };
      programs.rofi.terminal = "${pkgs.kitty}/bin/kitty";
    };
  };
}
