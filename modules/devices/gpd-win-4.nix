{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Use latest kernel to solve shutdown/suspend hang issue
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable AMD CPU firmware updates
  hardware.cpu.amd.updateMicrocode = true;

  # Enable AMD GPU graphics drivers
  hardware.amdgpu.initrd.enable = true;
  hardware.amdgpu.amdvlk.enable = true;
  hardware.amdgpu.amdvlk.supportExperimental.enable = true;
  hardware.amdgpu.amdvlk.support32Bit.enable = true;

  # Do not enable - it fucks gpd win 4 mouse after 5 secs of idle
  powerManagement.powertop.enable = lib.mkForce false;

  home-manager.users.${config.user} = {
    services.kanshi = {
      systemdTarget = "graphical-session.target";
      enable = true;
      profiles = {
        handheld = {
          outputs = [
            {
              criteria = "eDP-1";
              status = "enable";
              scale = 1.5;
            }
          ];
        };
        docked = {
          outputs = [
            {
              criteria = "eDP-1";
              status = "disable";
            }
            {
              criteria = "*";
              status = "enable";
            }
          ];
        };
      };
    };
  };

}
