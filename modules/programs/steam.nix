{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    #inputs.jovian.nixosModules.default
  ];
  options = {
    steam.enable = lib.mkEnableOption "steam";
  };

  config = lib.mkIf config.steam.enable {
    programs.gamescope = {
      enable = true;
      capSysNice = true;
    };
    programs.steam.gamescopeSession = {
      enable = true;
    };

    #jovian.steam.enable = true;
    #jovian.steam.autoStart = true;
    #jovian.steam.desktopSession = "Niri";

    #jovian.decky-loader.enable = true;
    #jovian.devices.steamdeck.enableControllerUdevRules = true;
    #jovian.steam.user = "sebastien";
    #jovian.steamos.useSteamOSConfig = true;

    programs.steam = {
      enable = true;
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

    environment.systemPackages = with pkgs; [steam-tui];

    services.udev.packages = [pkgs.game-devices-udev-rules];
    hardware.uinput.enable = true;
  };
}
