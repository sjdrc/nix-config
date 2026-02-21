{...}: {
  flake.nixosModules.gaming = {config, lib, pkgs, ...}: {
    options.custom.gaming.enable = lib.mkEnableOption "gaming profile";

    config = lib.mkIf config.custom.gaming.enable {
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
}
