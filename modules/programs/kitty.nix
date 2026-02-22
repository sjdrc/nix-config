{...}: {
  flake.homeModules.kitty = {osConfig, lib, ...}: lib.mkIf osConfig.custom.kitty.enable {
    programs.kitty = {
      enable = true;
      settings = {
        open_url_with = "xdg-open";
        enable_audio_bell = false;
      };
    };
    custom.niri.terminalCommand = ["kitty"];
  };

  flake.nixosModules.kitty = {lib, ...}: {
    options.custom.kitty.enable = lib.mkEnableOption "kitty terminal";
  };
}
