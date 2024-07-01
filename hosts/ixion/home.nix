{ inputs, outputs, lib, config, pkgs, ... }:
{
  # Allow home-manager to manage itself
  programs.home-manager.enable = true;

  imports = [
    outputs.homeManagerModules.bash
    outputs.homeManagerModules.hyprland
    outputs.homeManagerModules.nvim
  ];

  home = {
    username = "sebastien";
    homeDirectory = "/home/sebastien";
  };

  home.packages = with pkgs; [
    openlens
    slack
    systemctl-tui
  ];

  gtk.enable = true;
  qt.enable = true;

  programs.kitty = {
    enable = true;
    settings = {
      open_url_with = "xdg-open";
      enable_audio_bell = false;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
  };

  services.kanshi = {
    systemdTarget = "graphical-session.target";
    enable = true;
    profiles = {
      docked = {
        outputs = [
          {
            criteria = "eDP-1";
            status = "disable";
          }
          {
            criteria = "*";
            status = "enable";
          }
        ];
      };
      undocked = {
        outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            scale = 1.5;
          }
        ];
      };
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
