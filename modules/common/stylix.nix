{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [ inputs.stylix.nixosModules.stylix ];

  stylix.enable = true;
  stylix.image = config.lib.stylix.pixel "base02";
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/solarized-dark.yaml";
  stylix.targets.gtk.enable = true;
  stylix.targets.plymouth.enable = false;
}
