{...}: {
  flake.nixosModules.audio = {config, lib, ...}: {
    options.custom.audio.enable =
      lib.mkEnableOption "audio configuration"
      // {
        default = true;
      };

    config = lib.mkIf config.custom.audio.enable {
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
      };
    };
  };
}
