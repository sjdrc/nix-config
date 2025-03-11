{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.desktop.greeter;
  opt = "sddm";
in {
  options.desktop.greeter = lib.custom.mkChoice opt;

  config = lib.custom.mkIfChosen cfg opt {
    environment.systemPackages = [
      (pkgs.where-is-my-sddm-theme.override {
        themeConfig.General = {
          background = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          backgroundFill = config.lib.stylix.colors.base00;
          backgroundMode = "none";
        };
      })
    ];

    services.displayManager.sddm = {
      enable = true;
      package = pkgs.kdePackages.sddm;
      extraPackages = [pkgs.qt6.qt5compat];
      wayland.enable = true;
      theme = "where_is_my_sddm_theme";
    };
  };
}
