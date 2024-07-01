{ inputs, lib, config, pkgs, ...}:
{
  # Configure steam
  programs.steam = {
    enable = true;
	extraCompatPackages = [ pkgs.proton-ge-bin ];
	gamescopeSession = {
	  enable = true;
	  env = {
        STEAM_DISPLAY_REFRESH_LIMITS = "40,60";
	  };
	  args = [
	    "--output-width" "1920"
	    "--output-height" "1080"
		"--nested-width" "1280"
		"--nested-height" "720"
		"--max-scale" "2"
		"--filter" "fsr"
        "--fsr-sharpness" "0"
		"--backend" "drm"
		"--hide-cursor-delay" 
	    "--steam"
		"--force-windows-fullscreen"
		"--adaptive-sync"
		# End of gamescope arguments
        "--"
		"steam"
		# Steam arguments
		"-gamepadui" 
		"-steamos3"
		"-steampal"
		"-steamdeck"
	  ];
	};
	package = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
        # steamdeck first boot wizard skip
        (writeShellScriptBin "steamos-polkit-helpers/steamos-update" "exit 7")
        # switch to desktop
        (writeShellScriptBin "steamos-session-select" "kill $PPID")
	  ];
	};
  };
  programs.gamescope.capSysNice = true;

  # Enable MTU probing, as vendor does
  # See: https://github.com/ValveSoftware/SteamOS/issues/1006
  # See also: https://www.reddit.com/r/SteamDeck/comments/ymqvbz/ubisoft_connect_connection_lost_stuck/j36kk4w/?context=3
  boot.kernel.sysctl."net.ipv4.tcp_mtu_probing" = true;

  ## This rule allows the user to configure Wi-Fi in Deck UI.
  ##
  ## Steam modifies the system network configs via
  ## `org.freedesktop.NetworkManager.settings.modify.system`,
  ## which normally requires being in the `networkmanager` group.
  #security.polkit.extraConfig = ''
  #  // Jovian-NixOS/steam: Allow users to configure Wi-Fi in Deck UI
  #  polkit.addRule(function(action, subject) {
  #    if (
  #      action.id.indexOf("org.freedesktop.NetworkManager") == 0 &&
  #      subject.isInGroup("users") &&
  #      subject.local &&
  #      subject.active
  #    ) {
  #      return polkit.Result.YES;
  #    }
  #  });
  #'';

  ## See: https://github.com/Jovian-Experiments/PKGBUILDs-mirror/tree/jupiter-main/bluez
  #hardware.bluetooth.settings = {
  #  General = {
  #    MultiProfile = "multiple";
  #    FastConnectable = true;
  #    # enable experimental LL privacy, experimental offload codecs
  #    KernelExperimental = "15c0a148-c273-11ea-b3de-0242ac130004,a6695ace-ee7f-4fb9-881a-5fac66c629af";
  #  };
  #  LE = {
  #    ScanIntervalSuspend = 2240;
  #    ScanWindowSuspend = 224;
  #  };
  #};

  # Input device configuration
  services.handheld-daemon.enable = true;
  services.handheld-daemon.user = "sebastien";
  services.joycond.enable = true;
  services.udev.packages = [ pkgs.game-devices-udev-rules ];
  hardware.uinput.enable = true;
}
