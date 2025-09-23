{pkgs, ...}: {
  home-manager.users.sebastien = {
    programs.kitty = {
      enable = true;
      settings = {
        open_url_with = "xdg-open";
        enable_audio_bell = false;
      };
    };
    programs.rofi.terminal = "${pkgs.kitty}/bin/kitty";
  };
}
