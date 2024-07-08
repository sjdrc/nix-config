{ inputs, lib, config, pkgs, ... }:
{
  # Use latest kernel to solve shutdown/suspend hang issue
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
