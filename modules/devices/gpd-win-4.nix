{
  config,
  lib,
  pkgs,
  ...
}:
{
  # CPU is x86
  nixpkgs.hostPlatform = "x86_64-linux";

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

  # Monitor config
  home-manager.users.${config.user}.services.kanshi =
    let
      internalDisplay = "eDP-1";
      dellMonitor = "Dell Inc. DELL P3424WEB 210SDP3";
    in
    {
      enable = true;
      settings = [
        {
          output.criteria = internalDisplay;
          output.scale = 1.5;
        }
        {
          profile.name = "docked";
          profile.outputs = [
            {
              criteria = dellMonitor;
              status = "enable";
            }
            {
              criteria = internalDisplay;
              status = "disable";
            }
          ];
        }
        {
          profile.name = "undocked";
          profile.outputs = [
            {
              criteria = internalDisplay;
              status = "enable";
            }
          ];
        }
      ];
    };

}
