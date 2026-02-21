{inputs, ...}: {
  flake.nixosModules.stylix = {
    inputs,
    config,
    pkgs,
    lib,
    ...
  }: {
    imports = [inputs.stylix.nixosModules.stylix];

    options.custom.system.stylix.enable =
      lib.mkEnableOption "stylix theming"
      // {
        default = true;
      };

    config = lib.mkIf config.custom.system.stylix.enable {
      stylix.enable = true;
      stylix.image = config.lib.stylix.pixel "base02";
      stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-dark.yaml";
      stylix.polarity = "dark";
      stylix.targets.gtk.enable = true;
      stylix.icons = {
        enable = true;
        package = pkgs.papirus-icon-theme;
        dark = "Papirus-Dark";
        light = "Papirus-Light";
      };
    };
  };
}
