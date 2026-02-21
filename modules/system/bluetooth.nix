{...}: {
  flake.nixosModules.bluetooth = {config, lib, pkgs, ...}: {
    options.custom.bluetooth.enable =
      lib.mkEnableOption "bluetooth configuration"
      // {
        default = true;
      };

    config = lib.mkIf config.custom.bluetooth.enable {
      hardware.bluetooth.enable = true;
      services.blueman.enable = true;
      environment.systemPackages = with pkgs; [
        bluetuith
      ];
    };
  };
}
