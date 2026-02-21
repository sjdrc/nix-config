flakeArgs @ {...}: {
  flake.homeModules.kitty = {...}: {
    programs.kitty = {
      enable = true;
      settings = {
        open_url_with = "xdg-open";
        enable_audio_bell = false;
      };
    };
    custom.niri.terminalCommand = ["kitty"];
  };

  flake.nixosModules.kitty = {config, lib, ...}: {
    options.custom.kitty.enable = lib.mkEnableOption "kitty terminal";
    config = lib.mkIf config.custom.kitty.enable {
      home-manager.sharedModules = [flakeArgs.config.flake.homeModules.kitty];
    };
  };
}
