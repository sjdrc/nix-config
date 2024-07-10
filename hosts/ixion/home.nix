{ inputs, outputs, lib, config, pkgs, ... }:
{
  imports = [
    outputs.homeManagerModules.bash
    outputs.homeManagerModules.blackai
    outputs.homeManagerModules.hyprland
    outputs.homeManagerModules.monitors
    outputs.homeManagerModules.home-manager
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
}