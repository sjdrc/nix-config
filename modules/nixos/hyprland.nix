{ inputs, lib, config, pkgs, ... }:
{
  programs.hyprland.enable = true;
  programs.hyprland.package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;

  # Screen locker
  security.pam.services.hyprlock = {};

  environment.sessionVariables = {
    # Ensure cursor is visible
	WLR_NO_HARDWARE_CURSORS = "1";
	# Force wayland for electron applications
    NIXOS_OZONE_WL = "1";
  };

  # Fonts for icons
  fonts.packages = with pkgs; [ font-awesome ];
  
  services.blueman.enable = true;

  # Enable sound
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  
  services.gvfs.enable = true;
  programs.thunar.enable = true;
}
