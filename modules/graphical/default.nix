{ config, ... }:
{
  imports = [
    ./hypr-de
    ./applications.nix
    ./firefox.nix
    ./kitty.nix
    ./sddm.nix
  ];

  services.gvfs.enable = true;
  programs.thunar.enable = true;

  home-manager.users.${config.user} = {
    gtk.enable = true;
    qt.enable = true;
  };
}
