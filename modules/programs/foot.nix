{...}: {
  flake.homeModules.foot = {osConfig, lib, ...}: lib.mkIf osConfig.custom.foot.enable {
    programs.foot = {
      enable = true;
      settings.main = {
        pad = "4x4";
      };
    };
    custom.niri.terminalCommand = lib.mkForce ["foot"];
  };

  flake.nixosModules.foot = {lib, ...}: {
    options.custom.foot.enable = lib.mkEnableOption "foot terminal";
  };
}
