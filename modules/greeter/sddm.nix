{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    greeter = lib.mkOption {
      type = with lib.types; nullOr (enum [ "sddm" ]);
    };
  };

  config = lib.mkIf (config.greeter == "sddm") {
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
      extraPackages = [ pkgs.qt6.qt5compat ];
      wayland.enable = true;
      theme = "where_is_my_sddm_theme";
    };
  };
}
