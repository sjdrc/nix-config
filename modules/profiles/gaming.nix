{...}: {
  flake.nixosModules.gaming = {
    config,
    lib,
    pkgs,
    ...
  }: {
    options.custom.profiles.gaming.enable = lib.mkEnableOption "gaming profile" // {default = false;};

    config = lib.mkIf config.custom.profiles.gaming.enable {
      # Gaming system setup
      programs.gamescope = {
        enable = true;
        capSysNice = true;
      };

      programs.steam = {
        enable = true;
        gamescopeSession.enable = true;
        package = pkgs.steam.override {
          extraPkgs = pkgs':
            with pkgs'; [
              libxcursor
              libxi
              libxinerama
              libxscrnsaver
              libpng
              libpulseaudio
              libvorbis
              stdenv.cc.cc.lib
              libkrb5
              keyutils
            ];
        };
        remotePlay.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        extraCompatPackages = [pkgs.proton-ge-bin];
      };

      environment.systemPackages = with pkgs; [
        steam-tui
        prismlauncher
      ];

      services.udev.packages = [pkgs.game-devices-udev-rules];
      hardware.uinput.enable = true;
    };
  };

  flake.homeModules.gaming = {
    lib,
    osConfig,
    ...
  }: {
    config = lib.mkIf (osConfig != null && osConfig.custom.profiles.gaming.enable) {
      # Future: gaming-specific user tools can go here
    };
  };
}
