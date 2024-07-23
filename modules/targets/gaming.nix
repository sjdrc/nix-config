{ inputs, pkgs, ... }:
{
  imports = [ inputs.chaotic.nixosModules.default ];

  #chaotic.mesa-git.enable = true;
  #chaotic.mesa-git.extraPackages = with pkgs; [ amdvlk ];
  #chaotic.mesa-git.extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];

  # Configure steam
  #chaotic.steam.extraCompatPackages = with pkgs; [
  #  proton-ge-custom
  #  steamtinkerlaunch
  #];
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
  programs.gamescope.package = pkgs.gamescope.overrideAttrs (oldAttrs: {
    version = "3.14.22";
    src = pkgs.fetchFromGitHub {
      owner = "ValveSoftware";
      repo = "gamescope";
      rev = "refs/tags/3.14.22";
      fetchSubmodules = true;
      hash = "sha256-/muitEE3LCU6Xnjbpczb/zy2JRvUbBPT5L13T/v3MvE=";
    };
  });

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
}
