{
  nixosModule = {
    lib,
    config,
    ...
  }: {
    options.custom.system.audio.enable =
      lib.mkEnableOption "audio configuration"
      // {
        default = true;
      };

    config = lib.mkIf config.custom.system.audio.enable {
      # Audio configuration
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
