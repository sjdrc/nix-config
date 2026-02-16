{
  homeModule = {
    pkgs,
    config,
    lib,
    ...
  }: {
    options.custom.programs.kitty.enable = lib.mkEnableOption "kitty terminal";

    config = lib.mkIf config.custom.programs.kitty.enable {
      programs.kitty = {
        enable = true;
        settings = {
          open_url_with = "xdg-open";
          enable_audio_bell = false;
        };
      };
      programs.rofi.terminal = "${pkgs.kitty}/bin/kitty";
    };
  };
}
