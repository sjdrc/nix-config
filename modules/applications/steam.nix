{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    steam.enable = lib.mkEnableOption "steam";
  };

  config = lib.mkIf config.steam.enable {
    programs.steam = {
      enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
      gamescopeSession = {
        enable = true;
        env = {
          STEAM_DISPLAY_REFRESH_LIMITS = "40,60";
        };
        args = [
          # Gamescope arguments
          "--output-width"
          "1920"
          "--output-height"
          "1080"
          #"--nested-width" "1280"
          #"--nested-height" "720"
          "--max-scale"
          "2"
          "--filter"
          "fsr"
          "--fsr-sharpness"
          "0"
          "--backend"
          "drm"
          "--hide-cursor-delay"
          "--steam"
          "--force-windows-fullscreen"
          "--adaptive-sync"
          "--"
          # Steam arguments
          "steam"
          "-gamepadui"
          "-steamos3"
          "-steampal"
          "-steamdeck"
        ];
      };
      package = pkgs.steam.override {
        extraPkgs =
          pkgs: with pkgs; [
            # steamdeck first boot wizard skip
            (writeShellScriptBin "steamos-polkit-helpers/steamos-update" "exit 7")
            # switch to desktop
            (writeShellScriptBin "steamos-session-select" "kill $PPID")
          ];
      };
    };
    programs.gamescope.capSysNice = true;

    environment.systemPackages = with pkgs; [ steamtinkerlaunch ];

    # Enable MTU probing, as vendor does
    # See: https://github.com/ValveSoftware/SteamOS/issues/1006
    # See also: https://www.reddit.com/r/SteamDeck/comments/ymqvbz/ubisoft_connect_connection_lost_stuck/j36kk4w/?context=3
    boot.kernel.sysctl."net.ipv4.tcp_mtu_probing" = true;

    # Input device configuration
    services.handheld-daemon.enable = true;
    services.handheld-daemon.user = "sebastien";
    services.udev.packages = [ pkgs.game-devices-udev-rules ];
    hardware.uinput.enable = true;
    #services.joycond.enable = true;
  };
}
