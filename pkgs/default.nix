{ pkgs, ... }:
{
  hypr-workspace-layouts = pkgs.callPackage ./hypr-workspace-layouts.nix { };
}
