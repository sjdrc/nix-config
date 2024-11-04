{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    steam.enable = lib.mkEnableOption "steam";
  };

  config = lib.mkIf config.steam.enable {
    programs.steam = {
      enable = true;
      extraCompatPackages = [pkgs.proton-ge-bin];
    };
    services.udev.packages = [pkgs.game-devices-udev-rules];
    hardware.uinput.enable = true;
  };
}
