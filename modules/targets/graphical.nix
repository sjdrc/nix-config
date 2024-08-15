{ config, ... }:
{
  imports = [
    ../applications/hypr-de
    ../applications/firefox.nix
    ../applications/sddm.nix
    ../applications/kitty.nix
  ];

  services.gvfs.enable = true;
  programs.thunar.enable = true;

  home-manager.users.${config.user} = {
    gtk.enable = true;
    qt.enable = true;
  };
}
