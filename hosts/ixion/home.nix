{ inputs, outputs, lib, config, pkgs, ... }:
{
  # Allow home-manager to manage itself
  programs.home-manager.enable = true;

  imports = [
    outputs.homeManagerModules.bash
    outputs.homeManagerModules.blackai
    outputs.homeManagerModules.hyprland
    outputs.homeManagerModules.monitors
    outputs.homeManagerModules.nvim
    outputs.homeManagerModules.terminal
  ];

  home = {
    username = "sebastien";
    homeDirectory = "/home/sebastien";
  };

  home.packages = with pkgs; [
    bambu-studio
  ];

  gtk.enable = true;
  qt.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
