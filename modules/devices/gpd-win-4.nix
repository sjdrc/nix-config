{ inputs, pkgs, ... }:
{
  # Do not enable - it fucks gpd win 4 mouse after 5 secs of idle
  powerManagement.powertop.enable = inputs.nixpkgs.lib.mkForce false;

  # Use latest kernel to solve shutdown/suspend hang issue
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
