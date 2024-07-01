{ inputs, lib, config, pkgs, ... }:
{
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  # Consistent theming
  stylix.image = config.lib.stylix.pixel "base0A";
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-dark.yaml";
}
